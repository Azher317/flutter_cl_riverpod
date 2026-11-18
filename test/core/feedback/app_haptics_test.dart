import 'package:app/core/feedback/app_haptics.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/haptics.dart';

void main() {
  testWidgets('each meaning sends its own platform haptic', (tester) async {
    final sent = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        sent.add('${call.method} ${call.arguments}');
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
      AppHaptics.reset();
    });
    AppHaptics.reset();

    AppHaptics.selection();
    AppHaptics.light();
    AppHaptics.success();
    AppHaptics.error();
    await tester.pump();

    expect(sent, [
      'HapticFeedback.vibrate HapticFeedbackType.selectionClick',
      'HapticFeedback.vibrate HapticFeedbackType.lightImpact',
      'HapticFeedback.vibrate HapticFeedbackType.successNotification',
      'HapticFeedback.vibrate HapticFeedbackType.errorNotification',
    ]);
  });

  testWidgets('the same kind within the gap is dropped, then plays again', (
    tester,
  ) async {
    final log = recordHaptics(tester);

    AppHaptics.selection();
    AppHaptics.selection();
    await tester.pump(Time.hapticGap ~/ 2);
    AppHaptics.selection();
    expect(log, [HapticKind.selection]);

    await tester.pump(Time.hapticGap);
    AppHaptics.selection();
    expect(log, [HapticKind.selection, HapticKind.selection]);
  });

  testWidgets('different kinds never throttle each other', (tester) async {
    final log = recordHaptics(tester);

    AppHaptics.selection();
    AppHaptics.error();
    AppHaptics.light();

    expect(log, [HapticKind.selection, HapticKind.error, HapticKind.light]);
  });

  testWidgets('a failing platform call never reaches the caller', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => throw PlatformException(code: 'nope'),
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
      AppHaptics.reset();
    });
    AppHaptics.reset();

    AppHaptics.error();
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
