import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/widgets/custom_modal_bottom_sheet.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:app/core/widgets/paginated_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomPaginatedDropdownFormField<T> extends HookConsumerWidget {
  const CustomPaginatedDropdownFormField({
    super.key,
    required this.pagingController,
    required this.hintText,
    required this.valueNotifier,
    this.labelText,
    this.onSelect,
    this.onSearch,
    this.searchController,
    this.prefixIcon,
    this.validator,
    this.subtitleBuilder,
    this.leadingBuilder,
    this.customItems, // Add this new parameter
    this.onFieldSubmitted,
  });
  final PagingController<int, dynamic> pagingController;
  final String hintText;
  final String? labelText;
  final ValueNotifier valueNotifier;
  final void Function(T?)? onSelect;
  final void Function(String?)? onSearch;
  final TextEditingController? searchController;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget Function(T)? subtitleBuilder, leadingBuilder;
  final List<Widget>? customItems; // Add this line
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider).localeCode ?? 'en';

    final textEditingController =
        useTextEditingController(text: valueNotifier.value?.name);
    valueNotifier.addListener(() {
      textEditingController.text = valueNotifier.value?.name ?? '';
    });
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, value, child) {
          return CustomTextFormField(
            fillColor: Colors.transparent,
            prefixIcon: prefixIcon,
            controller: textEditingController,
            hintText: hintText,
            labelText: labelText,
            suffixIcon: value == null
                ? Icon(Icons.keyboard_arrow_down_outlined)
                : IconButton(
                    onPressed: () {
                      textEditingController.clear();
                      valueNotifier.value = null;
                      if (onSelect != null) {
                        onSelect!(null);
                      }
                    },
                    icon: Icon(Icons.close)),
            validator: validator,
            onTap: () async {
              await customModalBottomSheet(
                context,
                child: PaginatedBottomSheet<T>(
                  titleText: "${context.l10n.select} ${labelText ?? hintText}",
                  pagingController: pagingController,
                  searchController: searchController,
                  onSearch: onSearch,
                  customItems: customItems,
                  onFieldSubmitted: onFieldSubmitted,
                  onSelect: (value) {
                    final dynamicValue = value as dynamic;
                    valueNotifier.value = value;

                    textEditingController.text = dynamicValue.name ??
                        (settings == 'en'
                            ? dynamicValue.nameEn
                            : dynamicValue.nameAr);

                    if (onSelect != null) {
                      onSelect!(value);
                    }
                    GoRouter.of(context).pop();
                  },
                  subtitleBuilder: subtitleBuilder,
                  leadingBuilder: leadingBuilder,
                ),
              );
            },
            readOnly: true,
          );
        });
  }
}
