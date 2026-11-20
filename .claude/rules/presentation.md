---
paths:
  - "lib/features/*/presentation/**"
  - "lib/core/widgets/**"
---

# Widget authoring rules

Building UI? Read [docs/guides/widgets.md](../../docs/guides/widgets.md) for the shared-widget catalogue
before authoring.

1. **Theme over hardcoding.** No `Color(0x...)`, no `TextStyle(fontFamily: ...)`, no
   ad-hoc radii. Read `context.colorScheme.*`, `context.textTheme.*`,
   `Theme.of(context).appStatusColors`, and the `Insets`/`BorderSize`/`IconSize`/`Time`
   constants. A widget written as `scheme.primary` is automatically correct in dark
   mode; a literal hex is frozen to one theme forever.
2. **Style once, in the theme.** If three widgets need the same look, add or extend a
   builder in [component_themes.dart](../../lib/core/theme/component_themes.dart) instead of
   repeating a `style:` at each call site.
3. **Localization over literals.** Every user-visible string is `context.l10n.<key>`,
   added to every ARB the app ships. Proper nouns are the only exception
   (and deserve a comment).
4. **Reuse before writing (rule 17).** Before building a widget, check
   [widgets.md](../../docs/guides/widgets.md), `lib/core/widgets/` and `lib/shared/`.
   - One almost fits: add a parameter to it, keep every current use working
     and its tests passing. Never fork it.
   - None fits: say why in the plan, then build it in `core/widgets/` if it
     names no business word and could drop into an unrelated app unchanged,
     otherwise in `lib/shared/`. Add one line for it to `widgets.md`.
   - A feature's `presentation/widgets/` holds only private pieces of that
     feature's screens.
   - When a second feature needs data another feature changes (a product
     became unavailable), share it through a provider in `lib/shared/` that
     both watch; never reach into the other feature.
5. **Const-correctness.** `prefer_const_constructors`,
   `prefer_const_constructors_in_immutables`, `prefer_const_declarations` and
   `prefer_const_literals_to_create_immutables` are promoted to **warning** in
   [analysis_options.yaml](../../analysis_options.yaml). Give every widget a `const`
   constructor and mark call sites `const` where possible.
6. **RTL correctness.** Prefer `EdgeInsetsDirectional` / `AlignmentDirectional` /
   `BorderRadiusDirectional` over their LTR-fixed counterparts (see
   [svg_prefix_icon.dart](../../lib/core/widgets/svg_prefix_icon.dart)). Never
   hardcode `TextAlign.left`/`right`. Use `DirectionalIcon` for arrows that must
   flip. Fonts follow the locale automatically via `AppFontScheme.of(locale)` — never
   name a family in a widget.
7. **`use_build_context_synchronously` is a warning.** Guard `context` use after an
   `await` with a `mounted` check.
8. **Keys.** `use_key_in_widget_constructors` is on — every public widget takes
   `super.key`.
9. **Size.** Keep a file under ~300 lines and one screen per file. A screen that grows
   past that splits its sections into `widgets/` files (private `_Section` classes
   moved out as public, feature-local widgets).
10. **Motion and haptics** follow [motion-feedback.md](motion-feedback.md) and
    [docs/guides/haptics.md](../../docs/guides/haptics.md).
11. **Phone numbers** are always `PhoneFormField` and sent as
    `PhoneFormField.valueOf(text)`; the format (Iraqi-only or international) is
    `AppConfig.phoneFormat`, chosen once per app.
12. **MediaQuery reads are narrow.** `MediaQuery.sizeOf(context)` / `paddingOf` /
    `viewInsetsOf` (or `context.width/height`), never `MediaQuery.of(context).x`: the
    latter rebuilds the widget on every keyboard, inset or text-scale change.

13. **No overflow on small phones.** A new screen gets a widget test with
    `testAtScreenSizes` (`test/helpers/screen_sizes.dart`): 375×667 and 360×640,
    plus the tablet sizes in apps that support tablets.

14. **Widget tests use the real providers with overrides.** Wrap the widget in
    `ProviderScope(overrides: [...])`, overriding the repository or data source
    provider with a fake, never the notifier itself. `pumpApp` from
    `test/helpers/pump_app.dart` supplies theme and localizations.

## Loading states (skeletons)

1. **A screen that loads data shows a skeleton, not a spinner.** Spinners are for
   actions (a button submitting), not for content.
2. **The skeleton is the real screen.** Wrap the real widgets in
   `AppSkeleton(enabled: …)` and feed them placeholder data
   (`Entity.placeholder()` / `Entity.placeholders(n)`, defined next to the entity in
   the feature's `presentation/` layer, never in `domain/`). Never hand-draw a second
   layout of grey boxes: it drifts from the real one, and the screen jumps when data
   arrives.
3. **Same size as the data.** Placeholder text has a realistic length (a name ~12
   characters, a title ~30), lists show as many rows as fit one screen (usually 5–8),
   images keep their real aspect ratio. When data arrives, nothing moves; the bones
   simply turn into content.
4. **Only the part that loads.** App bar, tabs, filters and already-known content stay
   real; only the region waiting for data is skeletonized. Pull-to-refresh and
   pagination keep the old data on screen (`enabled: state.isLoading && !state.hasValue`).
5. **Hand-made bones only when placeholder data can't produce the layout** (a map, a
   chart). Then use `Bone` widgets from `skeletonizer` sized from the same constants as
   the real widget, and add a widget test comparing the two sizes.

## Anti-patterns (widgets & assets)

| Don't | Why | Do instead |
|---|---|---|
| `SvgPicture.asset('assets/images/svg/x.svg')` | Bypasses the one place the path is built | `ImageSvg(img: SvgAssets.x)` |
| `Image.network(...)` | No cache, no placeholder, no error/retry | `CachedImage(url)` |
| Raw `showModalBottomSheet` | Misses root navigator, safe area, sizing defaults, the backdrop lean | `customModalBottomSheet(context, child: ...)` |
| `CircularProgressIndicator` as a screen's loading state | Layout jumps when data arrives | `AppSkeleton` around the real widgets with placeholder data |
| `HapticFeedback.*` / a vibration plugin | Inconsistent meanings, no throttle | `AppHaptics.*` per [docs/guides/haptics.md](../../docs/guides/haptics.md) |
| `settings.setThemeMode` / `setLocale` from a widget | Skips the reveal | `ref.changeThemeMode` / `ref.changeLocale` |
| `CustomDialog` | Unrefactored, hardcoded Arabic labels | `showDialog` + `AlertDialog` (already themed) |
| Hardcoded colour / font / radius in a widget | Breaks dark mode and rebranding | `context.colorScheme.*`, `context.textTheme.*`, `Insets`/`BorderSize` |
| String literal shown to a user | Untranslatable | `context.l10n.<key>`, added to both `.arb` files |

## See also

- Paged lists: `usePagingControllerEither` + `controller.defaultListDelegate(...)` —
  [pagination.md](pagination.md).
- Never `context.go(...)` imperatively after login/logout; the router redirects on
  session change — [routing.md](routing.md).
