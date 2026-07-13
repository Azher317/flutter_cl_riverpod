import 'package:flutter/services.dart';

/// Local Iraqi mobile number, without country code: `7XXXXXXXXX` (10 digits).
/// The country code is captured separately by the `CountryCodePicker`.
final RegExp iraqiPhoneNumberRegex = RegExp(r'^7[3-9][0-9]{8}$');

final englishLettersOnly = FilteringTextInputFormatter.allow(
  RegExp("[a-zA-Z]"),
);

/// Latin (ASCII) digits 0-9 only. Blocks Arabic-Indic (٠–٩) and other numerals.
final englishDigitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

final asciiOnly = FilteringTextInputFormatter.allow(RegExp("[ -~]"));
