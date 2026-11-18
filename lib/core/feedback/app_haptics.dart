import 'dart:async';

import 'package:app/core/utils/constants/sizes.dart';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// What a haptic means. Each kind always means the same thing, everywhere.
/// When to use which (and when not to vibrate at all): docs/guides/haptics.md.
enum HapticKind {
  /// A choice changed: tab, switch, segmented control, radio, stepper step,
  /// theme / language picked.
  selection,

  /// Something was added or saved: favourite, add to cart, item saved.
  light,

  /// An important success that ends a flow: order placed, signed in,
  /// payment done.
  success,

  /// The user's own input was rejected: wrong OTP, a limit reached,
  /// a form submitted with errors.
  error,
}

/// The app's only way to play a haptic; widgets never call
/// [HapticFeedback] directly. Every haptic comes with something visible,
/// and plain buttons don't vibrate (their pressed state is the feedback).
///
/// - success / error are iOS's notification patterns; on Android 11+ they
///   map to `CONFIRM` / `REJECT`, and play nothing on older Android.
/// - The phone's own setting (System Haptics / Touch feedback) decides
///   whether they play. There's no in-app switch, and reduce motion doesn't
///   turn them off.
/// - The same kind within [Time.hapticGap] is dropped, so fast taps don't
///   stack. Fire-and-forget: never throws, never blocks.
abstract final class AppHaptics {
  static final Map<HapticKind, DateTime> _last = {};

  static void selection() => _play(HapticKind.selection);
  static void light() => _play(HapticKind.light);
  static void success() => _play(HapticKind.success);
  static void error() => _play(HapticKind.error);

  /// Forgets the throttle (between tests).
  @visibleForTesting
  static void reset() => _last.clear();

  static void _play(HapticKind kind) {
    final now = clock.now();
    final last = _last[kind];
    if (last != null && now.difference(last) < Time.hapticGap) return;
    _last[kind] = now;
    final Future<void> Function() call = switch (kind) {
      HapticKind.selection => HapticFeedback.selectionClick,
      HapticKind.light => HapticFeedback.lightImpact,
      HapticKind.success => HapticFeedback.successNotification,
      HapticKind.error => HapticFeedback.errorNotification,
    };
    try {
      unawaited(call().catchError((Object _) {}));
    } on Object {
      // A haptic is never worth a crash.
    }
  }
}
