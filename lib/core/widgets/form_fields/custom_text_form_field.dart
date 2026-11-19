import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The one text field. Every field in the app is this widget or is built on
/// it (phone, date, time, dropdown); `bin/check_arch.sh` blocks a raw
/// `TextFormField` in features. Missing an option? Add a parameter here.
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.fillColor,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType,
    this.labelText,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.onSaved,
    this.inputFormatters,
    this.enabledBorder,
    this.focusedBorder,
    this.contentPadding,
    this.textDirection,
    this.autofillHints,
    this.errorText,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final Widget? suffixIcon, prefixIcon;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final ValueChanged<String?>? onChanged;
  final int? maxLines, maxLength;
  final int? minLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final EdgeInsets? contentPadding;

  /// Force a direction for content that always reads left to right (phone
  /// numbers, prices). The text still sits on the layout's start side.
  final TextDirection? textDirection;
  final Iterable<String>? autofillHints;

  /// Shown instead of the validator's message while non-null.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        fillColor: fillColor,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      validator: validator,
      forceErrorText: errorText,
      autofillHints: autofillHints,
      textDirection: textDirection,
      // The layout's start as a fixed side: `TextAlign.start` would follow
      // [textDirection], so a forced-LTR phone would sit at the far left in
      // Arabic while every other field sits on the right.
      textAlign: Directionality.of(context) == TextDirection.rtl
          ? TextAlign.right
          : TextAlign.left,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      maxLength: maxLength,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      onTap: onTap,
      readOnly: readOnly,
      focusNode: focusNode,
      textInputAction: textInputAction,
    );
  }
}
