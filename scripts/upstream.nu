#!/usr/bin/env nu

use std/assert

def main []: nothing -> nothing {
    $env.CC = "clang"

    let root_path: path = "test/upstream/luau"

    assert ($root_path | path exists) "Luau submodule is missing; run `git submodule update --init --recursive`"

    let root: path = $root_path | path expand

    let ignored: list<string> = (
        open --raw test/upstream-invalid.txt
        | lines
        | str trim
        | where (($it | is-not-empty) and not ($it | str starts-with "#"))
    )

    let files: list<path> = (
        glob test/upstream/luau/**/*.luau
        | where (($it | path relative-to $root | path split | str join /) not-in $ignored)
    )

    assert ($files | is-not-empty) "Luau submodule contains no .luau fixtures"

    let manifest: path = mktemp
    $files | str join (char newline) | save --force $manifest

    let result: record = tree-sitter parse --config-path test/config.json --grammar-path . --paths $manifest --quiet --stat | complete
    rm $manifest

    print --no-newline $result.stdout
    print --stderr --no-newline $result.stderr
    exit $result.exit_code
}
