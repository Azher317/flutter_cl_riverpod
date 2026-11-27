import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Arabic length messages use the right plural form', () async {
    final ar = await AppLocalizations.delegate.load(const Locale('ar'));
    expect(ar.validatorMinLength(1), 'رجاءً أدخل حرفاً واحداً على الأقل');
    expect(ar.validatorMinLength(2), 'رجاءً أدخل حرفين على الأقل');
    expect(ar.validatorMinLength(6), 'رجاءً أدخل 6 أحرف على الأقل');
    expect(ar.validatorMinLength(11), 'رجاءً أدخل 11 حرفاً على الأقل');
    expect(ar.validatorMaxLength(100), 'رجاءً أدخل 100 حرف على الأكثر');
  });

  test('English length messages use the right plural form', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(
      en.validatorMinLength(1),
      'The field must be at least 1 character long',
    );
    expect(
      en.validatorMaxLength(6),
      'The field must be at most 6 characters long',
    );
  });
}
