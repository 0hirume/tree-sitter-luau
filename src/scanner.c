#include "../common/scanner.h"

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
  return external_scanner_scan(lexer, valid_symbols);
}
