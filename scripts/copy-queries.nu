const ROOT: string = path self | path dirname | path dirname

def fail [message: string]: nothing -> error {
    error make {
        msg: $message
        label: {
            text: $message
            span: (metadata $message).span
        }
    }
}

def main [
    editor: string # Editor query subset under queries/.
    target: path # Query directory to receive the subset.
]: nothing -> nothing {
    let source: path = $ROOT | path join queries $editor
    let target: path = $target | path expand

    if not ($source | path exists) {
        fail $"Editor query subset does not exist: ($source)"
    }

    if not ($target | path exists) {
        mkdir $target
    }

    let source_glob: string = (
        $source
        | path join "*.scm"
        | str replace --all (char --unicode 5c) "/"
    )
    let queries: list<string> = (
        glob $source_glob
        | each {|path| $path | path basename }
        | sort
    )

    if ($queries | is-empty) {
        fail $"Editor query subset is empty: ($source)"
    }

    for query: string in $queries {
        try {
            cp ($source | path join $query) ($target | path join $query)
        } catch {|error| fail $"Failed to copy ($query): ($error.msg)" }
    }

    print $"Copied ($queries | length) ($editor) Luau queries to ($target)"
}
