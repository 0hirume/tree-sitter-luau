# tree-sitter-luau

A [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for [Luau](https://luau.org/).

The `luau` grammar supports typed Luau, interpolated and long strings, attributes, explicit type
arguments, `const` declarations, type functions, declaration files, exported values, integer
literals, user-defined classes including open classes, and if-local and if-const conditions.
It uses the `source.luau` scope and `.luau` files. Queries are included for highlighting, locals,
indentation, folding, text objects, and injections.

## C library

The parser can be built and installed with CMake or Make as `tree-sitter-luau`.

```sh
cmake -S . -B build
cmake --build build
```

## Development

Install the tools declared in `mise.toml` and initialize the pinned Luau test corpus:

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
mise run lint
mise run format
mise run queries:copy -- [helix-checkout]
```

`test:upstream` parses the pinned Luau corpus with the Luau parser.

Edit `grammar.js` for Luau rules and `common/scanner.h` for the external scanner.
`mise run generate` refreshes the generated parser under `src/`.

`mise run queries:copy -- [helix-checkout]` copies the Helix query set into the checkout's
`runtime/queries/luau` directory. Without a checkout argument, it uses the first available Helix
runtime. Register the repository root as the `luau` grammar.

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
