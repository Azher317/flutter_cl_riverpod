#!/usr/bin/env bash
# Start a new app from this structure. Run it from any folder:
#
#   ~/Developer/structores/flutter_cl_riverpod/bin/new_app.sh
#
# It asks a few questions, copies the structure into a NEW folder, removes
# what the app won't use, checks the result builds, and makes the first
# commit. The structure itself is never changed. It stops before creating
# anything if the target folder already exists.
set -euo pipefail

BASE="$(cd "$(dirname "$0")/.." && pwd)"

ask() { # ask <var> <question> [default]
  local __var=$1 __q=$2 __def=${3:-} __ans
  if [[ -n "$__def" ]]; then read -r -p "$__q [$__def]: " __ans || true; else read -r -p "$__q: " __ans || true; fi
  __ans="${__ans:-$__def}"
  printf -v "$__var" '%s' "$__ans"
}
choose() { # choose <var> <question> <option1> <option2>
  local __var=$1 __q=$2 __a=$3 __b=$4 __ans
  while true; do
    echo "$__q"; echo "  1) $__a"; echo "  2) $__b"
    read -r -p "> " __ans || true
    case "$__ans" in 1) printf -v "$__var" '%s' 1; return ;; 2) printf -v "$__var" '%s' 2; return ;; esac
    echo "Type 1 or 2."
  done
}
yesno() { # yesno <var> <question>
  local __var=$1 __q=$2 __ans
  while true; do
    read -r -p "$__q (y/n): " __ans || true
    case "$__ans" in [yY]*) printf -v "$__var" '%s' y; return ;; [nN]*) printf -v "$__var" '%s' n; return ;; esac
  done
}
die() { echo "Stopped: $*" >&2; exit 1; }

# --- Questions --------------------------------------------------------------

ask NAME "App name (lowercase, used for the folder, e.g. nayeb)"
[[ "$NAME" =~ ^[a-z][a-z0-9_]*$ ]] || die "the app name must be lowercase letters, digits or _ (got \"$NAME\")."

ask PARENT "Create it inside which folder?" "$HOME/Developer/digital-logic"
PARENT="${PARENT/#\~/$HOME}"
[[ -d "$PARENT" ]] || die "the folder $PARENT does not exist."
TARGET="$PARENT/$NAME"
echo "-> The app will be created at $TARGET"
[[ -e "$TARGET" ]] && die "$TARGET already exists. Nothing was created."

ask DISPLAY "Display name (shown under the icon)" "$NAME"
ask BUNDLE "Bundle id (e.g. iq.$NAME.app)"
[[ "$BUNDLE" =~ ^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$ ]] || die "\"$BUNDLE\" is not a valid bundle id."

ask LANGS "Languages (any of: ar, en, ku; comma separated)" "ar,en"
LANGS="$(echo "$LANGS" | tr -d ' ' | tr 'A-Z' 'a-z')"
IFS=',' read -r -a LANG_LIST <<<"$LANGS"
for l in "${LANG_LIST[@]}"; do
  [[ "$l" == ar || "$l" == en || "$l" == ku ]] || die "unknown language \"$l\" (use ar, en, ku)."
done
[[ ${#LANG_LIST[@]} -gt 0 ]] || die "pick at least one language."

yesno HAS_SIGN_IN "Does the app have sign-in?"
SIGN_IN=none
if [[ "$HAS_SIGN_IN" == y ]]; then
  choose s "Sign-in:" "Guest mode (browse first, sign in when needed)" "Sign-in required"
  [[ "$s" == 1 ]] && SIGN_IN=guest || SIGN_IN=required
fi

choose p "Phone number:" "Iraq only" "International"
[[ "$p" == 1 ]] && PHONE=iraqi || PHONE=international

yesno TABLETS "Tablets"
ask REMOTE "Git remote (Enter to skip)" ""

echo
echo "Creating $TARGET ..."

# --- Copy -------------------------------------------------------------------

# Committed files only: no build output, caches, or anyone's secrets.
mkdir -p "$TARGET"
git -C "$BASE" archive --format=tar HEAD | tar -x -C "$TARGET"
cd "$TARGET"
echo "✓ Copied the structure (committed files only)"

# Helpers that edit files in place (python3 ships with macOS).
drop_marked() { # drop_marked <marker> <files...>: delete lines tagged "// new_app:<marker>"
  local marker=$1; shift
  python3 - "$marker" "$@" <<'PY'
import sys, re
marker, files = sys.argv[1], sys.argv[2:]
for f in files:
    s = open(f).read()
    s = re.sub(r'[ \t]*// new_app:' + re.escape(marker) + r'-start\n.*?// new_app:' + re.escape(marker) + r'-end\n', '', s, flags=re.S)
    s = '\n'.join(l for l in s.split('\n') if not l.rstrip().endswith('// new_app:' + marker))
    open(f, 'w').write(s)
PY
}
unmark() { # remove all remaining "// new_app:..." markers, keeping the code
  python3 - "$@" <<'PY'
import sys, re
for f in sys.argv[1:]:
    s = open(f).read()
    s = re.sub(r'[ \t]*// new_app:[a-z-]+-(start|end)\n', '', s)
    s = re.sub(r' // new_app:[a-z-]+', '', s)
    open(f, 'w').write(s)
PY
}
set_const() { # set_const <file> <regex> <replacement>
  python3 - "$@" <<'PY'
import sys, re
f, pat, rep = sys.argv[1:4]
s = open(f).read()
s2, n = re.subn(pat, rep, s)
if n == 0: sys.exit(f"pattern not found in {f}: {pat}")
open(f, 'w').write(s2)
PY
}
MARKED=(lib/app.dart lib/core/l10n/l10n.dart lib/router/app_router.dart lib/router/redirect.dart)

# --- Name and ids -----------------------------------------------------------

set_const lib/main.dart "const String appName = '[^']*';" "const String appName = '$DISPLAY';"
# Android: namespace, application id, MainActivity's package and folder.
sed -i '' "s/com\.example\.app/$BUNDLE/g" android/app/build.gradle
KT_DIR="android/app/src/main/kotlin/$(echo "$BUNDLE" | tr '.' '/')"
mkdir -p "$KT_DIR"
sed "s/^package com\.example\.app/package $BUNDLE/" android/app/src/main/kotlin/com/example/app/MainActivity.kt >"$KT_DIR/MainActivity.kt"
[[ "$KT_DIR" == android/app/src/main/kotlin/com/example/app ]] || rm -rf android/app/src/main/kotlin/com/example
find android/app/src/main/kotlin -type d -empty -delete
set_const android/app/src/main/AndroidManifest.xml 'android:label="[^"]*"' "android:label=\"$DISPLAY\""
# iOS: bundle id and the names under the icon.
sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = com\.example\.app/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE/g" ios/Runner.xcodeproj/project.pbxproj
python3 - "$DISPLAY" ios/Runner/Info.plist <<'PY'
import sys, re
name, f = sys.argv[1:3]
s = open(f).read()
for key in ("CFBundleDisplayName", "CFBundleName"):
    s = re.sub(r"(<key>%s</key>\s*<string>)[^<]*(</string>)" % key, r"\g<1>%s\g<2>" % name.replace("\\", ""), s)
open(f, "w").write(s)
PY
echo "✓ Bundle id $BUNDLE, display name \"$DISPLAY\""

# --- Phone and sign-in ------------------------------------------------------

set_const lib/core/config/app_config.dart "phoneFormat = PhoneFormat\.[a-z]+;" "phoneFormat = PhoneFormat.$PHONE;"
set_const lib/core/config/app_config.dart "signIn = SignInMode\.[a-z]+;" "signIn = SignInMode.$SIGN_IN;"
[[ "$PHONE" == iraqi ]] && echo "✓ Phone: Iraq only" || echo "✓ Phone: international"

if [[ "$SIGN_IN" != guest ]]; then
  drop_marked guest "${MARKED[@]}"
  rm -f lib/core/session/sign_in_gate.dart lib/core/session/sign_in_gate.g.dart test/core/session/sign_in_gate_test.dart
fi
if [[ "$SIGN_IN" == none ]]; then
  drop_marked sign-in "${MARKED[@]}"
  rm -rf lib/features/auth
  rm -f lib/core/widgets/form_fields/otp_field.dart lib/core/widgets/form_fields/resend_countdown.dart \
        lib/core/widgets/form_fields/password_form_field.dart test/core/widgets/otp_field_test.dart
  echo "✓ No sign-in: sign-in screen, OTP and password fields removed"
elif [[ "$SIGN_IN" == guest ]]; then
  echo "✓ Sign-in: guest mode (ref.requireSignIn kept)"
else
  echo "✓ Sign-in: required"
fi

# --- Tablets ----------------------------------------------------------------

if [[ "$TABLETS" == n ]]; then
  rm -rf lib/core/layout test/core/layout
  rm -f lib/core/widgets/layout/content_box.dart lib/core/widgets/layout/two_pane.dart .claude/rules/tablets.md
  # iPhone only: on an iPad the app runs in iPhone size.
  sed -i '' 's/TARGETED_DEVICE_FAMILY = "1,2";/TARGETED_DEVICE_FAMILY = 1;/' ios/Runner.xcodeproj/project.pbxproj
  echo "✓ Phone only: tablet layer removed, iOS set to iPhone"
else
  echo "✓ Tablets: layer kept (.claude/rules/tablets.md applies)"
fi

# --- Languages --------------------------------------------------------------

has_lang() { [[ ",$LANGS," == *",$1,"* ]]; }
for l in ar en; do has_lang "$l" || rm -f "lib/l10n/arb/app_$l.arb"; done
TEMPLATE="app_${LANG_LIST[0]}.arb"
[[ "${LANG_LIST[0]}" == ku ]] && TEMPLATE="app_$( has_lang ar && echo ar || echo en ).arb"
if has_lang ku; then
  src="lib/l10n/arb/$TEMPLATE"; [[ -f "$src" ]] || src="$BASE/lib/l10n/arb/app_ar.arb"
  python3 - "$src" lib/l10n/arb/app_ku.arb <<'PY'
import json, sys, collections
d = json.load(open(sys.argv[1]), object_pairs_hook=collections.OrderedDict)
d["@@locale"] = "ku"
d = collections.OrderedDict((k, v) for k, v in d.items() if not k.startswith("@") or k == "@@locale")
json.dump(d, open(sys.argv[2], "w"), ensure_ascii=False, indent=2)
PY
  [[ -f "lib/l10n/arb/$TEMPLATE" ]] || cp "$BASE/lib/l10n/arb/$TEMPLATE" lib/l10n/arb/
else
  drop_marked kurdish "${MARKED[@]}"
  rm -rf lib/core/l10n/kurdish
fi
set_const l10n.yaml "template-arb-file: .*" "template-arb-file: $TEMPLATE"
echo "✓ Languages: $LANGS$(has_lang ku && echo ' (translate lib/l10n/arb/app_ku.arb)')"

unmark "${MARKED[@]}"

# --- Demo screen ------------------------------------------------------------

cat > lib/features/home/presentation/screens/home_screen.dart <<'DART'
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/widgets/debug/debug_logs_tile.dart';
import 'package:flutter/material.dart';

/// The app's first screen. Replace it with the real one.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appName)),
      body: ListView(
        // Move DebugLogsTile into the settings screen once there is one.
        children: const [DebugLogsTile()],
      ),
    );
  }
}
DART
python3 - "$DISPLAY" lib/l10n/arb/*.arb <<'PY'
import json, sys, collections
name, files = sys.argv[1], sys.argv[2:]
for f in files:
    d = json.load(open(f), object_pairs_hook=collections.OrderedDict)
    d = collections.OrderedDict((k, v) for k, v in d.items()
        if not (k.startswith("preview") or k.startswith("@preview")))
    d["appName"] = name
    json.dump(d, open(f, "w"), ensure_ascii=False, indent=2)
    open(f, "a").write("\n")
PY
rm -f assets/images/jpeg/monstera.jpeg
echo "✓ Demo screen replaced with a plain Home"

# --- Build check ------------------------------------------------------------

echo "  Checking the new app builds (pub get, codegen, analyze, tests) ..."
flutter pub get >/dev/null
dart run build_runner build --delete-conflicting-outputs >/dev/null 2>&1 || dart run build_runner build --delete-conflicting-outputs
dart run app:gen_assets >/dev/null 2>&1 || true
dart format lib test >/dev/null
if ! bin/check_arch.sh >/dev/null || ! flutter analyze >/dev/null || ! flutter test >/dev/null 2>&1; then
  echo "The new app has problems. Run bin/gates.sh inside it to see them."
  exit 1
fi
echo "✓ pub get, code generation, check_arch, analyze, tests: all passed"

# --- Git --------------------------------------------------------------------

git init -q
git config core.hooksPath .githooks
git add -A
git commit -q -m "Start $DISPLAY from flutter_cl_riverpod ($(git -C "$BASE" rev-parse --short HEAD))"
if [[ -n "$REMOTE" ]]; then
  git remote add origin "$REMOTE"
  echo "✓ First commit made, remote set to $REMOTE"
else
  echo "✓ First commit made (no remote)"
fi

cat <<EOF

Left for you:
  1. Create the release keystore and fill android/key.properties
     (android/key.properties.example shows how).
  2. Put the server addresses in env/dev.json, env/uat.json, env/prod.json.
  3. Open the app: cd $TARGET
EOF
