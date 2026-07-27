import 'package:app/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

/// The radius rule. Every component theme in [AppComponentThemes] picks one of
/// these three tiers rather than inventing a value — that is the whole point of
/// naming them. Containers sit *in* the layout, overlays sit *over* it, buttons
/// are the one deliberately rounder affordance.
///
/// Widgets that build their own rounded surface (rather than going through a
/// themed component) should reach for these too, so hand-rolled shapes stay in
/// step with the theme.
class _AppShapes {
  const _AppShapes._();

  static const BorderRadius container = BorderSize.smallRadius;
  static const BorderRadius overlay = BorderSize.smallRadius;
  static const BorderRadius button = BorderSize.smallRadius;

  /// Overlays that slide up from the bottom round their top edge only.
  static const BorderRadius overlayTop = BorderRadius.only(
    topLeft: Radius.circular(BorderSize.small),
    topRight: Radius.circular(BorderSize.small),
  );

  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    vertical: 14,
    horizontal: 12,
  );
}

/// Per-component theming, one builder per Material component. Assembled into a
/// `ThemeData` by `AppTheme._build`; the text scale lives in `AppTextTheme`.
///
/// Builders take only what they need — a [ColorScheme], a [TextTheme], or both.
/// The ones taking a [TextTheme] must be applied *after* the app's own text
/// theme is in place; see the two-phase build in `AppTheme._build`.
class AppComponentThemes {
  const AppComponentThemes._();

  static CheckboxThemeData checkbox(ColorScheme c) => CheckboxThemeData(
    shape: const RoundedRectangleBorder(borderRadius: BorderSize.xxsRadius),
    side: BorderSide(color: c.onSurfaceVariant),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static AppBarTheme appBar(ColorScheme c) => AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: c.surface,
    foregroundColor: c.onSurface,
    actionsPadding: const EdgeInsets.symmetric(horizontal: Insets.medium),
  );

  static CardThemeData card(ColorScheme c) => CardThemeData(
    color: c.surfaceContainerLow,
    elevation: 0,
    shape: const RoundedRectangleBorder(borderRadius: _AppShapes.container),
  );

  static DatePickerThemeData datePicker(ColorScheme c) => DatePickerThemeData(
    backgroundColor: c.surfaceContainerHigh,
    shape: const RoundedRectangleBorder(borderRadius: _AppShapes.overlay),
  );

  static NavigationBarThemeData navigationBar(ColorScheme c) =>
      NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.secondaryContainer,
        elevation: 0,
      );

  /// Shape and surface for *every* modal sheet, so a bare
  /// `showModalBottomSheet` matches `customModalBottomSheet` without repeating
  /// itself. Sizing and drag-handle behaviour stay at the call site.
  static BottomSheetThemeData bottomSheet(ColorScheme c) =>
      BottomSheetThemeData(
        backgroundColor: c.surface,
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        showDragHandle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: _AppShapes.overlayTop,
        ),
      );

  static DialogThemeData dialog(ColorScheme c) => DialogThemeData(
    backgroundColor: c.surfaceContainerHigh,
    elevation: 0,
    shape: const RoundedRectangleBorder(borderRadius: _AppShapes.container),
  );

  static DividerThemeData divider(ColorScheme c) => DividerThemeData(
    color: c.outlineVariant,
    thickness: 0.5,
    space: Insets.medium,
  );

  static ProgressIndicatorThemeData progressIndicator(ColorScheme c) =>
      ProgressIndicatorThemeData(color: c.primary, strokeWidth: 2);

  static IconThemeData icon(ColorScheme c) =>
      IconThemeData(size: IconSize.medium, color: c.onSurface);

  static IconButtonThemeData iconButton(ColorScheme c) => IconButtonThemeData(
    style: IconButton.styleFrom(
      iconSize: IconSize.medium,
      foregroundColor: c.onSurface,
      overlayColor: c.primary.withValues(alpha: 0.12),
    ),
  );

  /// Only the parts that are the same for every message. The per-`MessageType`
  /// background and foreground stay in `AppMessenger` — a static theme can't
  /// express them.
  static SnackBarThemeData snackBar(TextTheme t) => SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    insetPadding: const EdgeInsets.fromLTRB(
      Insets.medium,
      0,
      Insets.medium,
      Insets.medium,
    ),
    shape: const RoundedRectangleBorder(borderRadius: _AppShapes.container),
    contentTextStyle: t.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      height: 1.35,
    ),
  );

  static ListTileThemeData listTile(TextTheme t) => ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: Insets.medium,
      vertical: Insets.extraSmall,
    ),
    shape: const RoundedRectangleBorder(borderRadius: _AppShapes.container),
    titleTextStyle: t.bodyLarge,
    subtitleTextStyle: t.bodySmall,
  );

  static InputDecorationTheme inputDecoration(ColorScheme c, TextTheme t) {
    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: _AppShapes.container,
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationTheme(
      contentPadding: _AppShapes.fieldPadding,
      filled: true,
      fillColor: c.surfaceContainerLowest,
      hintStyle: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
      border: border(Colors.transparent),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(c.primary),
      errorBorder: border(c.error),
      focusedErrorBorder: border(c.error, width: 2),
      disabledBorder: border(Colors.transparent),
      activeIndicatorBorder: BorderSide.none,
    );
  }

  static FilledButtonThemeData filledButton(TextTheme t, ColorScheme c) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: c.onPrimary,
          // Let M3's default disabled foreground (onSurface @ 38%) signal the
          // disabled state instead of forcing full-strength onPrimary.
          minimumSize: const Size(double.infinity, 52),
          maximumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(borderRadius: _AppShapes.button),
          // Color comes from foregroundColor; keep it out of textStyle so the
          // disabled color can apply.
          textStyle: t.labelMedium,
        ),
      );

  static OutlinedButtonThemeData outlinedButton() => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: _AppShapes.fieldPadding,
      minimumSize: const Size(double.infinity, 52),
      shape: const RoundedRectangleBorder(borderRadius: _AppShapes.button),
    ),
  );

  static TextButtonThemeData textButton() => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const RoundedRectangleBorder(borderRadius: _AppShapes.button),
    ),
  );
}
