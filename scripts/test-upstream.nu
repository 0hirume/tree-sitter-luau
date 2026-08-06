#!/usr/bin/env nu

$env.CC = "clang"

let root_path = "test/upstream/luau"

if not ($root_path | path exists) {
  error make { msg: "Luau submodule is missing; run `git submodule update --init --recursive`" }
}

let root = ($root_path | path expand)
let ignored = (
  open test/upstream-invalid.txt
  | lines
  | str trim
  | where { not ($in | is-empty) and not ($in | str starts-with "#") }
)

let files = (
  glob test/upstream/luau/**/*.luau
  | where {|path|
      let relative = (
        $path
        | path relative-to $root
        | path split
        | str join "/"
      )

      $relative not-in $ignored
    }
)

if ($files | is-empty) {
  error make { msg: "Luau submodule contains no .luau fixtures" }
}

tree-sitter parse --config-path test/config.json --grammar-path . ...$files --quiet --stat
