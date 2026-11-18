import 'package:flutter/services.dart';

/// Keeps digits only; Arabic-Indic (٠–٩) and Eastern Arabic-Indic (۰–۹)
/// become ASCII, so an Arabic keyboard types numbers the API understands.
class AsciiDigitsFormatter extends TextInputFormatter {
  const AsciiDigitsFormatter();

  /// [text]'s digits, in ASCII.
  static String digitsOf(String text) {
    final buffer = StringBuffer();
    for (final r in text.runes) {
      if (r >= 0x30 && r <= 0x39) {
        buffer.writeCharCode(r);
      } else if (r >= 0x0660 && r <= 0x0669) {
        buffer.writeCharCode(r - 0x0660 + 0x30);
      } else if (r >= 0x06F0 && r <= 0x06F9) {
        buffer.writeCharCode(r - 0x06F0 + 0x30);
      }
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = digitsOf(newValue.text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
