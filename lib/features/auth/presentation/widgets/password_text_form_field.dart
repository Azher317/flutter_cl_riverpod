import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.focusNode,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      hintText: widget.hint ?? context.l10n.typeYourPasswordHere,
      labelText: widget.label,
      obscureText: isObscure,
      validator: widget.validator,
      suffixIcon: IconButton(
        onPressed: () => setState(() => isObscure = !isObscure),
        icon: Icon(
          isObscure ? Icons.visibility_off : Icons.visibility,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
