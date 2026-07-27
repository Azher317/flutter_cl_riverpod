---
name: flutter-setup-localization
description: Add or edit a user-visible string in THIS project's localization (context.l10n.*), keeping app_en.arb and app_ar.arb in sync. Localization is already configured — use this for adding/editing strings, not for first-time setup.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Tue, 21 Apr 2026 21:27:35 GMT
---
# Localization (this project)

> This project **already has** `flutter_localizations` + `intl` wired up. Do **not**
> re-run setup, do **not** add `synthetic-package`, and do **not** switch the access
> pattern. This skill is for **adding or editing localized strings** the project way.

## Ground truth (verify before editing)

- **Config:** [l10n.yaml](../../../l10n.yaml) — `arb-dir: lib/core/l10n/generated`,
  `output-dir: lib/core/l10n/generated`, `template-arb-file: app_en.arb`,
  `output-localization-file: app_localizations.dart`, `untranslated-messages-file`.
  It is **non-synthetic** (an `output-dir` is set), so the generated class is imported
  from `lib/core/l10n/generated/`, **not** `package:flutter_gen/gen_l10n/...`.
- **ARB files:** [lib/core/l10n/generated/app_en.arb](../../../lib/core/l10n/generated/app_en.arb)
  and [app_ar.arb](../../../lib/core/l10n/generated/app_ar.arb). There is also a
  `lib/core/l10n/kurdish/` area — check whether a locale you touch lives there too.
- **Access:** widgets read strings through the project extension
  [lib/core/l10n/l10n.dart](../../../lib/core/l10n/l10n.dart) as **`context.l10n.<key>`**.
  Do **not** call `AppLocalizations.of(context)!` in widgets.

## Hard rule (CLAUDE.md rule 11)

**No user-visible string literal in a widget.** Every user-facing string is
`context.l10n.<key>`, and the key **must be added to both `app_en.arb` and `app_ar.arb`**
(and any other active locale). Proper nouns are the only exception, and deserve a comment.

## Workflow: add or edit a string

- [ ] 1. Add the key + a `@key` description to `app_en.arb` (the template).
- [ ] 2. Add the **same key** with the translated value to `app_ar.arb` (and other locales).
       A key present in `app_en.arb` but missing elsewhere lands in
       `untranslated_messages.txt` — treat that as a failing check, not a warning.
- [ ] 3. Regenerate: `flutter pub get` (or the project's build_runner flow —
       see [.claude/CLAUDE.md](../../CLAUDE.md) "Commands"). Codegen writes to
       `lib/core/l10n/generated/` — those files are machine-owned; never hand-edit them.
- [ ] 4. Use it in the widget as `context.l10n.<key>`.
- [ ] 5. Verify: `flutter analyze` clean, and `untranslated_messages.txt` has no new entries.

### ARB entry shape

```json
{
  "helloUser": "Hello {name}",
  "@helloUser": {
    "description": "Greeting on the home header",
    "placeholders": { "name": { "type": "String", "example": "Sara" } }
  }
}
```

Plurals (`{count, plural, =0{...} =1{...} other{...}}`) and selects
(`{gender, select, ...}`) are supported by the same generator — mirror the placeholder
metadata in every locale file.

## Consume in a widget

```dart
// Inside build():
Text(context.l10n.helloUser('Sara'))
```

Never hardcode a locale/family in the widget — fonts follow the locale automatically
(see [.claude/rules/l10n.md](../../rules/l10n.md) and
[.claude/rules/theming.md](../../rules/theming.md)).
