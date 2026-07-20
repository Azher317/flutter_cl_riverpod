import 'package:app/core/l10n/localized_name.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:app/core/widgets/overlay/custom_modal_bottom_sheet.dart';
import 'package:app/core/widgets/overlay/paginated_bottom_sheet.dart';
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
    this.prefixIcon,
    this.validator,
    this.labelBuilder,
    this.subtitleBuilder,
    this.leadingBuilder,
    this.customItems,
    this.onFieldSubmitted,
  });
  final PagingController<int, T> pagingController;
  final String hintText;
  final String? labelText;
  final ValueNotifier<T?> valueNotifier;
  final void Function(T?)? onSelect;
  final void Function(String)? onSearch;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

  /// Type-safe display label. Falls back to [localizedName] when omitted.
  final String Function(T)? labelBuilder;
  final Widget Function(T)? subtitleBuilder, leadingBuilder;
  final List<Widget>? customItems;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider).localeCode ?? 'en';

    String labelOf(T item) =>
        labelBuilder?.call(item) ?? localizedName(item, settings);

    final value = useValueListenable(valueNotifier);
    final textEditingController = useTextEditingController();

    // Keep the field text in sync with the selection. Hook-managed, so the
    // listener is disposed automatically — no manual addListener leak.
    useEffect(() {
      textEditingController.text = value == null ? '' : labelOf(value);
      return null;
    }, [value]);

    return CustomTextFormField(
      fillColor: Colors.transparent,
      prefixIcon: prefixIcon,
      controller: textEditingController,
      hintText: hintText,
      labelText: labelText,
      suffixIcon: value == null
          ? const Icon(Icons.keyboard_arrow_down_outlined)
          : IconButton(
              onPressed: () {
                valueNotifier.value = null;
                onSelect?.call(null);
              },
              icon: const Icon(Icons.close),
            ),
      validator: validator,
      onTap: () async {
        await customModalBottomSheet(
          context,
          child: PaginatedBottomSheet<T>(
            titleText: '${context.l10n.select} ${labelText ?? hintText}',
            pagingController: pagingController,
            onSearch: onSearch,
            customItems: customItems,
            onFieldSubmitted: onFieldSubmitted,
            labelBuilder: labelBuilder,
            onSelect: (selected) {
              valueNotifier.value = selected;
              onSelect?.call(selected);
              GoRouter.of(context).pop();
            },
            subtitleBuilder: subtitleBuilder,
            leadingBuilder: leadingBuilder,
          ),
        );
      },
      readOnly: true,
    );
  }
}
