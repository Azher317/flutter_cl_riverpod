#!/usr/bin/env bash
# Enforces CLAUDE.md layer rules 1, 2, 3, 5. Run in CI and locally.
set -uo pipefail

fail=0

report() {
  if [[ -n "$2" ]]; then
    echo "❌ $1"
    echo "$2" | sed 's/^/    /'
    fail=1
  fi
}

report "core/ imports a feature" \
  "$(grep -rn 'package:app/features' lib/core --include='*.dart' || true)"

report "core/ imports router/" \
  "$(grep -rn 'package:app/router' lib/core --include='*.dart' || true)"

# A feature file may import its OWN feature; only A→B (A!=B) is a violation.
# router/ is the sole non-feature importer allowed; core/ has its own check above.
report "cross-feature import (or non-router importer of a feature)" \
  "$(grep -rn 'package:app/features/' lib --include='*.dart' | awk -F: '
      { path=$1
        if (path ~ /^lib\/router\//) next
        if (path ~ /^lib\/core\//)   next
        if (path ~ /^lib\/features\//) {
          split(path, p, "/"); imp=p[3]
          match($0, /package:app\/features\/[A-Za-z0-9_]+/)
          split(substr($0, RSTART, RLENGTH), q, "/"); tgt=q[3]
          if (imp != tgt) print
          next
        }
        print
      }' || true)"

report "dio used outside core/network/" \
  "$(grep -rln 'package:dio/dio.dart' lib --include='*.dart' \
      | grep -vE 'core/network/|network_error_mapper' || true)"

if [[ "$fail" -eq 0 ]]; then
  echo "✅ all import boundaries hold"
fi
exit "$fail"
