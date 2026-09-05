LANGUAGE_NAME := tree-sitter-$(LANGUAGE)
HOMEPAGE_URL := https://github.com/0hirume/tree-sitter-luau
VERSION := 0.1.0

TS ?= tree-sitter

PREFIX ?= /usr/local
DATADIR ?= $(PREFIX)/share
INCLUDEDIR ?= $(PREFIX)/include
LIBDIR ?= $(PREFIX)/lib
BINDIR ?= $(PREFIX)/bin
PCLIBDIR ?= $(LIBDIR)/pkgconfig

PARSER := $(SRC_DIR)/parser.c
EXTRAS := $(filter-out $(PARSER),$(wildcard $(SRC_DIR)/*.c))
OBJS := $(patsubst %.c,%.o,$(PARSER) $(EXTRAS))
HEADER := bindings/c/tree_sitter/$(LANGUAGE_NAME).h
PACKAGE_CONFIG := bindings/c/$(LANGUAGE_NAME).pc.in

ARFLAGS ?= rcs
override CFLAGS += -I$(SRC_DIR) -std=c11 -fPIC

SONAME_MAJOR = $(shell sed -n 's/\#define LANGUAGE_VERSION //p' $(PARSER))
SONAME_MINOR = $(word 1,$(subst ., ,$(VERSION)))

MACHINE := $(shell $(CC) -dumpmachine)

ifneq ($(findstring darwin,$(MACHINE)),)
	SOEXT = dylib
	SOEXTVER_MAJOR = $(SONAME_MAJOR).$(SOEXT)
	SOEXTVER = $(SONAME_MAJOR).$(SONAME_MINOR).$(SOEXT)
	LINKSHARED = -dynamiclib -Wl,-install_name,$(LIBDIR)/lib$(LANGUAGE_NAME).$(SOEXTVER),-rpath,@executable_path/../Frameworks
else ifneq ($(findstring mingw32,$(MACHINE)),)
	SOEXT = dll
	LINKSHARED += -s -shared -Wl,--out-implib,lib$(LANGUAGE_NAME).dll.a
else
	SOEXT = so
	SOEXTVER_MAJOR = $(SOEXT).$(SONAME_MAJOR)
	SOEXTVER = $(SOEXT).$(SONAME_MAJOR).$(SONAME_MINOR)
	LINKSHARED = -shared -Wl,-soname,lib$(LANGUAGE_NAME).$(SOEXTVER)
ifneq ($(filter $(shell uname),FreeBSD NetBSD DragonFly),)
	PCLIBDIR := $(PREFIX)/libdata/pkgconfig
endif
endif

all: lib$(LANGUAGE_NAME).a lib$(LANGUAGE_NAME).$(SOEXT) $(LANGUAGE_NAME).pc

lib$(LANGUAGE_NAME).a: $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

lib$(LANGUAGE_NAME).$(SOEXT): $(OBJS)
	$(CC) $(LDFLAGS) $(LINKSHARED) $^ $(LDLIBS) -o $@
ifneq ($(STRIP),)
	$(STRIP) $@
endif

$(LANGUAGE_NAME).pc: $(PACKAGE_CONFIG)
	sed -e 's|@PROJECT_VERSION@|$(VERSION)|' \
		-e 's|@CMAKE_INSTALL_LIBDIR@|$(LIBDIR:$(PREFIX)/%=%)|' \
		-e 's|@CMAKE_INSTALL_INCLUDEDIR@|$(INCLUDEDIR:$(PREFIX)/%=%)|' \
		-e 's|@PROJECT_DESCRIPTION@|$(DESCRIPTION)|' \
		-e 's|@PROJECT_HOMEPAGE_URL@|$(HOMEPAGE_URL)|' \
		-e 's|@CMAKE_INSTALL_PREFIX@|$(PREFIX)|' $< > $@

$(SRC_DIR)/grammar.json: $(GRAMMAR_DEPS)
	$(TS) generate --no-parser --js-runtime=native --output $(SRC_DIR) $(GRAMMAR)

$(PARSER): $(SRC_DIR)/grammar.json
	$(TS) generate --abi=15 --js-runtime=native --output $(SRC_DIR) $^

$(SRC_DIR)/scanner.o: common/scanner.h

install: all
	install -d '$(DESTDIR)$(DATADIR)'/tree-sitter/queries/$(LANGUAGE) '$(DESTDIR)$(INCLUDEDIR)'/tree_sitter '$(DESTDIR)$(PCLIBDIR)' '$(DESTDIR)$(LIBDIR)'
	install -m644 $(HEADER) '$(DESTDIR)$(INCLUDEDIR)'/tree_sitter/$(LANGUAGE_NAME).h
	install -m644 $(LANGUAGE_NAME).pc '$(DESTDIR)$(PCLIBDIR)'/$(LANGUAGE_NAME).pc
	install -m644 lib$(LANGUAGE_NAME).a '$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).a
ifneq ($(findstring mingw32,$(MACHINE)),)
	install -d '$(DESTDIR)$(BINDIR)'
	install -m755 lib$(LANGUAGE_NAME).dll '$(DESTDIR)$(BINDIR)'/lib$(LANGUAGE_NAME).dll
	install -m644 lib$(LANGUAGE_NAME).dll.a '$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).dll.a
else
	install -m755 lib$(LANGUAGE_NAME).$(SOEXT) '$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).$(SOEXTVER)
	cd '$(DESTDIR)$(LIBDIR)' && ln -sf lib$(LANGUAGE_NAME).$(SOEXTVER) lib$(LANGUAGE_NAME).$(SOEXTVER_MAJOR)
	cd '$(DESTDIR)$(LIBDIR)' && ln -sf lib$(LANGUAGE_NAME).$(SOEXTVER_MAJOR) lib$(LANGUAGE_NAME).$(SOEXT)
endif
ifneq ($(wildcard $(QUERY_DIR)/*.scm),)
	install -m644 $(QUERY_DIR)/*.scm '$(DESTDIR)$(DATADIR)'/tree-sitter/queries/$(LANGUAGE)
endif

uninstall:
	$(RM) '$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).a \
		'$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).$(SOEXTVER) \
		'$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).$(SOEXTVER_MAJOR) \
		'$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).$(SOEXT) \
		'$(DESTDIR)$(LIBDIR)'/lib$(LANGUAGE_NAME).dll.a \
		'$(DESTDIR)$(BINDIR)'/lib$(LANGUAGE_NAME).dll \
		'$(DESTDIR)$(INCLUDEDIR)'/tree_sitter/$(LANGUAGE_NAME).h \
		'$(DESTDIR)$(PCLIBDIR)'/$(LANGUAGE_NAME).pc
	$(RM) -r '$(DESTDIR)$(DATADIR)'/tree-sitter/queries/$(LANGUAGE)

clean:
	$(RM) $(OBJS) $(LANGUAGE_NAME).pc lib$(LANGUAGE_NAME).a lib$(LANGUAGE_NAME).$(SOEXT) lib$(LANGUAGE_NAME).dll.a

.PHONY: all install uninstall clean
