import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  const CustomDropdownButtonFormField({
    super.key,
    required this.items,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.fillColor,
    this.value,
    required this.onChanged,
    this.hintStyle,
    this.alignment,
  });

  final String hintText;
  final TextStyle? hintStyle;
  final Widget? suffixIcon, prefixIcon;
  final Color? fillColor;
  final String? Function(T?)? validator;
  final ValueChanged<T?>? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      alignment: alignment ?? AlignmentDirectional.centerStart,
      value: value,
      items: items,
      decoration: InputDecoration(
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
    );
  }
}
