import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
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
    this.borderRadius,
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
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      alignment: alignment ?? AlignmentDirectional.centerStart,
      value: value,
      items: items,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? BorderSize.small),
          borderSide: BorderSide(color: context.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? BorderSize.small),
          borderSide: BorderSide(color: context.colorScheme.outline),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? BorderSize.small),
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? BorderSize.small),
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: hintStyle ??
            context.textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
    );
  }
}
