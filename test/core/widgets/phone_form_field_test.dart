import 'package:app/core/config/app_config.dart';
import 'package:app/core/widgets/form_fields/phone_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('value sent', () {
    test('Iraqi format: any typed or pasted form becomes 07…', () {
      if (AppConfig.phoneFormat != PhoneFormat.iraqi) return;
      expect(PhoneFormField.valueOf('0770 123 4567'), '07701234567');
      expect(PhoneFormField.valueOf('+964 770 123 4567'), '07701234567');
      expect(PhoneFormField.valueOf('٠٧٧٠١٢٣٤٥٦٧'), '07701234567');
      expect(PhoneFormField.isValidText('0770 123 4567'), isTrue);
      expect(PhoneFormField.isValidText('0710 123 4567'), isFalse);
    });

    test('international format: dial code + digits without leading 0', () {
      if (AppConfig.phoneFormat != PhoneFormat.international) return;
      expect(
        PhoneFormField.valueOf('0501234567', dialCode: '+966'),
        '+966501234567',
      );
    });
  });

  testWidgets('Iraqi format: groups the digits as they are typed', (
    tester,
  ) async {
    if (AppConfig.phoneFormat != PhoneFormat.iraqi) return;
    final controller = TextEditingController();
    await pumpApp(tester, PhoneFormField(controller: controller));
    await tester.enterText(find.byType(TextField), '07701234567');
    expect(controller.text, '0770 123 4567');
  });

  testWidgets('an incomplete number is not flagged while typing', (
    tester,
  ) async {
    if (AppConfig.phoneFormat != PhoneFormat.iraqi) return;
    final controller = TextEditingController();
    await pumpApp(tester, PhoneFormField(controller: controller));
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), '0770');
    await tester.pump();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.errorText, isNull);
  });
}
