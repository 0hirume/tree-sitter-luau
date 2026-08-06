use std/assert

const CHECKOUT = ".upstream/creator-docs"
const BRANCH = "automation/update-types"
const TITLE = "chore: update Roblox types"
const BODY = "Updates the vendored Roblox Creator Docs type metadata and regenerates type highlights.\n\nThis pull request is generated automatically and requires review."
const EMAIL = "41898282+github-actions[bot]@users.noreply.github.com"
const FILES = [spec/roblox-types.json spec/LICENSE queries/highlights.scm]

def checked [program: string, ...arguments: string]: nothing -> nothing {
    run-external $program ...$arguments
    assert ($env.LAST_EXIT_CODE == 0) $"($program) failed"
}

def capture [program: string, ...arguments: string]: nothing -> string {
    let result = run-external $program ...$arguments | complete

    assert ($result.exit_code == 0) $"($program) failed: ($result.stderr | str trim)"
    $result.stdout | str trim
}

def clone-docs []: nothing -> nothing {
    (checked
        gh
        repo
        clone
        $env.DOCS_REPOSITORY
        $CHECKOUT
        "--"
        "--filter=blob:none"
        "--single-branch"
        "--sparse"
    )
    (checked
        git
        "-C"
        $CHECKOUT
        sparse-checkout
        set
        "--no-cone"
        content/en-us/reference/engine/classes
        content/en-us/reference/engine/datatypes
        LICENSE
    )
}

def update []: nothing -> bool {
    checked nu scripts/queries.nu update $CHECKOUT
    checked nu scripts/queries.nu check

    capture git status "--short" "--" ...$FILES | is-not-empty
}

def publish []: nothing -> nothing {
    checked gh auth setup-git
    checked git config user.name "github-actions[bot]"
    checked git config user.email $EMAIL
    checked git switch "--force-create" $BRANCH
    checked git add ...$FILES
    checked git commit "--message" $TITLE

    let reference = $"refs/heads/($BRANCH)"
    let remote = capture git ls-remote "--heads" origin $reference

    if ($remote | is-empty) {
        checked git push origin $"HEAD:($reference)"
    } else {
        let commit = $remote | split row (char tab) | first
        (checked
            git
            push
            $"--force-with-lease=($reference):($commit)"
            origin
            $"HEAD:($reference)"
        )
    }

    let query = [
        "--base" $env.BASE_BRANCH
        "--head" $BRANCH
        "--state" open
        "--json" number
        "--jq" ".[0].number"
    ]
    let number = capture gh pr list ...$query

    if ($number | is-empty) {
        let details = [
            "--base" $env.BASE_BRANCH
            "--head" $BRANCH
            "--title" $TITLE
            "--body" $BODY
        ]
        checked gh pr create ...$details
    }
}

def main []: nothing -> nothing {
    clone-docs

    if (update) {
        publish
    } else {
        print "Roblox types are already current"
    }
}
