import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/material.dart';

class ThemeX {
  const ThemeX._();

  static ThemeMode getOppositeThemeMode(ThemeMode value, BuildContext context) {
    switch (value) {
      case ThemeMode.system:
        final brightness = MediaQuery.platformBrightnessOf(context);
        return brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.light;
    }
  }

  /// How the app's theme moves between light and dark
  /// (`MaterialApp.themeAnimationStyle`):
  ///
  /// - A change nobody tapped (theme = system and the phone switches): a
  ///   soft fade through `ThemeData.lerp` over [Time.small].
  /// - [revealing] (a circular reveal is running, theme or language):
  ///   instant, so the circle uncovers the final colours, never a blend.
  /// - Reduced motion: instant.
  ///
  /// "Instant" is a zero duration, never `AnimationStyle.noAnimation`: that
  /// swaps MaterialApp's `AnimatedTheme` for a plain `Theme` and remounts
  /// the whole app (router, open screens, state).
  static AnimationStyle changeAnimation(
    BuildContext context, {
    bool revealing = false,
  }) => AnimationStyle(
    duration: revealing || context.reduceMotion ? Time.none : Time.small,
    curve: Motion.standard,
  );
}
