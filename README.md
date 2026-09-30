# tree-sitter-luau

Tree-sitter grammar for Luau.

## Development

```sh
mise install
git submodule update --init --recursive
tree-sitter generate --js-runtime native --abi 15
tree-sitter test
nu scripts/upstream.nu
```

## C library

```sh
cmake -S . -B build
cmake --build build
```

[MIT](LICENSE)
