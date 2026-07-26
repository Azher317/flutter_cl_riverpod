# Commands cheatsheet

The easy-to-forget commands for this project, in one place. Fuller context lives in
[README.md](README.md) and [.claude/CLAUDE.md](.claude/CLAUDE.md).

## graphify (knowledge graph)

```bash
pgrep -fl "graphify watch"     # is the file-watcher running? (prints PID line if yes)
bin/graphify-watch-ensure.sh   # start the watcher for this repo if not already running
graphify watch .               # watch this folder, rebuild graphify-out/ on any code change
pkill -f "graphify watch"      # stop the watcher
graphify update .              # one-off rebuild of the graph (AST-only, no API cost)
graphify query "<question>"    # ask the graph a codebase question (scoped subgraph)
graphify path "<A>" "<B>"      # relationship between two symbols/files
graphify explain "<concept>"   # focused deep-dive on one concept
```

The watcher also auto-starts at the beginning of each Claude Code session
(SessionStart hook in [.claude/settings.json](.claude/settings.json)).

## Git hooks

```bash
bin/setup-hooks.sh                 # activate tracked hooks (core.hooksPath -> .githooks); run once after clone
git config --get core.hooksPath    # verify hooks are active (should print: .githooks)
GRAPHIFY_SKIP_HOOK=1 git commit ...  # commit without the pre-commit graph rebuild
```

The `pre-commit` hook runs `bin/check_arch.sh` (import-boundary guard) then rebuilds and
stages `graphify-out/` so the graph ships inside the commit.

## Codegen / build

```bash
dart run build_runner build --delete-conflicting-outputs   # or: bin/run.sh
dart run build_runner watch  --delete-conflicting-outputs   # rebuild on save
dart run app:gen_assets                                     # regenerate asset constants
```




