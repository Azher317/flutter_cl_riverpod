#!/usr/bin/env bash
# Every check CI runs, in the same order, showing only what failed.
#
#   bin/gates.sh          # skips when this exact commit already passed
#   bin/gates.sh --force  # run anyway
#
# A commit that passed is remembered in .dart_tool/gates_passed. The skip only
# applies to a clean working tree (no uncommitted changes), so it never hides
# a change that wasn't checked.
set -uo pipefail
cd "$(dirname "$0")/.."

stamp=.dart_tool/gates_passed
head="$(git rev-parse HEAD 2>/dev/null || echo none)"
clean=0
[[ -z "$(git status --porcelain 2>/dev/null)" ]] && clean=1

if [[ "${1:-}" != "--force" && $clean -eq 1 && -f "$stamp" && "$(cat "$stamp")" == "$head" ]]; then
  echo "Skipped: commit ${head:0:7} already passed every check (--force to rerun)."
  exit 0
fi

log="$(mktemp -t gates)"
trap 'rm -f "$log"' EXIT
failed=0

# Runs "$@" with a time limit, keeping its output in $log.
run_limited() {
  local limit=$1; shift
  "$@" >"$log" 2>&1 &
  local pid=$! waited=0
  while kill -0 "$pid" 2>/dev/null; do
    if (( waited >= limit )); then
      kill "$pid" 2>/dev/null; wait "$pid" 2>/dev/null
      echo "timed out after ${limit}s" >>"$log"
      return 124
    fi
    sleep 1; waited=$((waited + 1))
  done
  wait "$pid"
}

step() {
  local name=$1 limit=$2; shift 2
  printf '%-16s' "$name"
  if run_limited "$limit" "$@"; then
    echo "ok"
  else
    echo "FAILED"
    grep -vE '^\s*$' "$log" | tail -40 | sed 's/^/    /'
    failed=1
  fi
}

codegen() {
  if run_limited 300 dart run build_runner build --delete-conflicting-outputs; then
    return 0
  fi
  # A stuck or corrupt build cache is the usual cause: clear it once, retry.
  rm -rf .dart_tool/build
  run_limited 300 dart run build_runner build --delete-conflicting-outputs
}

step "pub get"      300 flutter pub get
step "check_arch"    60 bin/check_arch.sh
printf '%-16s' "codegen"
if codegen; then echo "ok"; else echo "FAILED"; tail -40 "$log" | sed 's/^/    /'; failed=1; fi
step "analyze"      300 flutter analyze
step "custom_lint"  300 dart run custom_lint

printf '%-16s' "tests"
if run_limited 900 flutter test --reporter=expanded; then
  echo "ok ($(grep -oE '\+[0-9]+' "$log" | tail -1 | tr -d '+') passed)"
else
  echo "FAILED"
  grep -vE '^\s*$' "$log" | tail -60 | sed 's/^/    /'
  failed=1
fi

if [[ $failed -eq 0 ]]; then
  [[ $clean -eq 1 ]] && echo "$head" >"$stamp"
  echo "All checks passed."
else
  echo "Some checks failed."
fi
exit $failed
