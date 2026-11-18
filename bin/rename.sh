#!/bin/bash
# Start a new app from the structure: bundle id, display name, and the
# per-app choices in lib/core/config/app_config.dart.
# Usage: bin/rename.sh <bundle-id> "<App Name>" [iraqi|international]
#   The phone format is asked for when it isn't passed.
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <bundle-id> \"<App Name>\" [iraqi|international]" >&2
    echo "Example: $0 com.company.myapp \"My App\"" >&2
    exit 1
fi

BUNDLE_ID="$1"
APP_NAME="$2"
PHONE_FORMAT="${3:-}"

if [ -z "$PHONE_FORMAT" ]; then
    read -r -p "Iraqi phone numbers only (07XX XXX XXXX)? [Y/n] " answer
    case "${answer:-y}" in
        [nN]*) PHONE_FORMAT=international ;;
        *) PHONE_FORMAT=iraqi ;;
    esac
fi
case "$PHONE_FORMAT" in
    iraqi|international) ;;
    *) echo "Phone format must be 'iraqi' or 'international'" >&2; exit 1 ;;
esac
CONFIG=lib/core/config/app_config.dart
sed -i.bak -E "s/(phoneFormat = PhoneFormat\.)[a-z]+;/\1${PHONE_FORMAT};/" "$CONFIG"
rm -f "$CONFIG.bak"
echo "Phone format: $PHONE_FORMAT ($CONFIG)"
if [ "$PHONE_FORMAT" = iraqi ]; then
    echo "  country_code_picker is unused now; remove it from pubspec.yaml if you like."
fi

dart run rename setBundleId --value "$BUNDLE_ID" --targets ios,android
dart run rename setAppName --value "$APP_NAME" --targets ios,android

# Single platform:
#   dart run rename setAppName --value "$APP_NAME" --targets ios
#   dart run rename setAppName --value "$APP_NAME" --targets android
