import 'package:flutter/widgets.dart';

/// Makes the OS's "reduce motion" settings reach `context.reduceMotion` on
/// every platform, live.
///
/// Flutter's `MediaQueryData.disableAnimations` only carries Android's
/// "Remove animations". iOS **Reduce Motion** arrives as a separate flag,
/// `AccessibilityFeatures.reduceMotion`, which `MediaQueryData` doesn't
/// copy — so without this scope every check here was blind to it on the
/// iPhone. This republishes the `MediaQuery` below it with
/// `disableAnimations = disableAnimations || reduceMotion`, and rebuilds
/// when the user toggles either setting (no restart needed).
///
/// Sits above `MaterialApp` (app.dart), so the theme animation, routes,
/// sheets, dialogs and toasts all see it.
class ReduceMotionScope extends StatefulWidget {
  const ReduceMotionScope({super.key, required this.child});

  final Widget child;

  @override
  State<ReduceMotionScope> createState() => _ReduceMotionScopeState();
}

class _ReduceMotionScopeState extends State<ReduceMotionScope>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Toggled in the OS settings while the app runs: re-read on return.
  // (iOS Reduce Motion alone doesn't change MediaQueryData, so nothing
  // above would rebuild us.)
  @override
  void didChangeAccessibilityFeatures() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final reduce =
        media.disableAnimations ||
        View.of(context).platformDispatcher.accessibilityFeatures.reduceMotion;
    return MediaQuery(
      data: media.copyWith(disableAnimations: reduce),
      child: widget.child,
    );
  }
}
