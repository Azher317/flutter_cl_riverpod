#!/bin/bash
# Rename the app's bundle id and display name on both platforms.
# Usage: bin/rename.sh <bundle-id> "<App Name>"
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <bundle-id> \"<App Name>\"" >&2
    echo "Example: $0 com.company.myapp \"My App\"" >&2
    exit 1
fi

BUNDLE_ID="$1"
APP_NAME="$2"

dart run rename setBundleId --value "$BUNDLE_ID" --targets ios,android
dart run rename setAppName --value "$APP_NAME" --targets ios,android

# Single platform:
#   dart run rename setAppName --value "$APP_NAME" --targets ios
#   dart run rename setAppName --value "$APP_NAME" --targets android
