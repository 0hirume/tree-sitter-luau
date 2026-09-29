use std/assert

const CHECKOUT = ".upstream/creator-docs"
const BRANCH = "automation/update-types"
const TITLE = "chore: update Roblox types"
const FILES = [spec/roblox-types.json spec/LICENSE queries/highlights.scm queries/neovim/highlights.scm]

def main []: nothing -> nothing {
    git clone --filter=blob:none --single-branch --sparse https://github.com/Roblox/creator-docs.git $CHECKOUT
    git -C $CHECKOUT sparse-checkout set --no-cone /content/en-us/reference/engine/classes /content/en-us/reference/engine/datatypes /LICENSE
    nu scripts/queries.nu update $CHECKOUT
    nu scripts/queries.nu check

    git add ...$FILES
    let changes: record = git diff --cached --quiet | complete
    assert ($changes.exit_code in [0 1]) ($changes.stderr | str trim)

    if $changes.exit_code == 0 {
        print "Roblox types are already current"

        return
    }

    gh auth setup-git
    git config user.name "github-actions[bot]"
    git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
    git switch --force-create $BRANCH
    git commit --message $TITLE

    let reference: string = $"refs/heads/($BRANCH)"
    let remote: string = git ls-remote --heads origin $reference | str trim
    let revision: string = $remote | split row (char tab) | first
    git push $"--force-with-lease=($reference):($revision)" origin $"HEAD:($reference)"

    let count: int = gh pr list --base $env.BASE_BRANCH --head $BRANCH --state open --json number --jq length | str trim | into int

    if $count == 0 {
        gh pr create --base $env.BASE_BRANCH --head $BRANCH --title $TITLE --body "Updates Roblox type metadata, licensing, and generated highlights. Requires review."
    }
}
