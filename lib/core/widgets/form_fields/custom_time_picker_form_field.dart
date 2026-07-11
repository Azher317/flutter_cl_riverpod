import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/extensions/date_time_extensions.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTimePickerFormField extends StatelessWidget {
  const CustomTimePickerFormField({
    super.key,
    required this.selectedTimeNotifier,
    this.initialTime,
    required this.labelText,
  });

  final ValueNotifier<TimeOfDay?> selectedTimeNotifier;
  final TimeOfDay? initialTime;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedTimeNotifier,
        builder: (context, selectedTime, child) {
          return GestureDetector(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: initialTime ?? TimeOfDay.now(),
              );
              if (pickedTime != null) {
                selectedTimeNotifier.value = pickedTime;
              }
            },
            child: Container(
              width: context.width,
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Insets.medium),
                border: Border.all(
                  color: context.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Gap(Insets.medium),
                  Text(
                    selectedTime == null
                        ? labelText
                        : selectedTime.format24Hour(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(Icons.access_time,
                      color: context.colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          );
        });
  }
}
