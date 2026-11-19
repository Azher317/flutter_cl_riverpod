#!/usr/bin/env bash
# Release build that always names its server.
#   bin/build_release.sh <dev|uat|prod> <appbundle|apk|ipa> [extra flutter args]
# Stops if the env file is missing or its API_HOST is still a placeholder,
# and prints the server before building.
set -euo pipefail
cd "$(dirname "$0")/.."

env_name="${1:-}"; target="${2:-}"
if [[ -z "$env_name" || -z "$target" ]]; then
  echo "Usage: bin/build_release.sh <dev|uat|prod> <appbundle|apk|ipa> [flutter args]"
  exit 1
fi
shift 2

file="env/$env_name.json"
[[ -f "$file" ]] || { echo "Stopped: $file does not exist."; exit 1; }

host="$(sed -n 's/.*"API_HOST"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$file")"
if [[ -z "$host" || "$host" == *.invalid ]]; then
  echo "Stopped: API_HOST in $file is not set (\"$host\")."
  exit 1
fi

echo "Building $target for $env_name: $host"
flutter build "$target" --release --dart-define-from-file="$file" "$@"
