import 'package:flutter/material.dart';

/// Font families declared under `fonts:` in pubspec.yaml.
///
/// ───────────────────────────────────────────────────────────────────────────
/// ⚠️  PLACEHOLDER FONTS — template defaults, not brand fonts.
///
/// These four families exist so a fresh clone looks finished out of the box.
/// Replace them with the real brand fonts: edit the constants here, the
/// `fonts:` block in pubspec.yaml, and the .ttf files in assets/fonts/. The
/// names below must match the `family:` keys in pubspec.yaml
/// character-for-character.
///
/// The role split (display vs body) and the script split (Latin vs Arabic)
/// live in [AppFontScheme], below.
/// ───────────────────────────────────────────────────────────────────────────
///
/// ── If you want ONE font for both English and Arabic ───────────────────────
/// Pick a family that carries both Latin and Arabic glyphs (Noto Sans Arabic,
/// Cairo, IBM Plex Sans Arabic, Almarai). Then either:
///   a) keep one constant here, e.g. `static const String primary = 'Cairo';`
///      and point both [AppFontScheme.latin] and [AppFontScheme.arabic] at
///      `AppFontScheme(display: primary, body: primary)`; or
///   b) delete [AppFontScheme] entirely and go back to a plain
///      `fontFamily: AppFonts.primary` in `AppTheme._build` and
///      `AppTheme._textTheme`, dropping the `fonts` parameter from both.
///
/// ── If you want TWO fonts (one display, one body) for BOTH languages ───────
/// Keep two constants here and make the two schemes the same instance:
///   `static const AppFontScheme arabic = latin;`
/// Nothing else changes — [AppTheme] and the widgets never name a family
/// directly, they only ever read roles off `TextTheme`.
class AppFonts {
  const AppFonts._();

  // ── Latin ────────────────────────────────────────────────────────────────
  static const String playfairDisplay = 'PlayfairDisplay';
  static const String workSans = 'WorkSans';

  // ── Arabic ───────────────────────────────────────────────────────────────
  static const String arefRuqaa = 'ArefRuqaa';
  static const String tajawal = 'Tajawal';
}

/// Which family plays which typographic role, for one script.
///
/// Two axes, kept apart: the *role* axis (display vs body) is these fields, the
/// *script* axis (Latin vs Arabic) is the named instances. `AppTheme` maps the
/// roles onto Flutter's `TextTheme`, so no widget ever names a font family —
/// widgets read `Theme.of(context).textTheme.*` and get the right font for the
/// active locale for free.
///
/// See [AppFonts] above for how to collapse this to one or two fonts total.
@immutable
class AppFontScheme {
  /// Used by `display*`, `headline*` and `title*` styles.
  final String display;

  /// Used by `body*` and `label*` styles, and as `ThemeData.fontFamily` — the
  /// app-wide default for anything that doesn't resolve a `TextTheme` role.
  final String body;

  const AppFontScheme({required this.display, required this.body});

  static const AppFontScheme latin = AppFontScheme(
    display: AppFonts.playfairDisplay,
    body: AppFonts.workSans,
  );

  static const AppFontScheme arabic = AppFontScheme(
    display: AppFonts.arefRuqaa,
    body: AppFonts.tajawal,
  );

  /// Arabic-script locales take [arabic]; everything else falls back to
  /// [latin]. A null locale means "follow the system", which also lands on
  /// [latin] — the safe default, since the Latin faces degrade more gracefully
  /// than an Arabic display face does on Latin text.
  static AppFontScheme of(Locale? locale) => switch (locale?.languageCode) {
    'ar' || 'ckb' || 'ku' || 'fa' || 'ur' => arabic,
    _ => latin,
  };
}
