TS ?= tree-sitter

all install uninstall clean:
	+$(MAKE) -f common/parser.mk LANGUAGE=luau SRC_DIR=src GRAMMAR=grammar.js GRAMMAR_DEPS=grammar.js QUERY_DIR=queries DESCRIPTION='Tree-sitter grammar for Luau' $@

test:
	$(TS) test

.PHONY: all install uninstall clean test
