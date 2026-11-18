import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_reveal.g.dart';

/// `true` while a circular reveal runs. The app then switches the theme with
/// no blend (`ThemeX.changeAnimation`), so the circle uncovers the final
/// colours, never a half-blended mix.
@Riverpod(keepAlive: true)
class ThemeRevealActive extends _$ThemeRevealActive {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

extension ThemeRevealX on BuildContext {
  /// Changes the theme to [mode] by running [apply] — revealed in a circle
  /// growing from [origin] (global; the screen centre when `null`) when a
  /// [ThemeRevealHost] is above and the screen's brightness actually
  /// changes. Otherwise [apply] just runs (reduced motion: instant).
  ///
  /// Completes once the circle has covered the screen. Keep whatever is on
  /// screen still until then (e.g. close the sheet that asked only
  /// afterwards): the reveal uncovers the live app in the new theme against a
  /// screenshot of it in the old one, so anything moving underneath would
  /// show as a seam.
  Future<void> revealThemeChange(
    ThemeMode mode, {
    Offset? origin,
    required FutureOr<void> Function() apply,
  }) {
    final host = findAncestorStateOfType<ThemeRevealHostState>();
    if (host == null) return Future.sync(apply);
    final target = switch (mode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(this),
    };
    return host.reveal(
      origin: origin,
      apply: apply,
      changes: target != Theme.of(this).brightness,
    );
  }

  /// Changes the language to [locale] by running [apply], with exactly the
  /// same circular reveal as [revealThemeChange]. The screenshot of the old
  /// frame covers the RTL ⇄ LTR flip: the circle uncovers the screen already
  /// laid out in the new direction.
  Future<void> revealLocaleChange(
    Locale locale, {
    Offset? origin,
    required FutureOr<void> Function() apply,
  }) {
    final host = findAncestorStateOfType<ThemeRevealHostState>();
    if (host == null) return Future.sync(apply);
    return host.reveal(
      origin: origin,
      apply: apply,
      changes: locale.languageCode != Localizations.localeOf(this).languageCode,
    );
  }
}

/// Sits in `MaterialApp.builder`, around the whole app (routes, sheets,
/// dialogs). For a reveal it captures the current frame, lays it over the
/// app, applies the change underneath, then cuts a growing circular hole in
/// the old frame ([Time.reveal], [Motion.standard]) until the new look fills
/// the screen. Taps are blocked for the whole reveal, and the status bar
/// keeps the old style until the circle reaches the top of the screen.
///
/// The app itself stays the Stack's first child the whole time, so nothing
/// under it is rebuilt or loses state (Home, router, session).
class ThemeRevealHost extends ConsumerStatefulWidget {
  const ThemeRevealHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ThemeRevealHost> createState() => ThemeRevealHostState();
}

class ThemeRevealHostState extends ConsumerState<ThemeRevealHost>
    with SingleTickerProviderStateMixin {
  final _boundary = GlobalKey();
  late final AnimationController _controller;
  late final CurvedAnimation _progress;

  /// A reveal is running (from the tap until the circle is done).
  bool _busy = false;
  ui.Image? _oldFrame;
  Offset _origin = Offset.zero;

  /// The status bar style from before the change, held until the circle
  /// reaches the top edge — at [_topAt] of its progress.
  SystemUiOverlayStyle? _oldStatusBar;
  double _topAt = 0;

  @override
  void initState() {
    super.initState();
    // Created here, not lazily: a lazy one would first be built in dispose()
    // when no reveal ever ran, on an already-deactivated element.
    _controller = AnimationController(vsync: this, duration: Time.reveal);
    // A gentle start, then faster, then settling. (A decelerating curve
    // swallowed most of the screen in two frames — a flash.)
    _progress = CurvedAnimation(parent: _controller, curve: Motion.standard);
  }

  /// The circle's progress (0 → 1, curved): its radius over the full reach.
  @visibleForTesting
  Animation<double> get progress => _progress;

  @override
  void dispose() {
    _oldFrame?.dispose();
    _progress.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Runs [apply] under a circular reveal from [origin]. [changes] says
  /// whether anything visible changes; when it doesn't, or with reduced
  /// motion, or while another reveal runs, [apply] just runs.
  Future<void> reveal({
    Offset? origin,
    required FutureOr<void> Function() apply,
    required bool changes,
  }) async {
    if (context.reduceMotion || !changes || _busy) {
      await apply();
      return;
    }

    // From here on no tap or drag reaches the app (no second reveal, no
    // dragging a sheet away under the screenshot).
    setState(() => _busy = true);
    ui.Image? image;
    try {
      // The frame on screen now. Wait out a frame first so the boundary's
      // layer is painted (the tap's ripple may have just dirtied it).
      await SchedulerBinding.instance.endOfFrame;
      final boundary =
          _boundary.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (!mounted || boundary == null) {
        await apply();
        return;
      }
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      try {
        image = await boundary.toImage(pixelRatio: pixelRatio);
      } on Object {
        await apply();
        return;
      }
      if (!mounted) {
        await apply();
        return;
      }

      // Old frame on top first (painted before anything changes: no
      // flash), then the change happens underneath with no blend.
      final box = context.findRenderObject()! as RenderBox;
      final start = box.globalToLocal(origin ?? box.size.center(Offset.zero));
      // The status bar is drawn by the OS over everything — the screenshot
      // can't cover it. Hold its old style until the circle reaches the top
      // edge at the tap's x.
      final oldStatusBar = Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark;
      setState(() {
        // The circle restarts from nothing *before* the screenshot shows:
        // left at 1 by the previous reveal, its hole would cover the whole
        // screenshot.
        _controller.value = 0;
        _oldFrame = image;
        _origin = start;
        _oldStatusBar = oldStatusBar;
        _topAt = start.dy / _reach(box.size, start);
      });
      await SchedulerBinding.instance.endOfFrame;
      ref.read(themeRevealActiveProvider.notifier).set(true);
      await apply();
      // The new look built and painted under the old frame.
      await SchedulerBinding.instance.endOfFrame;
      // Grow the hole.
      if (mounted) await _controller.forward(from: 0);
    } finally {
      if (mounted) {
        setState(() {
          _oldFrame = null;
          _oldStatusBar = null;
          _busy = false;
        });
        ref.read(themeRevealActiveProvider.notifier).set(false);
      }
      // Free the GPU copy of the old frame.
      image?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final oldFrame = _oldFrame;
    final oldStatusBar = _oldStatusBar;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        RepaintBoundary(key: _boundary, child: widget.child),
        if (oldFrame != null)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _RevealPainter(
                    image: oldFrame,
                    origin: _origin,
                    progress: _progress,
                  ),
                ),
              ),
            ),
          ),
        // On top of everything, over the status bar strip only: the style
        // Flutter hands the OS each frame comes from the top-most region
        // there, so this one wins — until the circle reaches the top.
        if (oldFrame != null && oldStatusBar != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.paddingOf(context).top,
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, _) => _progress.value < _topAt
                  ? AnnotatedRegion<SystemUiOverlayStyle>(
                      value: oldStatusBar,
                      child: const SizedBox.expand(),
                    )
                  : const SizedBox.expand(),
            ),
          ),
        if (_busy) const Positioned.fill(child: AbsorbPointer()),
      ],
    );
  }
}

/// The distance from [origin] to the farthest corner of [size]: the circle's
/// full radius.
double _reach(Size size, Offset origin) => [
  Offset.zero,
  Offset(size.width, 0),
  Offset(0, size.height),
  Offset(size.width, size.height),
].map((corner) => (corner - origin).distance).reduce(math.max);

/// The old frame with a circular hole of radius `progress` × the distance
/// from [origin] to the farthest corner (so at 1 the hole covers everything).
/// Works the same in RTL: everything is in screen coordinates.
class _RevealPainter extends CustomPainter {
  _RevealPainter({
    required this.image,
    required this.origin,
    required this.progress,
  }) : super(repaint: progress);

  final ui.Image image;
  final Offset origin;
  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final reach = _reach(size, origin);
    final screen = Offset.zero & size;
    final outsideHole = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(screen)
      ..addOval(
        Rect.fromCircle(center: origin, radius: reach * progress.value),
      );
    canvas
      ..save()
      ..clipPath(outsideHole)
      ..drawImageRect(
        image,
        Offset.zero & Size(image.width.toDouble(), image.height.toDouble()),
        screen,
        Paint()..filterQuality = FilterQuality.low,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_RevealPainter old) =>
      old.image != image || old.origin != origin;
}
