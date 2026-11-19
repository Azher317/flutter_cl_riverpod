#!/usr/bin/env bash
# Enforces CLAUDE.md layer rules 1, 2, 3, 5, 16, the Insets tokens, the haptics and sheet
# rules (.claude/rules/motion-feedback.md), shared widgets over hand-built ones
# (.claude/rules/presentation.md) and logging through AppLogger
# (.claude/rules/observability.md). Runs on every commit (pre-commit hook) and in CI.
set -uo pipefail

fail=0

report() {
  if [[ -n "$2" ]]; then
    echo "FAIL: $1"
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

report "core/ imports shared/ (CLAUDE.md rule 16)" \
  "$(grep -rn 'package:app/shared' lib/core --include='*.dart' || true)"

report "shared/ imports a feature or router/ (CLAUDE.md rule 16)" \
  "$( [ -d lib/shared ] && grep -rnE 'package:app/(features|router)' lib/shared --include='*.dart' || true)"

report "raw numbers in EdgeInsets (use Insets tokens)" \
  "$(grep -rnE 'EdgeInsets[A-Za-z.]*\(([^)]*[^A-Za-z0-9_.])?[0-9]' lib/features $( [ -d lib/shared ] && echo lib/shared ) --include='*.dart' \
      | grep -vE '\.(g|freezed)\.dart:' || true)"

report "dio used outside core/network/" \
  "$(grep -rln 'package:dio/dio.dart' lib --include='*.dart' \
      | grep -vE 'core/network/|network_error_mapper' || true)"

report "HapticFeedback used outside AppHaptics (see docs/guides/haptics.md)" \
  "$(grep -rn 'HapticFeedback\.' lib --include='*.dart' \
      | grep -v 'lib/core/feedback/app_haptics.dart' || true)"

report "showModalBottomSheet used directly (use customModalBottomSheet)" \
  "$(grep -rn 'showModalBottomSheet' lib --include='*.dart' \
      | grep -vE '^[^:]+:[0-9]+:\s*///?' || true)"

# Screens and shared business code use the shared widgets instead of building
# their own. Each message names the widget to use.
feature_dirs="lib/features $( [ -d lib/shared ] && echo lib/shared )"
no_comments() { grep -vE '^[^:]+:[0-9]+:\s*///?' || true; }

report "raw TextFormField/TextField in a feature (use CustomTextFormField or PhoneFormField, lib/core/widgets/form_fields)" \
  "$(grep -rnE '\b(TextFormField|TextField)\(' $feature_dirs --include='*.dart' | no_comments)"

report "showDatePicker in a feature (use CustomDatePickerFormField, lib/core/widgets/form_fields)" \
  "$(grep -rn 'showDatePicker(' $feature_dirs --include='*.dart' | no_comments)"

report "showTimePicker in a feature (use CustomTimePickerFormField, lib/core/widgets/form_fields)" \
  "$(grep -rn 'showTimePicker(' $feature_dirs --include='*.dart' | no_comments)"

report "showDialog in a feature (use showAppDialog or showConfirmDialog, lib/core/widgets/overlay/app_dialog.dart)" \
  "$(grep -rnE '(^|[^_A-Za-z0-9])showDialog\b' $feature_dirs --include='*.dart' | no_comments)"

# A reusable (public) widget kind defined inside a feature is hidden from the
# next feature. It lives in lib/core/widgets (no business words) or
# lib/shared. Private `_Something` pieces of one screen are fine.
report "Field/Button/Dialog/Sheet/Card widget defined in a feature (move it to lib/core/widgets or lib/shared, or improve the existing one)" \
  "$(grep -rnE '^(abstract |final |base |sealed )?class [A-Z][A-Za-z0-9_]*(Field|Button|Dialog|Sheet|Card)\b' lib/features --include='*.dart' \
      | grep -vE '\.(g|freezed)\.dart:' || true)"

# Logging goes through AppLogger; only the logging wiring touches talker.
report "talker used directly (use AppLogger, lib/core/observability/app_logger.dart)" \
  "$(grep -rnE '\b(talker|routeTalker)\.' lib --include='*.dart' \
      | grep -vE '^lib/core/observability/app_logger\.dart:|^lib/core/network/dio_module\.dart:|^lib/router/' \
      | no_comments)"

if [[ "$fail" -eq 0 ]]; then
  echo "OK: all architecture checks hold"
fi
exit "$fail"
