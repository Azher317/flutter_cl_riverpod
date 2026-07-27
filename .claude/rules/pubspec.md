---
paths:
  - "pubspec.yaml"
  - "pubspec.lock"
---

# Dependency gotcha: Talker fork

[pubspec.yaml](../../pubspec.yaml) pins `talker`, `talker_flutter`, and `talker_dio_logger`
to a patched fork via `dependency_overrides` (git ref `v1.2-patched`). **All three
overrides are required** — the flutter/dio packages depend on `talker: ^5.1.17` from
pub.dev, not on their sibling in the fork, so without the `talker` override the
unpatched core is pulled in silently. The fork keeps version `5.1.17`, so `pub get`
output looks identical either way. Verify:

```bash
grep -A4 '^  talker:' pubspec.lock    # must show url: https://github.com/Azher317/talker.git
```

(`flutter pub deps -s list` prints versions only — it can **not** distinguish the fork
from pub.dev. `dart pub deps --json` works too: each of `talker`, `talker_flutter`,
`talker_dio_logger` must report `"source": "git"`.)

Font `family:` keys in `pubspec.yaml` must match the names in
[app_fonts.dart](../../lib/core/theme/app_fonts.dart) exactly.
