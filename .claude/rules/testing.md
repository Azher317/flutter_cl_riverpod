---
paths:
  - "test/**"
  - "lib/features/**"
---

# Testing: the minimum for every feature

What a feature must ship with. The reviewer and tester in the
`feature-build` workflow check exactly this list, and so should a normal
session before it calls a feature done.

## Where

`test/features/<feature>/`, mirroring `lib/features/<feature>/`
(`data/repositories/..._test.dart`, `presentation/screens/..._test.dart`).
Helpers live in [test/helpers/](../../test/helpers/): `pumpApp` and
`testAtScreenSizes`.

## What

| Layer | Must cover |
|---|---|
| Repository | Success, and every failure path the data source can throw (each maps to its `Failure`). |
| Notifier | Each action: loading, then data, or the `Failure` from a `Left`. |
| Screen | Loading, error (with retry), empty and success, each as its own test, plus one interaction (a tap, a submit). |
| Languages | Each screen once in every language file the app ships (`lib/l10n/arb/`): `pumpApp(..., locale: Locale('en'))` and the default Arabic; Kurdish when the app ships it. Assert one real string per language. |
| Theme | Screens with custom colours or images also run once with `themeMode: ThemeMode.dark`. |
| Sizes | Screens use `testAtScreenSizes` (and `tablets: true` in tablet apps), so overflow shows up per size. |

## How

- Fake the server by overriding providers (`ProviderScope(overrides: [...])`)
  with a fake repository or data source, as the tests under `test/core/` do.
  Never call a real server.
- Find widgets by what the user sees: text from `context.l10n`, semantics,
  icons. A `Key` only when nothing visible identifies it.
- No `skip:`, no commented-out tests, no golden files of whole screens.
- A test that fails because the code is wrong stays failing: fix the code, or
  report it. Never weaken the test to get green.
