#!/bin/bash
# Fire a test deep link at the connected Android device.
# Usage: bin/deep_link.sh <host> <application-id> [path]
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <host> <application-id> [path]" >&2
    echo "Example: $0 myshop.com com.company.myapp /order/12" >&2
    exit 1
fi

HOST="$1"
APP_ID="$2"
PATH_PART="${3:-/}"

adb shell am start -W \
    -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "https://${HOST}${PATH_PART}" \
    "$APP_ID"
