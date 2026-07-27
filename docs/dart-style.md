# Dart & Flutter style

General craftsmanship guidance distilled from the official Flutter/Dart rules. This is the
**default** style baseline; it is deliberately *additive* and never overrides a project
rule. Where the two meet, the project wins — see the deferrals below.

## This project already decides these — don't apply the generic advice

| Generic advice (ignore here) | This project's rule | Source |
|---|---|---|
| Prefer built-in state (`ValueNotifier`/`ChangeNotifier`/`setState`) | State is **Riverpod** `@riverpod` notifiers holding `AsyncValue` | [CLAUDE.md](../.claude/CLAUDE.md) rule 14 |
| Manual constructor DI / `provider` | DI is `@riverpod` provider functions in each feature's `di/` | CLAUDE.md rule 14 |
| `logging` pkg / `dart:developer` `log` | All logging flows through Talker + `AppLogger` | [observability.md](../.claude/rules/observability.md) |
| `Image.network` + loading/error builders; `cached_network_image` | Use `CachedImage`; `Image.network` is a listed anti-pattern | [presentation.md](../.claude/rules/presentation.md) |
| `google_fonts` for fonts | Bundled fonts via `AppFontScheme.of(locale)` | [theming.md](../.claude/rules/theming.md) |
| `try-catch` / custom exceptions ad hoc | Layered `Either<Failure,T>` + `guard()`; presentation sees only `Failure` | CLAUDE.md rules 6–10 |
| Hand-rolled `ThemeExtension`/`ColorScheme.fromSeed` tutorials | Already built: `AppStatusColors`, seeded schemes | theming.md |

Also ignore the generic "assume the user is new to Dart / explain null safety" persona and
any references to tools that don't exist here (`dart_format`, `dart_fix`, `analyze_files`,
`pub_dev_search`, `run_tests`). Real commands live in CLAUDE.md → Commands.

## Dart

- Follow [Effective Dart](https://dart.dev/effective-dart).
- Sound null safety: avoid `!` unless the value is guaranteed non-null.
- Use pattern matching, records (for ad-hoc multi-value returns), and **exhaustive**
  `switch` expressions/statements (no `break` needed).
- Arrow syntax for simple one-line functions.
- Keep functions short and single-purpose (aim < 20 lines); lines ≤ 80 chars.
- `PascalCase` types, `camelCase` members, `snake_case` files. No abbreviations.
- Prefer immutable data structures.

## Flutter widgets

- Composition over inheritance; compose small widgets rather than deep nesting.
- **Private `Widget` classes over private helper methods that return a `Widget`.**
- Break large `build()` methods into smaller widget classes.
- `const` constructors and `const` call sites wherever possible
  (already promoted to warnings — [presentation.md](../.claude/rules/presentation.md) rule 5).
- Don't do network calls or heavy computation inside `build()`.
- Use `compute()` to move expensive work (e.g. big JSON parses) off the UI isolate.

## Layout (overflow-safe)

- Rows/Columns: `Expanded` to fill, `Flexible` to shrink-to-fit; don't mix the two in one
  Row/Column. `Wrap` when children would overflow onto a new line.
- Long lists/grids: always the `.builder` constructor (`ListView.builder`, `SliverList`).
- `SingleChildScrollView` for fixed-size content larger than the viewport.
- `FittedBox` to scale a single child; `LayoutBuilder`/`MediaQuery` for responsive
  decisions.
- `Stack`: `Positioned` to anchor, `Align` to align. `OverlayPortal` for dropdowns/tooltips
  that must float above everything.

## Accessibility

- Text contrast ≥ 4.5:1 (≥ 3:1 for large text).
- Keep the UI usable when the system font size is increased (dynamic text scaling).
- Add `Semantics` labels for non-obvious interactive elements.

## Documentation

- `///` dartdoc on public APIs; first sentence a concise summary ending with a period,
  then a blank line.
- Comment *why*, not *what*; don't restate the obvious from a name. No trailing comments.
- Backtick fences (with a language) for code samples.
