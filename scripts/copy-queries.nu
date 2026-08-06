const ROOT = path self | path dirname | path dirname

def main [helix] {
  let target = $helix | path expand | path join "runtime" "queries" "luau"
  let queries = ["highlights.scm" "indents.scm" "injections.scm" "locals.scm" "textobjects.scm"]

  if not ($target | path exists) {
    error make { msg: $"Helix Luau query directory does not exist: ($target)" }
  }

  for query in $queries {
    cp ($ROOT | path join "queries" $query) ($target | path join $query)
  }

  print $"Copied ($queries | length) Luau queries to ($target)"
}
