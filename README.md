# tree-sitter-luau

[Tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammars for
[Luau](https://luau.org/) and [LuauX](https://github.com/luau-xml/luaux).

The `luau` grammar supports typed Luau, interpolated and long strings, attributes, explicit type
arguments, `const` declarations, type functions, declaration files, exported values, integer
literals, user-defined classes including open classes, and if-local and if-const conditions. The
inherited `luaux` grammar adds elements, fragments, attributes, text, comments, and expression
holes while retaining the complete Luau grammar.

Luau uses the `source.luau` scope and `.luau` files. LuauX uses the separate `source.luaux` scope
and `.luaux` files. Queries are included for highlighting, locals, indentation, folding, text
objects, and injections.

## C library

Both parsers can be built and installed with CMake or Make. The resulting libraries are named
`tree-sitter-luau` and `tree-sitter-luaux`.

```sh
cmake -S . -B build
cmake --build build
```

## Development

Install the tools declared in `mise.toml` and initialize the pinned Luau and LuauX test corpora:

```sh
mise install
git submodule update --init --recursive
```

Run the complete check suite:

```sh
mise run check
```

Individual tasks are available for focused work:

```sh
mise run generate
mise run test
mise run test:upstream
mise run test:upstream:luaux
mise run lint
mise run format
mise run queries:copy -- [helix-checkout]
```

`test:upstream` parses the pinned Luau corpus with the Luau parser. `test:upstream:luaux` parses
all tracked upstream `.luaux` fixtures and the same Luau corpus with the LuauX parser.

Edit `grammar.js` for Luau rules and `luaux/grammar.js` for LuauX additions. External scanner
logic is shared through `common/scanner.h`. `mise run generate` refreshes both generated parsers
under `src/` and `luaux/src/`.

`mise run queries:copy -- [helix-checkout]` copies the Helix query sets into the checkout's
`runtime/queries/luau` and `runtime/queries/luaux` directories. Without a checkout argument, it
uses the first available Helix runtime. Register the repository root as the `luau` grammar and the
`luaux` subpath as the separate `luaux` grammar.

Roblox type highlights are generated from the vendored snapshots in `spec/`. Normal development
uses those snapshots and does not require either upstream checkout:

```sh
nu scripts/queries.nu check
nu scripts/queries.nu sync
```

Import a newer snapshot from an explicit Creator Docs checkout with:

```sh
nu scripts/queries.nu update <creator-docs-directory>
```

## License

MIT
