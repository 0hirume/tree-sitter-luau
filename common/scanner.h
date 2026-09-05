#ifndef TREE_SITTER_LUAU_COMMON_SCANNER_H_
#define TREE_SITTER_LUAU_COMMON_SCANNER_H_

#include "tree_sitter/parser.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <wctype.h>

enum TokenType {
  BLOCK_COMMENT,
  LONG_STRING,
#ifdef TREE_SITTER_LUAUX
  MARKUP_TEXT,
  MARKUP_COMMENT_TEXT,
#endif
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

#ifdef TREE_SITTER_LUAUX
static bool scan_markup_text(TSLexer *lexer) {
  bool has_content = false;
  bool has_newline = false;
  bool has_non_whitespace = false;

  while (!lexer->eof(lexer) && lexer->lookahead != '<' && lexer->lookahead != '{') {
    has_content = true;
    has_newline |= lexer->lookahead == '\n';
    has_non_whitespace |= !iswspace((wint_t)lexer->lookahead);

    if (lexer->lookahead != '\\') {
      advance(lexer);
      continue;
    }

    advance(lexer);
    if (lexer->eof(lexer) || lexer->lookahead == '<') {
      continue;
    }

    has_newline |= lexer->lookahead == '\n';
    has_non_whitespace |= !iswspace((wint_t)lexer->lookahead);
    advance(lexer);
  }

  if (has_content) {
    lexer->mark_end(lexer);
  }

  return has_content && (!has_newline || has_non_whitespace);
}

static bool scan_markup_comment_text(TSLexer *lexer) {
  bool has_content = false;

  while (!lexer->eof(lexer)) {
    lexer->mark_end(lexer);

    if (lexer->lookahead != '-') {
      has_content = true;
      advance(lexer);
      continue;
    }

    advance(lexer);
    if (lexer->lookahead != '-') {
      has_content = true;
      continue;
    }

    advance(lexer);
    if (lexer->lookahead == '>') {
      return has_content;
    }

    has_content = true;
  }

  lexer->mark_end(lexer);
  return has_content;
}
#endif

static bool external_scanner_scan(TSLexer *lexer, const bool *valid_symbols) {
#ifdef TREE_SITTER_LUAUX
  if (valid_symbols[MARKUP_COMMENT_TEXT]) {
    lexer->result_symbol = MARKUP_COMMENT_TEXT;
    return scan_markup_comment_text(lexer);
  }

  if (valid_symbols[MARKUP_TEXT]) {
    lexer->result_symbol = MARKUP_TEXT;
    return scan_markup_text(lexer);
  }
#endif

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

  return false;
}

#endif // TREE_SITTER_LUAU_COMMON_SCANNER_H_
