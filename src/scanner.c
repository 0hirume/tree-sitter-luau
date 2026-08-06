#include "tree_sitter/parser.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

enum TokenType {
  BLOCK_COMMENT,
  LONG_STRING,
  INTERPOLATED_STRING,
  INTERPOLATION_START,
  INTERPOLATION_MIDDLE,
  INTERPOLATION_END,
};

static void advance(TSLexer *lexer) { lexer->advance(lexer, false); }

static void skip(TSLexer *lexer) { lexer->advance(lexer, true); }

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

  lexer->mark_end(lexer);
  return true;
}

static void scan_escape(TSLexer *lexer) {
  advance(lexer);

  if (lexer->eof(lexer)) {
    return;
  }

  if (lexer->lookahead == 'u') {
    advance(lexer);
    if (consume(lexer, '{')) {
      while (!lexer->eof(lexer) && lexer->lookahead != '}') {
        advance(lexer);
      }
      consume(lexer, '}');
    }
    return;
  }

  if (lexer->lookahead == 'z') {
    advance(lexer);
    while (lexer->lookahead == ' ' || lexer->lookahead == '\t' || lexer->lookahead == '\v' ||
           lexer->lookahead == '\f' || lexer->lookahead == '\r' || lexer->lookahead == '\n') {
      advance(lexer);
    }
    return;
  }

  if (lexer->lookahead == '\r') {
    advance(lexer);
    consume(lexer, '\n');
    return;
  }

  advance(lexer);
}

static bool scan_interpolation(TSLexer *lexer, bool initial, const bool *valid_symbols) {
  if (initial) {
    if (!consume(lexer, '`')) {
      return false;
    }
  } else if (!consume(lexer, '}')) {
    return false;
  }

  while (!lexer->eof(lexer)) {
    switch (lexer->lookahead) {
    case '\\':
      scan_escape(lexer);
      break;

    case '{':
      advance(lexer);
      lexer->mark_end(lexer);
      if (initial && valid_symbols[INTERPOLATION_START]) {
        lexer->result_symbol = INTERPOLATION_START;
        return true;
      }
      if (!initial && valid_symbols[INTERPOLATION_MIDDLE]) {
        lexer->result_symbol = INTERPOLATION_MIDDLE;
        return true;
      }
      return false;

    case '`':
      advance(lexer);
      lexer->mark_end(lexer);
      if (initial && valid_symbols[INTERPOLATED_STRING]) {
        lexer->result_symbol = INTERPOLATED_STRING;
        return true;
      }
      if (!initial && valid_symbols[INTERPOLATION_END]) {
        lexer->result_symbol = INTERPOLATION_END;
        return true;
      }
      return false;

    case '\r':
    case '\n':
      return false;

    default:
      advance(lexer);
      break;
    }
  }

  return false;
}

void *tree_sitter_luau_external_scanner_create(void) { return NULL; }

void tree_sitter_luau_external_scanner_destroy(void *payload) { (void)payload; }

unsigned tree_sitter_luau_external_scanner_serialize(void *payload, char *buffer) {
  (void)payload;
  (void)buffer;
  return 0;
}

void tree_sitter_luau_external_scanner_deserialize(void *payload, const char *buffer,
                                                   unsigned length) {
  (void)payload;
  (void)buffer;
  (void)length;
}

bool tree_sitter_luau_external_scanner_scan(void *payload, TSLexer *lexer,
                                            const bool *valid_symbols) {
  (void)payload;

  while (lexer->lookahead == ' ' || lexer->lookahead == '\t' || lexer->lookahead == '\v' ||
         lexer->lookahead == '\f' || lexer->lookahead == '\r' || lexer->lookahead == '\n') {
    skip(lexer);
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

  if (lexer->lookahead == '`' &&
      (valid_symbols[INTERPOLATED_STRING] || valid_symbols[INTERPOLATION_START])) {
    return scan_interpolation(lexer, true, valid_symbols);
  }

  if (lexer->lookahead == '}' &&
      (valid_symbols[INTERPOLATION_MIDDLE] || valid_symbols[INTERPOLATION_END])) {
    return scan_interpolation(lexer, false, valid_symbols);
  }

  return false;
}
