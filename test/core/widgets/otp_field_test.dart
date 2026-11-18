import 'package:app/core/feedback/app_haptics.dart';
import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/widgets/form_fields/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/haptics.dart';
import '../../helpers/pump_app.dart';

Future<TextEditingController> _pump(WidgetTester tester, bool hasError) async {
  final code = TextEditingController(text: '128934');
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OtpField(controller: code, hasError: hasError),
      ),
    ),
  );
  await tester.pump();
  return code;
}

void main() {
  testWidgets('a rejected code: the next digit starts over with it', (
    tester,
  ) async {
    final code = await _pump(tester, true);
    await tester.enterText(find.byType(TextField), '1289347');
    expect(code.text, '7');
  });

  testWidgets('a rejected code: backspace empties it', (tester) async {
    final code = await _pump(tester, true);
    await tester.enterText(find.byType(TextField), '12893');
    expect(code.text, '');
  });

  testWidgets('a rejected code: a new code pasted over it is kept', (
    tester,
  ) async {
    final code = await _pump(tester, true);
    await tester.enterText(find.byType(TextField), '123456');
    expect(code.text, '123456');
  });

  group('haptics', () {
    Future<void> pumpTrigger(WidgetTester tester, int trigger) => pumpApp(
      tester,
      OtpField(
        controller: TextEditingController(),
        hasError: trigger > 0,
        errorTrigger: trigger,
      ),
      // The shake is skipped under reduced motion; the haptic isn't.
      disableAnimations: true,
    );

    testWidgets('each new wrong code plays error once', (tester) async {
      final haptics = recordHaptics(tester);
      await pumpTrigger(tester, 0);
      expect(haptics, isEmpty);

      await pumpTrigger(tester, 1);
      expect(haptics, [HapticKind.error]);

      // A rebuild with the same count is not a new error.
      await pumpTrigger(tester, 1);
      expect(haptics, [HapticKind.error]);

      await tester.pump(Time.hapticGap);
      await pumpTrigger(tester, 2);
      expect(haptics, [HapticKind.error, HapticKind.error]);
    });
  });

  testWidgets('no error: editing works as usual', (tester) async {
    final code = await _pump(tester, false);
    await tester.enterText(find.byType(TextField), '12893');
    expect(code.text, '12893');
  });
}
