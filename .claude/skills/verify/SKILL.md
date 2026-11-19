---
name: verify
description: Run every check CI runs (architecture, codegen, analyze, custom_lint, tests) and report only failures. Use before a commit or PR, at the end of any feature or fix, or when the user says "check it", "run the checks" or "before I push".
---

# Verify

Run:

```bash
bin/gates.sh
```

It runs, in CI's order: `pub get`, `bin/check_arch.sh`, codegen (with a time
limit; a stuck build cache is cleared and retried once), `flutter analyze`,
`dart run custom_lint`, `flutter test`. It prints one line per step and the
output of failed steps only. On a clean tree whose commit already passed it
skips; pass `--force` to run anyway.

- **All passed:** say so in one line with the test count.
- **A step failed:** fix the cause, then run it again. Never edit a generated
  file to make a check pass, and never weaken a check in `bin/check_arch.sh`.
  A `check_arch` failure names the shared widget or layer to use instead.
- Report only what failed and what you changed, not the full output.
