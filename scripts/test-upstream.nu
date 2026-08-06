#!/usr/bin/env nu

def fail [message: string]: nothing -> error {
    error make {
        msg: $message
        label: {
            text: $message
            span: (metadata $message).span
        }
    }
}

def main []: nothing -> nothing {
    $env.CC = "clang"

    let root_path: path = "test/upstream/luau"

    if not ($root_path | path exists) {
        fail "Luau submodule is missing; run `git submodule update --init --recursive`"
    }

    let root: path = $root_path | path expand
    let ignored: list<string> = try {
        open --raw test/upstream-invalid.txt
        | lines
        | str trim
        | where (($it | is-not-empty) and not ($it | str starts-with "#"))
    } catch {|error| fail $"Failed to read the upstream exclusion list: ($error.msg)" }

    let files: list<path> = (
      glob test/upstream/luau/**/*.luau
      | each {|path|
          {
            path: $path
            relative: (
              $path
              | path relative-to $root
              | path split
              | str join /
            )
          }
        }
      | where relative not-in $ignored
      | get path
    )

    if ($files | is-empty) {
        fail "Luau submodule contains no .luau fixtures"
    }

    tree-sitter parse --config-path test/config.json --grammar-path . ...$files --quiet --stat
}
