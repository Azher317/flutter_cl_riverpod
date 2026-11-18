import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/break_line.dart';
import 'package:flutter/material.dart';

/// The app's bottom sheet. Surface, shape and clipping come from
/// `bottomSheetTheme`; everything here is behaviour or sizing.
///
/// While it's open, the screen behind a phone sheet leans back
/// ([SheetBackdropLean]) and follows the sheet as it opens, closes or is
/// dragged. On a tablet (window ≥ [Layout.tabletBreakpoint]) or with reduced
/// motion, the screen stays still under the scrim.
///
/// Use this for every modal sheet, never `showModalBottomSheet` directly,
/// so all sheets move the same way.
Future<T?> customModalBottomSheet<T>(
  BuildContext context, {
  bool isDismissible = true,
  bool isScrollControlled = false,
  bool showDragHandle = false,
  double? height,
  double? width,
  required Widget child,
}) {
  final reduce = context.reduceMotion;
  final navigator = Navigator.of(context, rootNavigator: true);
  final localizations = MaterialLocalizations.of(context);
  final sheetTheme = Theme.of(context).bottomSheetTheme;
  return navigator.push(
    _AppSheetRoute<T>(
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      barrierLabel: localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(
        localizations.bottomSheetLabel,
      ),
      modalBarrierColor: sheetTheme.modalBarrierColor,
      backgroundColor: sheetTheme.backgroundColor,
      shape: sheetTheme.shape,
      clipBehavior: sheetTheme.clipBehavior,
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: 0.75,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      useSafeArea: true,
      sheetAnimationStyle: AnimationStyle(
        duration: reduce ? Time.none : Time.sheetEnter,
        reverseDuration: reduce ? Time.none : Time.sheetExit,
        curve: Motion.emphasizedDecelerate,
        reverseCurve: Motion.emphasizedAccelerate,
      ),
      builder: (context) => SizedBox(
        height: height ?? context.height * 0.75,
        width: width ?? context.width,
        child: Column(
          children: [
            if (showDragHandle)
              BreakLine(width: context.width * 0.5, height: 4),
            Expanded(child: child),
          ],
        ),
      ),
    ),
  );
}

/// [ModalBottomSheetRoute] that leans the screen below it back
/// ([delegatedTransition]), with a scrim that follows the live theme and the
/// sheet's progress one-to-one.
class _AppSheetRoute<T> extends ModalBottomSheetRoute<T> {
  _AppSheetRoute({
    required super.builder,
    required super.isScrollControlled,
    super.capturedThemes,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.modalBarrierColor,
    super.backgroundColor,
    super.shape,
    super.clipBehavior,
    super.scrollControlDisabledMaxHeightRatio,
    super.isDismissible,
    super.enableDrag,
    super.useSafeArea,
    super.sheetAnimationStyle,
  });

  /// The scrim of the *current* theme, not the one captured at push: a sheet
  /// can stay open across a light ⇄ dark change (an appearance sheet), and
  /// the old scrim must not linger.
  @override
  Color get barrierColor {
    final context = navigator?.context;
    return (context == null
            ? null
            : Theme.of(context).bottomSheetTheme.modalBarrierColor) ??
        super.barrierColor;
  }

  /// The stock barrier, rebuilt when the theme changes so it reads
  /// [barrierColor] again.
  @override
  Widget buildModalBarrier() => Builder(
    builder: (context) {
      Theme.of(context);
      return super.buildModalBarrier();
    },
  );

  /// The scrim follows the sheet one-to-one (opening, closing, dragging).
  @override
  Curve get barrierCurve => Motion.linear;

  @override
  DelegatedTransitionBuilder? get delegatedTransition => _leanBack;

  /// `secondaryAnimation` is this sheet's own animation; dragging the sheet
  /// writes to it, so the lean follows the finger.
  static Widget? _leanBack(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) => context.reduceMotion || context.width >= Layout.tabletBreakpoint
      ? null
      : SheetBackdropLean(progress: secondaryAnimation, child: child);
}

/// The screen behind an open sheet, leaning back by [progress] (0 upright,
/// 1 fully open): pivoted on its top edge, the bottom edge recedes
/// ([Motion.sheetLeanTilt], [Motion.sheetLeanPerspective]); the corners
/// round and show the scrim colour behind. Symmetric, so RTL looks the same.
@visibleForTesting
class SheetBackdropLean extends StatelessWidget {
  const SheetBackdropLean({
    super.key,
    required this.progress,
    required this.child,
  });

  final Animation<double> progress;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final behind = context.colorScheme.scrim.withValues(alpha: 1);
    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (context, child) {
        final t = progress.value;
        return ColoredBox(
          color: behind,
          child: Transform(
            alignment: Alignment.topCenter,
            // A positive rotateX pushes points below the pivot away from the
            // viewer: the bottom edge recedes, the top stays put.
            transform: Matrix4.identity()
              ..setEntry(3, 2, Motion.sheetLeanPerspective)
              ..rotateX(Motion.sheetLeanTilt * t),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(BorderSize.small * t),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
