import 'package:flutter/services.dart';

/// Iraqi mobile numbers in the local form people know and the backend
/// accepts: `07XXXXXXXXX` (11 digits), shown as `07XX XXX XXXX`.
abstract final class IraqiPhone {
  /// Digits in a complete number.
  static const int localLength = 11;

  /// The display groups (`0770 000 0000`) and what separates them.
  static const List<int> groups = [4, 3, 4];
  static const String groupSeparator = ' ';

  /// A complete Iraqi mobile number: `07[3-9]` + 8 digits.
  static final RegExp _valid = RegExp(r'^07[3-9][0-9]{8}$');

  /// The international forms a pasted number may arrive in, longest first.
  static const List<String> _internationalPrefixes = ['00964', '+964', '964'];

  static bool isValid(String digits) => _valid.hasMatch(digits);

  /// The one place a typed or pasted number becomes what the app sends:
  /// - Arabic-Indic digits (٠–٩, ۰–۹) become Latin ones first.
  /// - An international form (`+9647…`, `9647…`, `009647…`) becomes `07…`.
  /// - Then Latin digits only (spaces, `+`, anything else dropped).
  /// - A number typed without its leading `0` (`7…`) gets it.
  /// - Then at most [localLength] digits.
  static String normalize(String input) {
    var text = _latinDigits(input.trim());
    for (final prefix in _internationalPrefixes) {
      if (text.startsWith(prefix)) {
        text = '0${text.substring(prefix.length)}';
        break;
      }
    }
    var digits = text.replaceAll(RegExp('[^0-9]'), '');
    if (digits.startsWith('7')) digits = '0$digits';
    return digits.length > localLength
        ? digits.substring(0, localLength)
        : digits;
  }

  /// A number from the API (`+9647700000002`) as the boards print it
  /// (`0770 000 0002`); anything that isn't an Iraqi mobile stays as given.
  /// Wrapped in a left-to-right isolate (U+2066 … U+2069): in Arabic text
  /// the bidi algorithm would otherwise lay the space-separated groups out
  /// right to left (`0002 000 0770`).
  static String display(String raw) {
    final digits = normalize(raw);
    return isValid(digits) ? '\u2066${format(digits)}\u2069' : raw;
  }

  /// `07700000000` → `0770 000 0000` (also partial: `07700` → `0770 0`).
  static String format(String digits) {
    final out = StringBuffer();
    var start = 0;
    for (final size in groups) {
      if (start >= digits.length) break;
      final end = (start + size).clamp(0, digits.length);
      if (start > 0) out.write(groupSeparator);
      out.write(digits.substring(start, end));
      start = end;
    }
    return out.toString();
  }

  /// Where the caret goes in [format]'s output after [digitCount] digits.
  static int formattedOffset(int digitCount) {
    var offset = digitCount;
    var boundary = 0;
    for (final size in groups.take(groups.length - 1)) {
      boundary += size;
      if (digitCount > boundary) offset += groupSeparator.length;
    }
    return offset;
  }

  static String _latinDigits(String s) {
    final b = StringBuffer();
    for (final r in s.runes) {
      if (r >= 0x0660 && r <= 0x0669) {
        b.writeCharCode(r - 0x0660 + 0x30);
      } else if (r >= 0x06F0 && r <= 0x06F9) {
        b.writeCharCode(r - 0x06F0 + 0x30);
      } else {
        b.writeCharCode(r);
      }
    }
    return b.toString();
  }
}

/// Shows the number in its `07XX XXX XXXX` groups as it's typed, keeping the
/// caret on the same digit: after a typed digit, before a deleted one. A
/// paste goes through [IraqiPhone.normalize] (`+9647…` → `07…`). Backspace
/// right after a group space deletes the digit before it.
class IraqiPhoneInputFormatter extends TextInputFormatter {
  const IraqiPhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    var caret = newValue.selection.isValid
        ? newValue.selection.extentOffset
        : text.length;

    // Backspace on a group space: only the space went, so take the digit
    // before it instead (else the space would just come back).
    final oldDigits = IraqiPhone.normalize(oldValue.text);
    final removedOnlySpace =
        text.length == oldValue.text.length - 1 &&
        IraqiPhone.normalize(text) == oldDigits &&
        caret > 0;
    if (removedOnlySpace) {
      text = text.substring(0, caret - 1) + text.substring(caret);
      caret -= 1;
    }

    final digits = IraqiPhone.normalize(text);
    final digitsBeforeCaret = IraqiPhone.normalize(
      text.substring(0, caret.clamp(0, text.length)),
    ).length.clamp(0, digits.length);
    final formatted = IraqiPhone.format(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: IraqiPhone.formattedOffset(
          digitsBeforeCaret,
        ).clamp(0, formatted.length),
      ),
    );
  }
}
