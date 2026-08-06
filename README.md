# tree-sitter-luau

A [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for
[Luau](https://luau.org/).

It supports typed Luau, interpolated and long strings, attributes, explicit type arguments, `const`
declarations, type functions, declaration files, exported values, integer literals, and
user-defined classes.

Queries are included for highlighting, locals, indentation, folding, text objects, and injections.

## Development

Install the tools declared in `mise.toml` and initialize the Luau test corpus:

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
```

Edit `grammar.js` for grammar rules, `src/scanner.c` for external tokens, and `queries/` for editor
queries. `mise run generate` refreshes the generated files under `src/`.

## License

MIT
