#!/bin/sh
# Ensure a graphify file-watcher is running for THIS repo, then return immediately.
# Idempotent: starts one only if none is already watching this repo's root, so it's
# safe to run on every session start. Invoked by the SessionStart hook in
# .claude/settings.json; also safe to run by hand.
#
#   bin/graphify-watch-ensure.sh
#
# The watcher rebuilds graphify-out/ on any code change (AST-only, no API cost).

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Is a graphify watcher already watching THIS repo? (a watcher for a *different*
# cloned app must not suppress starting one here, so we match on the process cwd,
# not just the command line — the command is only "graphify watch .")
for pid in $(pgrep -f "graphify watch" 2>/dev/null); do
  if [ -r "/proc/$pid/cwd" ]; then
    cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null)          # Linux
  else
    cwd=$(lsof -a -d cwd -p "$pid" -Fn 2>/dev/null | sed -n 's/^n//p' | head -1)  # macOS
  fi
  [ "$cwd" = "$ROOT" ] && exit 0    # already watching here — nothing to do
done

GBIN=$(command -v graphify 2>/dev/null || echo "$HOME/.local/bin/graphify")
[ -x "$GBIN" ] || { echo "[graphify] not installed; watcher not started" >&2; exit 0; }

cd "$ROOT" || exit 0
PYTHONHASHSEED=0 nohup "$GBIN" watch . >/tmp/graphify-watch.log 2>&1 &
echo "[graphify] watcher started (pid $!) for $ROOT"
