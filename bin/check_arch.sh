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

report "cross-feature import outside router/" \
  "$(grep -rn 'package:app/features' lib --include='*.dart' \
      | grep -v '^lib/router/' | grep -v '^lib/features/' || true)"

report "dio used outside core/network/" \
  "$(grep -rln 'package:dio/dio.dart' lib --include='*.dart' \
      | grep -vE 'core/network/|network_error_mapper' || true)"

if [[ "$fail" -eq 0 ]]; then
  echo "✅ all import boundaries hold"
fi
exit "$fail"
