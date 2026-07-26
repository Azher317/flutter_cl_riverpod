#!/bin/sh
# Activate the repo's tracked git hooks. Run once after cloning.
#
#   bin/setup-hooks.sh
#
# Git hooks live in .git/hooks/, which is NOT tracked and does NOT come with a
# clone. This points git at the tracked .githooks/ directory instead, so every
# clone gets the same hooks after running this one command.
set -e

# Resolve repo root so this works from anywhere.
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

git config core.hooksPath .githooks
chmod +x .githooks/* 2>/dev/null || true

echo "Hooks activated: core.hooksPath -> .githooks"
echo "Active hooks:"
ls -1 .githooks | sed 's/^/  - /'
