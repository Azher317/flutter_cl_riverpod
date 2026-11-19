import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/widgets/branding/splash_host.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The page for every screen route: `GoRoute(pageBuilder: appPage(…))`.
/// One fade-through on every platform ([FadeThroughPage]).
Page<void> appPage(BuildContext context, GoRouterState state, Widget child) =>
    FadeThroughPage<void>(
      key: state.pageKey,
      // Route logs and the route observer name the screen, not the class.
      name: state.name ?? state.matchedLocation,
      child: child,
    );

/// The outgoing page is gone by this fraction of the transition; only then
/// does the incoming one appear, so the two never overlap.
const double _outEnd = 0.35;

/// The incoming page grows from this scale to 1 while it fades in.
const double _inScale = 0.96;

/// Fade-through over [Time.page] ([Motion.standard]), the same on Android
/// and iOS:
///
/// 1. **0 → [_outEnd]:** the outgoing page fades out while the incoming
///    route's surface fades in beneath it (never a black frame).
/// 2. **[_outEnd] → 1:** the incoming page fades in, scaling from
///    [_inScale] to 1.
///
/// Pop plays the same backwards. Reduced motion: the same fades, no scale.
/// iOS keeps the native edge swipe-back (the page follows the finger).
/// The route pushed under the splash skips its entrance ([SplashHandoff]).
/// Bottom sheets' backdrop tilt works on these pages
/// ([canTransitionTo]).
class FadeThroughPage<T> extends Page<T> {
  const FadeThroughPage({super.key, super.name, required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) => _FadeThroughRoute<T>(this);
}

class _FadeThroughRoute<T> extends PageRoute<T> {
  _FadeThroughRoute(FadeThroughPage<T> page) : super(settings: page);

  FadeThroughPage<T> get _page => settings as FadeThroughPage<T>;

  @override
  Duration get transitionDuration => Time.page;

  @override
  Duration get reverseTransitionDuration => Time.page;

  @override
  bool get maintainState => true;

  /// Page → page, and any route that hands this one a `delegatedTransition`
  /// (the app's bottom sheets, which lean this page back while open).
  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is PageRoute ||
      (nextRoute is ModalRoute && nextRoute.delegatedTransition != null);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => Semantics(
    scopesRoute: true,
    explicitChildNodes: true,
    child: HeroMode(enabled: !context.reduceMotion, child: _page.child),
  );

  /// Pushed while the splash is still up; decided once.
  late final bool _underSplash = switch (navigator) {
    final nav? =>
      SplashHandoff.maybeOf(nav.context, listen: false)?.active ?? false,
    null => false,
  };

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Its entrance only: a later pop still fades it out.
    if (_underSplash && animation.status != AnimationStatus.reverse) {
      animation = kAlwaysCompleteAnimation;
    }
    final ios = Theme.of(context).platform == TargetPlatform.iOS;
    // iOS swipe-back: while the user drags from the edge, the native
    // Cupertino transition gets the real animations (the page follows the
    // finger) and the fade-through rests. Otherwise the Cupertino transition
    // rests but its back-gesture detector stays in the tree, ready. The tree
    // has the same shape either way, so the page never loses its state.
    final swiping = ios && popGestureInProgress;
    final page = ios
        ? CupertinoRouteTransitionMixin.buildPageTransitions<T>(
            this,
            context,
            swiping ? animation : kAlwaysCompleteAnimation,
            swiping ? secondaryAnimation : kAlwaysDismissedAnimation,
            child,
          )
        : child;
    return _FadeThrough(
      animation: swiping ? kAlwaysCompleteAnimation : animation,
      secondaryAnimation: swiping
          ? kAlwaysDismissedAnimation
          : secondaryAnimation,
      reduceMotion: context.reduceMotion,
      child: page,
    );
  }
}

class _FadeThrough extends StatelessWidget {
  const _FadeThrough({
    required this.animation,
    required this.secondaryAnimation,
    required this.reduceMotion,
    required this.child,
  });

  static const Curve _out = Interval(0, _outEnd, curve: Motion.standard);
  static const Curve _in = Interval(_outEnd, 1, curve: Motion.standard);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool reduceMotion;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([animation, secondaryAnimation]),
    child: child,
    builder: (context, child) {
      final enter = _in.transform(animation.value);
      // This page leaving (another page is coming in over it).
      final leave = 1 - _out.transform(secondaryAnimation.value);
      // Hidden at rest: the opaque page covers it anyway (no overdraw).
      final backdropOpacity = enter == 1
          ? 0.0
          : _out.transform(animation.value) * leave;
      // Reduced motion keeps the fades and drops the scale; the Transform
      // stays in the tree so toggling the setting doesn't remount the page.
      final scale = reduceMotion ? 1.0 : _inScale + (1 - _inScale) * enter;
      return Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: backdropOpacity,
            child: ColoredBox(color: Theme.of(context).colorScheme.surface),
          ),
          Opacity(
            opacity: enter * leave,
            child: Transform.scale(scale: scale, child: child),
          ),
        ],
      );
    },
  );
}
