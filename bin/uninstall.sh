#!/bin/bash
# Remove the app from the booted iOS simulator and any connected Android device.
# Usage: bin/uninstall.sh <application-id>
set -uo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <application-id>" >&2
    echo "Example: $0 com.company.myapp" >&2
    exit 1
fi

APP_ID="$1"

xcrun simctl uninstall booted "$APP_ID" || echo "simulator: nothing to uninstall"
adb uninstall "$APP_ID" || echo "android: nothing to uninstall"
