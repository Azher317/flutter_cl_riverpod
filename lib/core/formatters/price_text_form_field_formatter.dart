import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PriceTextFormFeildFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String unformatted = newValue.text.replaceAll(',', '');

    if (unformatted.isEmpty) return newValue;

    final number = int.tryParse(unformatted);
    if (number == null) return oldValue;

    final newText = _formatter.format(number);
    final selectionIndex = newText.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
