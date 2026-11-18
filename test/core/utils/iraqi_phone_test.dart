import 'package:app/core/utils/formatters/iraqi_phone.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IraqiPhone.normalize (Basmah rules)', () {
    for (final (input, out) in [
      ('0770 000 0001', '07700000001'),
      ('+9647700000001', '07700000001'),
      ('009647700000001', '07700000001'),
      ('9647700000001', '07700000001'),
      ('7700000001', '07700000001'),
      ('٠٧٧٠٠٠٠٠٠٠١', '07700000001'),
      ('077000000011234', '07700000001'),
    ]) {
      test('$input → $out', () => expect(IraqiPhone.normalize(input), out));
    }
  });

  test('valid: 07[3-9] + 8 digits only', () {
    expect(IraqiPhone.isValid('07700000001'), isTrue);
    expect(IraqiPhone.isValid('07812345678'), isTrue);
    expect(IraqiPhone.isValid('07123456789'), isFalse);
    expect(IraqiPhone.isValid('0770000000'), isFalse);
  });

  test('format groups 4 · 3 · 4, partial too', () {
    expect(IraqiPhone.format('07700000001'), '0770 000 0001');
    expect(IraqiPhone.format('07700'), '0770 0');
  });

  test('backspace on a group space deletes the digit before it', () {
    const f = IraqiPhoneInputFormatter();
    final v = f.formatEditUpdate(
      const TextEditingValue(
        text: '0770 0',
        selection: TextSelection.collapsed(offset: 5),
      ),
      const TextEditingValue(
        text: '07700',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );
    expect(v.text, '0770');
  });

  test('display: API numbers in the local form, kept left-to-right', () {
    expect(IraqiPhone.display('+9647700000002'), '\u20660770 000 0002\u2069');
    expect(IraqiPhone.display('07700000002'), '\u20660770 000 0002\u2069');
    // Not an Iraqi mobile: shown as given.
    expect(IraqiPhone.display('+1 555 0100'), '+1 555 0100');
  });
}
