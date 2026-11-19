import 'package:app/core/config/app_config.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/utils/formatters/ascii_digits_formatter.dart';
import 'package:app/core/utils/formatters/iraqi_phone.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Every phone field in the app (sign-in, profile, checkout…). Its shape
/// follows [AppConfig.phoneFormat]:
///
/// - [PhoneFormat.iraqi]: shows `07XX XXX XXXX` as you type (letters
///   dropped, Arabic-Indic digits made Latin, a pasted `+964…` made local)
///   and flags a wrong number only once it's complete or the field loses
///   focus, never mid-typing.
/// - [PhoneFormat.international]: a country-code picker (Iraq preselected)
///   and the local digits.
///
/// Send [PhoneFormField.valueOf] of the text, never the raw text. Inside a
/// `Form`, an empty or invalid number fails validation on submit.
class PhoneFormField extends HookWidget {
  const PhoneFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.errorText,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onCountryChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  /// The caller's own error (e.g. the server's 422). The local "not a valid
  /// number" one wins over it.
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  /// International format only: the picked dial code (`+964`).
  final ValueChanged<String>? onCountryChanged;

  /// The dial code an international field starts with.
  static const String initialDialCode = '+964';
  static const String _initialCountry = 'IQ';

  /// What to send for [text]: `07XXXXXXXXX` (Iraqi), or
  /// `<dialCode><digits>` (international).
  static String valueOf(
    String text, {
    String dialCode = initialDialCode,
  }) => switch (AppConfig.phoneFormat) {
    PhoneFormat.iraqi => IraqiPhone.normalize(text),
    PhoneFormat.international =>
      '$dialCode${AsciiDigitsFormatter.digitsOf(text).replaceFirst(RegExp('^0+'), '')}',
  };

  /// A complete, valid number.
  static bool isValidText(String text) => switch (AppConfig.phoneFormat) {
    PhoneFormat.iraqi => IraqiPhone.isValid(IraqiPhone.normalize(text)),
    // 6–14 local digits: E.164 allows 15 including the country code.
    PhoneFormat.international => RegExp(
      r'^\d{6,14}$',
    ).hasMatch(AsciiDigitsFormatter.digitsOf(text)),
  };

  /// [saved] (e.g. a stored `07…` or `+964…`) as the field shows it, to
  /// prefill a controller.
  static String initialText(String? saved) => saved == null
      ? ''
      : switch (AppConfig.phoneFormat) {
          PhoneFormat.iraqi => IraqiPhone.format(IraqiPhone.normalize(saved)),
          PhoneFormat.international => AsciiDigitsFormatter.digitsOf(saved),
        };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ownFocus = useFocusNode();
    final focus = focusNode ?? ownFocus;
    final focused = useListenable(focus).hasFocus;
    final text = useValueListenable(controller).text;
    const iraqi = AppConfig.phoneFormat == PhoneFormat.iraqi;

    // Mid-typing is never "wrong": only a complete number or a field the
    // user left.
    final digits = iraqi
        ? IraqiPhone.normalize(text)
        : AsciiDigitsFormatter.digitsOf(text);
    final complete = iraqi && digits.length == IraqiPhone.localLength;
    final wrong =
        digits.isNotEmpty && !isValidText(text) && (complete || !focused);

    return CustomTextFormField(
      controller: controller,
      focusNode: focus,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      // Digits read left to right, in Arabic too.
      textDirection: TextDirection.ltr,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: const [
        if (iraqi) IraqiPhoneInputFormatter() else AsciiDigitsFormatter(),
      ],
      errorText: wrong ? l10n.validatorPhoneNumber : errorText,
      validator: (value) => (value ?? '').trim().isEmpty
          ? l10n.validatorRequired
          : isValidText(value!)
          ? null
          : l10n.validatorPhoneNumber,
      onFieldSubmitted: onFieldSubmitted,
      hintText: iraqi ? '07XX XXX XXXX' : l10n.phone,
      prefixIcon: iraqi
          ? const Icon(Icons.phone_outlined)
          : CountryCodePicker(
              onChanged: (code) =>
                  onCountryChanged?.call(code.dialCode ?? initialDialCode),
              initialSelection: _initialCountry,
              showFlag: false,
              padding: EdgeInsets.zero,
              textStyle: context.textTheme.bodyMedium,
            ),
    );
  }
}
