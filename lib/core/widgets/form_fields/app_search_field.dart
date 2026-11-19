import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';

/// The app's search box, built on [CustomTextFormField]: a pill that keeps
/// its shape when focused (only the border colour changes), closes the
/// keyboard on a tap elsewhere, and shows a clear button while it has text.
///
/// Pair it with `useDebouncedSearch()` and pass its `controller`.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderSize.fullRadius,
          borderSide: BorderSide(color: color, width: width),
        );
    final scheme = context.colorScheme;
    return CustomTextFormField(
      controller: controller,
      hintText: hint,
      onChanged: (v) => onChanged?.call(v ?? ''),
      onFieldSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => AnimatedSwitcher(
          duration: context.reduceMotion ? Duration.zero : Time.enter,
          child: value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: context.l10n.clearSearch,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                ),
        ),
      ),
      enabledBorder: border(scheme.outlineVariant),
      focusedBorder: border(scheme.primary, 1.5),
    );
  }
}
