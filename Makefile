TS ?= tree-sitter

all install uninstall clean:
	+$(MAKE) -f common/parser.mk LANGUAGE=luau SRC_DIR=src GRAMMAR=grammar.js GRAMMAR_DEPS=grammar.js QUERY_DIR=queries DESCRIPTION='Tree-sitter grammar for Luau' $@
	+$(MAKE) -f common/parser.mk LANGUAGE=luaux SRC_DIR=luaux/src GRAMMAR=luaux/grammar.js GRAMMAR_DEPS='grammar.js luaux/grammar.js' QUERY_DIR=luaux/queries DESCRIPTION='Tree-sitter grammar for LuauX' $@

test:
	$(TS) test

.PHONY: all install uninstall clean test
