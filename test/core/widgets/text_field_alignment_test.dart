import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:app/core/widgets/form_fields/phone_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

TextAlign _alignOf(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).textAlign;

void main() {
  testWidgets('Arabic: a forced-LTR phone field sits on the right like the '
      'others', (tester) async {
    await pumpApp(
      tester,
      Directionality(
        textDirection: TextDirection.rtl,
        child: PhoneFormField(controller: TextEditingController()),
      ),
    );
    expect(_alignOf(tester), TextAlign.right);
  });

  testWidgets('left-to-right layout: text sits on the left', (tester) async {
    await pumpApp(
      tester,
      Directionality(
        textDirection: TextDirection.ltr,
        child: CustomTextFormField(
          controller: TextEditingController(),
          hintText: 'x',
        ),
      ),
    );
    expect(_alignOf(tester), TextAlign.left);
  });
}
