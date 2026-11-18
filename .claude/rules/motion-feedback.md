---
paths:
  - "lib/features/*/presentation/**"
  - "lib/core/widgets/**"
  - "lib/core/theme/**"
  - "lib/core/settings/**"
  - "lib/app.dart"
---

# Motion, appearance changes and haptics

1. **Theme and language change only through `AppearanceActions`**
   ([appearance_actions.dart](../../lib/core/settings/appearance_actions.dart)):
   `ref.changeThemeMode(context, mode, origin:)`, `ref.toggleThemeMode(...)`,
   `ref.changeLocale(context, locale, origin:)`. They play the one circular reveal
   ([theme_reveal.dart](../../lib/core/theme/theme_reveal.dart)) from the tap and a
   `selection` haptic. Never call `settingsProvider.notifier.setThemeMode/setLocale`
   from a widget. Pass `origin:` from a `TapOrigin` so the circle starts at the finger.
   A sheet that triggered the change closes **after** the returned future completes.
2. **Every modal sheet is `customModalBottomSheet`.** It leans the screen behind back
   (phones only, not with reduced motion). Never `showModalBottomSheet` directly.
3. **Respect reduced motion.** Check `context.reduceMotion` before any decorative
   animation; under it, skip the motion and show the end state (keep state changes,
   drop movement). `ReduceMotionScope` (in `app.dart`) makes iOS Reduce Motion count.
4. **Durations and curves come from `Time` and `Motion`** in
   [sizes.dart](../../lib/core/utils/constants/sizes.dart). No inline `Duration(...)`
   or `Cubic(...)` in widgets.
5. **Haptics only through `AppHaptics`**, following [docs/haptics.md](../../docs/haptics.md).
   Plain buttons never vibrate. Never `HapticFeedback.*` directly.
6. **Never `AnimationStyle.noAnimation` on `MaterialApp.themeAnimationStyle`**: it
   remounts the whole app. Use a zero duration (`ThemeX.changeAnimation`).
