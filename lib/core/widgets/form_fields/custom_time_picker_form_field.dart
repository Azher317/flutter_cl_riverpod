import 'package:app/core/extensions/date_time_extensions.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomTimePickerFormField extends HookConsumerWidget {
  const CustomTimePickerFormField({
    super.key,
    required this.selectedTimeNotifier,
    this.initialTime,
    this.validator,
    required this.labelText,
  });

  final ValueNotifier<TimeOfDay?> selectedTimeNotifier;
  final TimeOfDay? initialTime;
  final String? Function(String?)? validator;
  final String labelText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController(
      text: selectedTimeNotifier.value?.format24Hour(),
    );
    selectedTimeNotifier.addListener(() {
      textEditingController.text =
          selectedTimeNotifier.value?.format24Hour() ?? '';
    });

    return ValueListenableBuilder(
      valueListenable: selectedTimeNotifier,
      builder: (context, selectedTime, child) {
        return CustomTextFormField(
          controller: textEditingController,
          hintText: labelText,
          fillColor: Colors.transparent,
          suffixIcon: Icon(
            Icons.access_time,
            color: context.colorScheme.onSurfaceVariant,
          ),
          onTap: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? initialTime ?? TimeOfDay.now(),
            );
            if (pickedTime != null) {
              selectedTimeNotifier.value = pickedTime;
            }
          },
          validator: validator,
          readOnly: true,
        );
      },
    );
  }
}
