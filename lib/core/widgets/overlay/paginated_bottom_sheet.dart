import 'package:app/core/constants/sizes.dart';
import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/hooks/use_debounced_search.dart';
import 'package:app/core/l10n/localized_name.dart';
import 'package:app/core/pagination/paging_list_delegate.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/widgets/break_line.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:app/core/widgets/svg_prefix_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginatedBottomSheet<T> extends HookConsumerWidget {
  const PaginatedBottomSheet({
    super.key,
    required this.pagingController,
    required this.onSelect,
    required this.titleText,
    this.onSearch,
    this.labelBuilder,
    this.subtitleBuilder,
    this.leadingBuilder,
    this.onFieldSubmitted,
    this.customItems,
  });
  final PagingController<int, T> pagingController;
  final void Function(T) onSelect;
  final String titleText;

  /// Notified with the debounced search query whenever it settles.
  final void Function(String)? onSearch;

  /// Type-safe row label. Falls back to [localizedName] when omitted.
  final String Function(T)? labelBuilder;
  final Widget Function(T)? subtitleBuilder, leadingBuilder;
  final List<Widget>? customItems;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider).localeCode ?? 'en';
    final search = useDebouncedSearch();
    final isFirstRun = useRef(true);

    // Re-fetch page 1 whenever the debounced query settles. Skip the initial
    // run: the PagedListView already loads the first page on mount.
    useEffect(() {
      if (isFirstRun.value) {
        isFirstRun.value = false;
      } else {
        onSearch?.call(search.debounced);
        pagingController.refresh();
      }
      return null;
    }, [search.debounced]);

    String labelOf(T item) => labelBuilder?.call(item) ?? localizedName(item, settings);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
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
              const SizedBox(height: Insets.medium),
              const BreakLine(),
              const SizedBox(height: Insets.medium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.medium),
                child: Text(
                  titleText,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: Insets.medium),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colorScheme.outline,
                      width: 0.5,
                    ),
                    color: context.colorScheme.surfaceContainerLowest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(BorderSize.medium),
                      topRight: Radius.circular(BorderSize.medium),
                    ),
                  ),
                  padding: Insets.mediumAll,
                  child: Column(
                    spacing: Insets.medium,
                    children: [
                      CustomTextFormField(
                        prefixIcon: const SvgPrefixIcon(img: 'search-01'),
                        controller: search.controller,
                        hintText: context.l10n.search,
                        onFieldSubmitted: onFieldSubmitted,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await Future.sync(pagingController.refresh);
                          },
                          child: Column(
                            children: [
                              // Add custom items if provided
                              ...?customItems,
                              if (customItems != null)
                                const Divider(thickness: 0.5),
                              // Then show the regular list
                              Expanded(
                                child: PagedListView.separated(
                                  pagingController: pagingController,
                                  builderDelegate: pagingController
                                      .defaultListDelegate(
                                        context: context,
                                        itemBuilder: (context, item, index) {
                                          // RepaintBoundary isolates each row so
                                          // scrolling doesn't force siblings to
                                          // repaint. itemExtent is intentionally
                                          // not used here: subtitle/leading are
                                          // optional per item, so row height isn't
                                          // uniform and a fixed extent would clip
                                          // taller rows.
                                          return RepaintBoundary(
                                            child: ListTile(
                                              title: Text(labelOf(item)),
                                              subtitle: subtitleBuilder?.call(
                                                item,
                                              ),
                                              leading: leadingBuilder?.call(
                                                item,
                                              ),
                                              onTap: () => onSelect(item),
                                            ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
