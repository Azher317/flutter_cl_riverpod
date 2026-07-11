import 'package:app/core/extensions/date_time_extensions.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:app/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDatePickerFormField extends HookConsumerWidget {
  const CustomDatePickerFormField({
    super.key,
    required this.selectedDateNotifier,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.labelText = 'YYYY/MM/DD',
  });

  final ValueNotifier<DateTime?> selectedDateNotifier;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate, lastDate;
  final String labelText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController(
        text: selectedDateNotifier.value?.formatDate());
    selectedDateNotifier.addListener(() {
      textEditingController.text =
          selectedDateNotifier.value?.formatDate() ?? '';
    });
    return ValueListenableBuilder(
        valueListenable: selectedDateNotifier,
        builder: (context, selectedDate, child) {
          return CustomTextFormField(
            controller: textEditingController,
            hintText: labelText,
            fillColor: Colors.transparent,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(Assets.svg.calender.path,
                  height: Insets.small,
                  width: Insets.small,
                  colorFilter: ColorFilter.mode(
                      context.colorScheme.outline, BlendMode.srcIn)),
            ),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: firstDate ??
                    DateTime(DateTime.now().year - 10, DateTime.now().month,
                        DateTime.now().day),
                lastDate: DateTime(DateTime.now().year + 10,
                    DateTime.now().month, DateTime.now().day),
              );
              if (pickedDate != null) {
                selectedDateNotifier.value = pickedDate;
              }
            },
            validator: validator,
            readOnly: true,
          );
        });
  }
}
