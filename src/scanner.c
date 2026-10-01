#include "tree_sitter/parser.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

enum TokenType {
    BLOCK_COMMENT,
    LONG_STRING,
    INTERPOLATION_OPEN,
    DECIMAL_ESCAPE,
};

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

static bool scan_long_bracket(TSLexer *lexer, bool comment) {
    if (comment) {
        if (!consume(lexer, '-')) {
            return false;
        }

        if (!consume(lexer, '-')) {
            return false;
        }
    }

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

void *tree_sitter_luau_external_scanner_create(void) {
    return NULL;
}

void tree_sitter_luau_external_scanner_destroy(void *payload) {
    (void)payload;
}

unsigned tree_sitter_luau_external_scanner_serialize(void *payload, char *buffer) {
    (void)payload;
    (void)buffer;

    return 0;
}

void tree_sitter_luau_external_scanner_deserialize(void *payload, const char *buffer, unsigned length) {
    (void)payload;
    (void)buffer;
    (void)length;
}

bool tree_sitter_luau_external_scanner_scan(void *payload, TSLexer *lexer, const bool *valid_symbols) {
    (void)payload;

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

    if (!valid_symbols[INTERPOLATION_OPEN] && !valid_symbols[DECIMAL_ESCAPE]) {
        while (lexer->lookahead == ' ' || lexer->lookahead == '\t' || lexer->lookahead == '\v' || lexer->lookahead == '\f' || lexer->lookahead == '\r' || lexer->lookahead == '\n') {
            skip(lexer);
        }
    }

    if (lexer->lookahead == '-' && valid_symbols[BLOCK_COMMENT]) {
        if (scan_long_bracket(lexer, true)) {
            lexer->result_symbol = BLOCK_COMMENT;

            return true;
        }

        return false;
    }

    if (lexer->lookahead == '[' && valid_symbols[LONG_STRING]) {
        if (scan_long_bracket(lexer, false)) {
            lexer->result_symbol = LONG_STRING;

            return true;
        }

        return false;
    }

    return false;
}
