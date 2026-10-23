#include "tree_sitter/parser.h"

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

enum TokenType {
    BLOCK_COMMENT_START,
    BLOCK_COMMENT_CONTENT,
    BLOCK_COMMENT_END,
    LINE_COMMENT_START,
    LINE_COMMENT_CONTINUATION,
    LINE_COMMENT_PREFIX,
    LINE_COMMENT_END,
    LINE_COMMENT_CONTENT,
    LONG_STRING,
    INTERPOLATION_OPEN,
    DECIMAL_ESCAPE,
};

typedef struct {
    uint32_t delimiter_depth;
    bool standalone;
} Scanner;

static void advance(TSLexer *lexer) {
    lexer->advance(lexer, false);
}

static void skip(TSLexer *lexer) {
    lexer->advance(lexer, true);
}

static bool consume(TSLexer *lexer, int32_t character) {
    if (lexer->lookahead != character) {
        return false;
    }

    advance(lexer);

    return true;
}

static bool scan_long_bracket(TSLexer *lexer) {
    if (!consume(lexer, '[')) {
        return false;
    }

    unsigned delimiter_depth = 0;

    while (consume(lexer, '=')) {
        delimiter_depth++;
    }

    if (!consume(lexer, '[')) {
        return false;
    }

    while (!lexer->eof(lexer)) {
        if (!consume(lexer, ']')) {
            advance(lexer);
            continue;
        }

        unsigned closing_depth = 0;

        while (consume(lexer, '=')) {
            closing_depth++;
        }

        if (closing_depth == delimiter_depth && consume(lexer, ']')) {
            lexer->mark_end(lexer);

            return true;
        }
    }

    return false;
}

static bool scan_comment_start(Scanner *scanner, TSLexer *lexer, bool standalone) {
    if (!consume(lexer, '-') || !consume(lexer, '-')) {
        return false;
    }

    scanner->standalone = standalone && lexer->lookahead != '!';

    lexer->mark_end(lexer);

    if (consume(lexer, '[')) {
        uint32_t delimiter_depth = 0;

        while (consume(lexer, '=')) {
            delimiter_depth++;
        }

        if (consume(lexer, '[')) {
            scanner->delimiter_depth = delimiter_depth;
            lexer->mark_end(lexer);
            lexer->result_symbol = BLOCK_COMMENT_START;

            return true;
        }
    } else {
        consume(lexer, ' ');
        lexer->mark_end(lexer);
    }

    lexer->result_symbol = LINE_COMMENT_START;

    return true;
}

static bool scan_block_comment(Scanner *scanner, TSLexer *lexer, const bool *valid_symbols) {
    bool content = false;

    while (!lexer->eof(lexer)) {
        if (lexer->lookahead != ']') {
            advance(lexer);
            content = true;
            continue;
        }

        lexer->mark_end(lexer);
        advance(lexer);

        uint32_t closing_depth = 0;

        while (consume(lexer, '=')) {
            closing_depth++;
        }

        if (closing_depth == scanner->delimiter_depth && consume(lexer, ']')) {
            if (content) {
                lexer->result_symbol = BLOCK_COMMENT_CONTENT;
            } else {
                lexer->mark_end(lexer);
                lexer->result_symbol = BLOCK_COMMENT_END;
            }

            return valid_symbols[lexer->result_symbol];
        }

        content = true;
    }

    return false;
}

void *tree_sitter_luau_external_scanner_create(void) {
    return calloc(1, sizeof(Scanner));
}

void tree_sitter_luau_external_scanner_destroy(void *payload) {
    free(payload);
}

unsigned tree_sitter_luau_external_scanner_serialize(void *payload, char *buffer) {
    Scanner *scanner = payload;

    for (unsigned index = 0; index < sizeof(scanner->delimiter_depth); index++) {
        buffer[index] = (char)(scanner->delimiter_depth >> (index * 8));
    }

    buffer[sizeof(scanner->delimiter_depth)] = scanner->standalone;

    return sizeof(scanner->delimiter_depth) + 1;
}

void tree_sitter_luau_external_scanner_deserialize(void *payload, const char *buffer, unsigned length) {
    Scanner *scanner = payload;

    scanner->delimiter_depth = 0;
    scanner->standalone = false;

    if (length == sizeof(scanner->delimiter_depth) + 1) {
        for (unsigned index = 0; index < sizeof(scanner->delimiter_depth); index++) {
            scanner->delimiter_depth |= (uint32_t)(uint8_t)buffer[index] << (index * 8);
        }

        scanner->standalone = buffer[sizeof(scanner->delimiter_depth)] != 0;
    }
}

bool tree_sitter_luau_external_scanner_scan(void *payload, TSLexer *lexer, const bool *valid_symbols) {
    Scanner *scanner = payload;

    if (valid_symbols[LINE_COMMENT_END] && valid_symbols[DECIMAL_ESCAPE]) {
        return false;
    }

    if (valid_symbols[BLOCK_COMMENT_CONTENT] || valid_symbols[BLOCK_COMMENT_END]) {
        return scan_block_comment(scanner, lexer, valid_symbols);
    }

    if (valid_symbols[LINE_COMMENT_CONTENT] && lexer->lookahead != '\r' && lexer->lookahead != '\n' &&
        !lexer->eof(lexer)) {
        do {
            advance(lexer);
        } while (lexer->lookahead != '\r' && lexer->lookahead != '\n' && !lexer->eof(lexer));

        lexer->mark_end(lexer);
        lexer->result_symbol = LINE_COMMENT_CONTENT;

        return true;
    }

    if (valid_symbols[LINE_COMMENT_CONTINUATION] || valid_symbols[LINE_COMMENT_END]) {
        lexer->mark_end(lexer);
        lexer->result_symbol = LINE_COMMENT_END;

        if (!scanner->standalone || (lexer->lookahead != '\r' && lexer->lookahead != '\n')) {
            return true;
        }

        while (lexer->lookahead == ' ' || lexer->lookahead == '\t' || lexer->lookahead == '\v' ||
               lexer->lookahead == '\f' || lexer->lookahead == '\r' || lexer->lookahead == '\n') {
            bool newline = lexer->lookahead == '\r' || lexer->lookahead == '\n';
            advance(lexer);

            if (newline) {
                lexer->mark_end(lexer);
            }
        }

        if (!consume(lexer, '-') || !consume(lexer, '-') || lexer->lookahead == '!') {
            return true;
        }

        if (consume(lexer, '[')) {
            while (consume(lexer, '=')) {
            }

            if (consume(lexer, '[')) {
                return true;
            }
        }

        lexer->result_symbol = LINE_COMMENT_CONTINUATION;

        return true;
    }

    if (valid_symbols[DECIMAL_ESCAPE] && lexer->lookahead == '\\') {
        advance(lexer);

        if (lexer->lookahead < '0' || lexer->lookahead > '9') {
            return false;
        }

        unsigned value = 0;
        unsigned digits = 0;

        do {
            value = value * 10 + (unsigned)(lexer->lookahead - '0');
            digits++;
            advance(lexer);
        } while (digits < 3 && lexer->lookahead >= '0' && lexer->lookahead <= '9');

        if (value > 255) {
            return false;
        }

        lexer->mark_end(lexer);
        lexer->result_symbol = DECIMAL_ESCAPE;

        return true;
    }

    if (valid_symbols[INTERPOLATION_OPEN] && lexer->lookahead == '{') {
        advance(lexer);

        if (lexer->lookahead == '{') {
            return false;
        }

        lexer->mark_end(lexer);

        lexer->result_symbol = INTERPOLATION_OPEN;

        return true;
    }

    if (valid_symbols[INTERPOLATION_OPEN] || valid_symbols[DECIMAL_ESCAPE]) {
        return false;
    }

    bool continuation = valid_symbols[LINE_COMMENT_PREFIX];
    bool standalone = continuation || lexer->get_column(lexer) == 0;

    while (lexer->lookahead == ' ' || lexer->lookahead == '\t' || lexer->lookahead == '\v' ||
           lexer->lookahead == '\f' || lexer->lookahead == '\r' || lexer->lookahead == '\n') {
        if (lexer->lookahead == '\r' || lexer->lookahead == '\n') {
            standalone = true;
        }

        if (continuation) {
            advance(lexer);
        } else {
            skip(lexer);
        }
    }

    if (lexer->lookahead == '-' && (valid_symbols[LINE_COMMENT_START] || continuation)) {
        if (!scan_comment_start(scanner, lexer, standalone)) {
            return false;
        }

        if (continuation) {
            lexer->result_symbol = LINE_COMMENT_PREFIX;
        }

        return true;
    }

    if (lexer->lookahead == '[' && valid_symbols[LONG_STRING]) {
        if (scan_long_bracket(lexer)) {
            lexer->result_symbol = LONG_STRING;

            return true;
        }

        return false;
    }

    return false;
}
