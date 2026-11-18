# Commands cheatsheet

The easy-to-forget commands for this project, in one place. Fuller context lives in
[README.md](README.md) and [.claude/CLAUDE.md](.claude/CLAUDE.md).

## Git hooks

```bash
bin/setup-hooks.sh                 # activate tracked hooks (core.hooksPath -> .githooks); run once after clone
git config --get core.hooksPath    # verify hooks are active (should print: .githooks)
```

The `pre-commit` hook runs `bin/check_arch.sh` (import-boundary guard).

## Codegen / build

```bash
dart run build_runner build --delete-conflicting-outputs   # or: bin/run.sh
dart run build_runner watch  --delete-conflicting-outputs   # rebuild on save
dart run app:gen_assets                                     # regenerate asset constants
```




