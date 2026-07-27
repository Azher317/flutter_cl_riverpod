---
paths:
  - "lib/features/*/presentation/**"
  - "lib/core/widgets/**"
---

# Widget authoring rules

Building UI? Read [docs/widgets.md](../../docs/widgets.md) for the shared-widget catalogue
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
   added to `app_en.arb` *and* `app_ar.arb`. Proper nouns are the only exception
   (and deserve a comment).
4. **Core vs feature placement.** A widget belongs in `core/widgets/` **iff** it
   names no feature vocabulary, imports no feature provider or entity, and could be
   dropped into an unrelated app unchanged. That's why
   [custom_text_form_field.dart](../../lib/core/widgets/form_fields/custom_text_form_field.dart)
   is core while
   [password_text_form_field.dart](../../lib/features/auth/presentation/widgets/password_text_form_field.dart)
   (owns the auth-specific obscure toggle and the `typeYourPasswordHere` string) and
   [phone_number_form_field.dart](../../lib/features/auth/presentation/widgets/phone_number_form_field.dart)
   (country picker + Iraqi-number validation) live in the feature. Both *compose*
   `CustomTextFormField` — feature widgets wrap core widgets, they never fork them.
   A feature widget that turns out to be generic gets moved to `core/` and stripped
   of its feature vocabulary, not copied.
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

## Anti-patterns (widgets & assets)

| Don't | Why | Do instead |
|---|---|---|
| `SvgPicture.asset('assets/images/svg/x.svg')` | Bypasses the one place the path is built | `ImageSvg(img: SvgAssets.x)` |
| `Image.network(...)` | No cache, no placeholder, no error/retry | `CachedImage(url)` |
| Raw `showModalBottomSheet` | Misses root navigator, safe area, sizing defaults | `customModalBottomSheet(context, child: ...)` |
| `CustomDialog` | Unrefactored, hardcoded Arabic labels | `showDialog` + `AlertDialog` (already themed) |
| Hardcoded colour / font / radius in a widget | Breaks dark mode and rebranding | `context.colorScheme.*`, `context.textTheme.*`, `Insets`/`BorderSize` |
| String literal shown to a user | Untranslatable | `context.l10n.<key>`, added to both `.arb` files |

## See also

- Paged lists: `usePagingControllerEither` + `controller.defaultListDelegate(...)` —
  [pagination.md](pagination.md).
- Never `context.go(...)` imperatively after login/logout; the router redirects on
  session change — [routing.md](routing.md).
