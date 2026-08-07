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
    helix: path # Helix checkout to receive the queries.
]: nothing -> nothing {
    let target: path = $helix | path expand | path join runtime queries luau
    let queries: list<string> = [
        highlights.scm
        indents.scm
        injections.scm
        locals.scm
        textobjects.scm
        rainbows.scm
        tags.scm
    ]

    if not ($target | path exists) {
        fail $"Helix Luau query directory does not exist: ($target)"
    }

    for query: string in $queries {
        try {
            cp ($ROOT | path join queries $query) ($target | path join $query)
        } catch {|error| fail $"Failed to copy ($query): ($error.msg)" }
    }

    print $"Copied ($queries | length) Luau queries to ($target)"
}
