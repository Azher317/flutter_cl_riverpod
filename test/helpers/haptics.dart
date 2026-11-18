import 'package:app/core/feedback/app_haptics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// The haptics a test requested, in order.
typedef HapticLog = List<HapticKind>;

const _types = {
  'HapticFeedbackType.selectionClick': HapticKind.selection,
  'HapticFeedbackType.lightImpact': HapticKind.light,
  'HapticFeedbackType.successNotification': HapticKind.success,
  'HapticFeedbackType.errorNotification': HapticKind.error,
};

/// Records every haptic sent on the platform channel (anything else,
/// e.g. `vibrate()` or `mediumImpact`, fails the test), and clears the
/// [AppHaptics] throttle before and after.
HapticLog recordHaptics(WidgetTester tester) {
  final log = <HapticKind>[];
  AppHaptics.reset();
  final messenger = tester.binding.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'HapticFeedback.vibrate') {
      final kind = _types[call.arguments];
      if (kind == null) fail('Unexpected haptic: ${call.arguments}');
      log.add(kind);
    }
    return null;
  });
  addTearDown(() {
    messenger.setMockMethodCallHandler(SystemChannels.platform, null);
    AppHaptics.reset();
  });
  return log;
}
