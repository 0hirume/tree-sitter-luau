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

def fixtures [root_path: path, extension: string]: nothing -> list<string> {
    if not ($root_path | path exists) {
        fail $"Upstream submodule is missing at ($root_path); run `git submodule update --init --recursive`"
    }

    let root: string = $root_path | path expand | str replace --all (char --unicode 5c) /
    let pattern: string = $"($root)/**/*.($extension)"
    let files: list<path> = glob $pattern

    if ($files | is-empty) {
        fail $"Upstream submodule at ($root_path) contains no .($extension) fixtures"
    }

    $files
}

def luau-fixtures []: nothing -> list<string> {
    let root_path: path = "test/upstream/luau"
    let root: path = $root_path | path expand
    let ignored: list<string> = try {
        open --raw test/upstream-invalid.txt
        | lines
        | str trim
        | where (($it | is-not-empty) and not ($it | str starts-with "#"))
    } catch {|error| fail $"Failed to read the upstream exclusion list: ($error.msg)" }

    fixtures $root_path luau
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
}

def parse [scope: string, ...files: path]: nothing -> nothing {
    tree-sitter parse --config-path test/config.json --grammar-path . --scope $scope ...$files --quiet --stat
}

def main []: nothing -> nothing {
    $env.CC = "clang"

    print "LuauX upstream fixtures"
    parse source.luaux ...(fixtures test/upstream/luaux luaux)

    print "Luau compatibility through the LuauX parser"
    parse source.luaux ...(luau-fixtures)
}
