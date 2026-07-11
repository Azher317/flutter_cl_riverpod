import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/pagination/paging_list_delegate.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:app/core/widgets/break_line.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:app/core/widgets/svg_prefix_icon.dart';
import 'package:app/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginatedBottomSheet<T> extends HookConsumerWidget {
  const PaginatedBottomSheet({
    super.key,
    required this.pagingController,
    required this.onSelect,
    required this.titleText,
    this.onSearch,
    this.searchController,
    this.subtitleBuilder,
    this.leadingBuilder,
    this.onFieldSubmitted,
    this.customItems,
  });
  final PagingController<int, dynamic> pagingController;
  final void Function(T) onSelect;
  final String titleText;
  final void Function(String?)? onSearch;
  final TextEditingController? searchController;
  final Widget Function(T)? subtitleBuilder, leadingBuilder;
  final List<Widget>? customItems;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider).localeCode ?? 'en';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(BorderSize.medium),
          topRight: Radius.circular(BorderSize.medium),
        ),
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(Insets.medium),
              BreakLine(),
              const Gap(Insets.medium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.medium),
                child: Text(
                  titleText,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              const Gap(Insets.medium),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colorScheme.outline,
                      width: 0.5,
                    ),
                    color: context.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(BorderSize.medium),
                      topRight: Radius.circular(BorderSize.medium),
                    ),
                  ),
                  padding: Insets.mediumAll,
                  child: Column(spacing: Insets.medium, children: [
                    CustomTextFormField(
                      prefixIcon:
                          SvgPrefixIcon(svg: Assets.svg.search01.keyName),
                      controller: searchController,
                      hintText: context.l10n.search,
                      onChanged: onSearch,
                      onFieldSubmitted: onFieldSubmitted,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Future.sync(() => pagingController.refresh());
                        },
                        child: Column(
                          children: [
                            // Add custom items if provided
                            if (customItems != null) ...customItems!,
                            if (customItems != null)
                              const Divider(thickness: 0.5),
                            // Then show the regular list
                            Expanded(
                              child: PagedListView.separated(
                                pagingController: pagingController,
                                builderDelegate:
                                    defaultListPagedChildBuilderDelegate(
                                  context: context,
                                  controller: pagingController,
                                  itemBuilder: (context, item, index) {
                                    final displayName = item.name ??
                                        (settings == 'en'
                                            ? (item.nameEn ?? item.name)
                                            : (item.nameAr ?? item.name));
                                    return ListTile(
                                      title: Text(displayName),
                                      subtitle:
                                          subtitleBuilder?.call(item as T),
                                      leading: leadingBuilder?.call(item as T),
                                      onTap: () => onSelect(item as T),
                                    );
                                  },
                                ),
                                separatorBuilder: (context, index) {
                                  return const Divider(thickness: 0.5);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
