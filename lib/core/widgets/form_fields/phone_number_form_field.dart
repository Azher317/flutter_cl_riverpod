import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/l10n/locale.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class PhoneNumberFormField extends StatelessWidget {
  const PhoneNumberFormField(
      {super.key,
      this.focusNode,
      this.onFieldSubmitted,
      required this.controller,
      required this.onChanged,
      required this.onCountryCodeChanged,
      this.validator});

  final ValueChanged<String?> onChanged;
  final TextEditingController controller;
  final ValueChanged<CountryCode> onCountryCodeChanged;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: "رقم الهاتف",
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      prefixIcon: CountryCodePicker(
        textStyle: context.textTheme.bodyMedium?.copyWith(),
        onChanged: onCountryCodeChanged,
        initialSelection: "IQ",
        padding: EdgeInsets.zero,
        showFlag: false,
      ),
      validator: validator ??
          ValidationBuilder(
            optional: true,
            locale: AppFormValidatorLocale(context),
          ).phone().build(),
    );
  }
}
