#!/usr/bin/env nu

use std/assert

def main []: nothing -> nothing {
    $env.CC = "clang"

    let root_path: path = "test/upstream/luau"

    assert ($root_path | path exists) "Luau submodule is missing; run `git submodule update --init --recursive`"

    let root: path = $root_path | path expand

    let invalid: list<string> = (
        open --raw test/upstream-invalid.txt
        | lines
        | str trim
        | where (($it | is-not-empty) and not ($it | str starts-with "#"))
        | sort
    )

    let files: list<path> = glob test/upstream/luau/**/*.luau

    assert ($files | is-not-empty) "Luau submodule contains no .luau fixtures"

    let manifest: path = mktemp
    $files | str join (char newline) | save --force $manifest

    let result: record = tree-sitter parse --config-path test/config.json --grammar-path . --paths $manifest --quiet --json-summary | complete
    rm $manifest

    print --stderr --no-newline $result.stderr

    if $result.exit_code not-in [0 1] {
        exit $result.exit_code
    }

    let summary: record = (
        $result.stdout
        | lines
        | skip until {|line| $line == "{" }
        | str join (char newline)
        | from json
    )

    let failures: list<string> = (
        $summary.parse_summaries
        | where not $it.successful
        | get file
        | each {|file| $file | path relative-to $root | path split | str join / }
        | sort
    )

    if $failures != $invalid or $summary.cumulative_stats.total_parses != ($files | length) {
        print --stderr --no-newline $result.stdout
        exit 1
    }

    print $"Checked ($files | length) upstream fixtures, including ($invalid | length) expected syntax errors"
}
