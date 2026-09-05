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

def helix-runtime []: nothing -> string {
    let config_runtime: path = if ($env.APPDATA? | is-not-empty) {
        $env.APPDATA | path join helix runtime
    } else if ($env.XDG_CONFIG_HOME? | is-not-empty) {
        $env.XDG_CONFIG_HOME | path join helix runtime
    } else {
        "~/.config/helix/runtime" | path expand
    }
    let candidates: list<path> = [
        $config_runtime
        ...(if ($env.CARGO_MANIFEST_DIR? | is-not-empty) {
            [$env.CARGO_MANIFEST_DIR | path dirname | path join runtime]
        } else {
            []
        })
        ...(if ($env.HELIX_RUNTIME? | is-not-empty) {
            [$env.HELIX_RUNTIME]
        } else {
            []
        })
        ...(if ($env.HELIX_DEFAULT_RUNTIME? | is-not-empty) {
            [$env.HELIX_DEFAULT_RUNTIME]
        } else {
            []
        })
        ...(
            which hx
            | get --optional path.0
            | if $in == null { [] } else { [$in | path dirname | path join runtime] }
        )
    ]
    let existing: list<path> = (
        $candidates
        | each {|runtime| $runtime | path expand }
        | uniq
        | where ($it | path exists)
    )

    if ($existing | is-empty) {
        fail "Could not find a Helix runtime. Run `hx --health` to inspect it."
    }

    $existing | first
}

def main [
    helix?: path # Helix checkout containing runtime/.
]: nothing -> nothing {
    let runtime: path = if $helix != null {
        $helix | path expand | path join runtime
    } else {
        helix-runtime
    }
    let query_root: path = $runtime | path join queries
    let languages: list<record<name: string, source: path>> = [
        {
            name: luau
            source: ($ROOT | path join queries helix)
        }
        {
            name: luaux
            source: ($ROOT | path join luaux queries)
        }
    ]
    let queries: list<string> = [
        highlights.scm
        indents.scm
        injections.scm
        locals.scm
        rainbows.scm
        tags.scm
        textobjects.scm
    ]

    for language in $languages {
        if not ($language.source | path exists) {
            fail $"Editor query subset does not exist: ($language.source)"
        }

        let target: path = $query_root | path join $language.name
        if not ($target | path exists) {
            try {
                mkdir $target
            } catch {|error| fail $"Failed to create ($target): ($error.msg)" }
        }

        for query: string in $queries {
            try {
                cp ($language.source | path join $query) ($target | path join $query)
            } catch {|error| fail $"Failed to copy ($query): ($error.msg)" }
        }
    }

    print $"Copied Helix queries for ($languages | get name | str join ', ') to ($query_root)"
}
