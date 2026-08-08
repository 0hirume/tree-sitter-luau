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

def helix-runtime-target []: nothing -> string {
    let config_runtime: path = if ($env.APPDATA? | is-not-empty) {
        $env.APPDATA | path join helix runtime
    } else if ($env.XDG_CONFIG_HOME? | is-not-empty) {
        $env.XDG_CONFIG_HOME | path join helix runtime
    } else {
        "~/.config/helix/runtime" | path expand
    }
    let source_runtime: path = if ($env.CARGO_MANIFEST_DIR? | is-not-empty) {
        $env.CARGO_MANIFEST_DIR | path dirname | path join runtime
    } else {
        null
    }
    let executable_runtime: path = (
        which hx
        | get --optional path.0
        | if $in == null { null } else { $in | path dirname | path join runtime }
    )
    let candidates: list<path> = [
        $source_runtime
        $config_runtime
        ($env.HELIX_RUNTIME? | default null)
        ($env.HELIX_DEFAULT_RUNTIME? | default null)
        $executable_runtime
    ]
    let existing: list<path> = (
        $candidates
        | compact
        | each {|runtime| $runtime | path expand }
        | uniq
        | where ($it | path exists)
    )

    if ($existing | is-empty) {
        fail "Could not find a Helix runtime. Run `hx --health` to inspect it."
    }

    $existing | first | path join queries luau
}

def main [
    helix?: path # Helix checkout containing runtime/.
]: nothing -> nothing {
    let source: path = $ROOT | path join queries helix
    let target: path = if $helix != null {
        $helix | path expand | path join runtime queries luau
    } else {
        helix-runtime-target
    }
    let queries: list<string> = [
        highlights.scm
        indents.scm
        injections.scm
        locals.scm
        rainbows.scm
        tags.scm
        textobjects.scm
    ]

    if not ($source | path exists) {
        fail $"Editor query subset does not exist: ($source)"
    }

    if not ($target | path exists) {
        try {
            mkdir $target
        } catch {|error| fail $"Failed to create ($target): ($error.msg)" }
    }

    for query: string in $queries {
        try {
            cp ($source | path join $query) ($target | path join $query)
        } catch {|error| fail $"Failed to copy ($query): ($error.msg)" }
    }

    print $"Copied ($queries | length) Helix Luau queries to ($target)"
}
