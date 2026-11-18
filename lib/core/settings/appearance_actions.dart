import 'package:app/core/feedback/app_haptics.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/theme/theme_change.dart';
import 'package:app/core/theme/theme_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The only way UI changes the theme or the language: every change plays
/// the same circular reveal ([ThemeRevealHost]) from [origin] (a global
/// position, usually where the finger went down; the screen centre when
/// `null`) and a selection haptic.
///
/// Never call `settingsProvider.notifier.setThemeMode / setLocale` from a
/// widget directly: that skips the reveal and the app would switch with a
/// plain cross-fade on one screen and a circle on another.
///
/// Completes once the circle has covered the screen. A sheet that asked for
/// the change should close only after that (keep what's under the
/// screenshot still), e.g. `await …; if (context.mounted) Navigator.pop(…)`.
extension AppearanceActions on WidgetRef {
  Future<void> changeThemeMode(
    BuildContext context,
    ThemeMode mode, {
    Offset? origin,
  }) {
    final settings = read(settingsProvider.notifier);
    if (read(settingsProvider).themeMode == mode) return Future.value();
    AppHaptics.selection();
    return context.revealThemeChange(
      mode,
      origin: origin,
      apply: () => settings.setThemeMode(mode),
    );
  }

  /// Light ⇄ dark from what's on screen now (system resolves to the
  /// platform brightness first).
  Future<void> toggleThemeMode(BuildContext context, {Offset? origin}) =>
      changeThemeMode(
        context,
        ThemeX.getOppositeThemeMode(read(settingsProvider).themeMode, context),
        origin: origin,
      );

  Future<void> changeLocale(
    BuildContext context,
    Locale locale, {
    Offset? origin,
  }) {
    final settings = read(settingsProvider.notifier);
    if (Localizations.localeOf(context).languageCode == locale.languageCode) {
      return Future.value();
    }
    AppHaptics.selection();
    return context.revealLocaleChange(
      locale,
      origin: origin,
      apply: () => settings.setLocale(locale),
    );
  }
}

/// Remembers where the last pointer went down inside it, so a change can
/// reveal from the tap:
///
/// ```dart
/// TapOrigin(
///   builder: (context, origin) => IconButton(
///     onPressed: () => unawaited(ref.toggleThemeMode(context, origin: origin())),
///     icon: const Icon(Icons.dark_mode),
///   ),
/// )
/// ```
class TapOrigin extends StatefulWidget {
  const TapOrigin({super.key, required this.builder});

  final Widget Function(BuildContext context, Offset? Function() origin)
  builder;

  @override
  State<TapOrigin> createState() => _TapOriginState();
}

class _TapOriginState extends State<TapOrigin> {
  Offset? _position;

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (event) => _position = event.position,
    child: widget.builder(context, () => _position),
  );
}
