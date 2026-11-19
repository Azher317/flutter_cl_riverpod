# Commands cheatsheet

The easy-to-forget commands for this project, in one place. Fuller context lives in
[README.md](README.md) and [.claude/CLAUDE.md](.claude/CLAUDE.md).

## New app

```bash
bin/new_app.sh                     # asks name, folder, ids, languages, sign-in, phone, tablets
```

## Git hooks

```bash
bin/setup-hooks.sh                 # activate tracked hooks (core.hooksPath -> .githooks); run once after clone
git config --get core.hooksPath    # verify hooks are active (should print: .githooks)
```

The `pre-commit` hook runs `bin/check_arch.sh` (architecture checks). `post-checkout`
and `post-merge` rebuild the translation code when the ARBs changed.

## Run and release

```bash
flutter run --dart-define-from-file=env/uat.json   # every run names its server (VS Code launch configs do this)
bin/build_release.sh prod appbundle                # release: prints the server, refuses placeholders and fake data
bin/build_release.sh prod ipa
```

## Checks

```bash
bin/gates.sh                       # everything CI runs, failures only; skips a commit that already passed
bin/check_arch.sh                  # architecture checks (also on every commit and in CI)
flutter analyze
dart run custom_lint               # Riverpod lint rules (not part of flutter analyze)
flutter test
```

## Codegen / build

```bash
dart run build_runner build --delete-conflicting-outputs   # or: bin/run.sh
dart run build_runner watch  --delete-conflicting-outputs   # rebuild on save
dart run app:gen_assets                                     # regenerate asset constants
```




