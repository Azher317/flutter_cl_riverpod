import 'dart:async';

import 'package:app/core/utils/constants/route_names.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// The splash handover, drawn over the whole app (above the Navigator) from
/// launch until its exit has played, so the exit runs over the destination
/// screen already in place underneath. No white flash at any step:
///
/// 1. **Native splash** (`flutter_native_splash` in pubspec.yaml) stays up
///    until Flutter's first frame is ready (`main.dart` preserves it).
/// 2. **Frame 0** matches it exactly: `colorScheme.surface` with [logo] at
///    the centre. The native splash is removed only then.
/// 3. The router leaves [RouteNames.splash] (session restored; never a
///    timer). The splash waits at least [Time.splashMinimum] so it never
///    flickers, then fades out while the logo grows slightly
///    ([Time.splashExit], [Motion.emphasizedAccelerate]). Reduced motion: a
///    plain fade.
/// 4. Gone for the rest of the process.
///
/// The route pushed while the splash is up skips its own entrance
/// ([SplashHandoff.active], read by the page transitions).
///
/// Keep the native colours in pubspec.yaml equal to the theme's `surface`
/// (light and dark), and the native image equal to [logo].
class SplashHost extends StatefulWidget {
  const SplashHost({
    super.key,
    required this.routeChanges,
    required this.location,
    this.logo = const _DefaultSplashLogo(),
    required this.child,
  });

  /// Notifies when the router's location changes; [location] reads it.
  final Listenable routeChanges;
  final String Function() location;

  /// What frame 0 shows at the centre: the same image as the native splash.
  final Widget logo;
  final Widget child;

  @override
  State<SplashHost> createState() => _SplashHostState();
}

class _SplashHostState extends State<SplashHost>
    with SingleTickerProviderStateMixin {
  late final SplashHandoff _handoff = SplashHandoff._();
  late final AnimationController _exit = AnimationController(
    vsync: this,
    duration: Time.splashExit,
  );
  final Stopwatch _shown = Stopwatch();
  bool _done = false;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    widget.routeChanges.addListener(_onRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_handOff()));
    _exit.addStatusListener((status) {
      if (status.isCompleted) _finish();
    });
  }

  /// Frame 0 is on screen: drop the native splash, start the clock.
  Future<void> _handOff() async {
    await WidgetsBinding.instance.endOfFrame;
    FlutterNativeSplash.remove();
    _shown.start();
    _onRoute();
  }

  void _onRoute() {
    if (_leaving || !_shown.isRunning) return;
    if (widget.location() == RouteNames.splash) return;
    _leaving = true;
    final wait = Time.splashMinimum - _shown.elapsed;
    Future<void>.delayed(wait.isNegative ? Duration.zero : wait, () {
      if (!mounted) return;
      if (context.reduceMotion) {
        _exit.duration = Time.small;
      }
      unawaited(_exit.forward());
    });
  }

  void _finish() {
    widget.routeChanges.removeListener(_onRoute);
    _handoff._finish();
    setState(() => _done = true);
  }

  @override
  void dispose() {
    widget.routeChanges.removeListener(_onRoute);
    _exit.dispose();
    _handoff.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = context.reduceMotion;
    return _SplashHandoffScope(
      notifier: _handoff,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (!_done)
            AbsorbPointer(
              child: ExcludeSemantics(
                child: AnimatedBuilder(
                  animation: _exit,
                  builder: (context, logo) {
                    final t = Motion.emphasizedAccelerate.transform(
                      _exit.value,
                    );
                    return Opacity(
                      opacity: 1 - t,
                      child: ColoredBox(
                        color: context.colorScheme.surface,
                        child: Center(
                          child: Transform.scale(
                            scale: reduce ? 1 : 1 + 0.1 * t,
                            child: logo,
                          ),
                        ),
                      ),
                    );
                  },
                  child: widget.logo,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DefaultSplashLogo extends StatelessWidget {
  const _DefaultSplashLogo();

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/splash/splash_logo.png',
    width: Layout.splashLogoSize,
    height: Layout.splashLogoSize,
  );
}

/// What [SplashHost] shares with the screens under it.
class SplashHandoff extends ChangeNotifier {
  SplashHandoff._();

  bool _active = true;

  /// The splash is still drawn over the app. The route pushed meanwhile is
  /// the destination and skips its own entrance (it sits still underneath).
  bool get active => _active;

  void _finish() {
    _active = false;
    notifyListeners();
  }

  /// The handoff above [context], if any; [listen] rebuilds on changes.
  static SplashHandoff? maybeOf(BuildContext context, {bool listen = true}) =>
      listen
      ? context
            .dependOnInheritedWidgetOfExactType<_SplashHandoffScope>()
            ?.notifier
      : context.getInheritedWidgetOfExactType<_SplashHandoffScope>()?.notifier;
}

class _SplashHandoffScope extends InheritedNotifier<SplashHandoff> {
  const _SplashHandoffScope({required super.notifier, required super.child});
}
