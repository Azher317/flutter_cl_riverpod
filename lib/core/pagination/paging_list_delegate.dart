import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/column_padded.dart';
import 'package:app/core/widgets/state_ui/empty_state.dart';
import 'package:app/core/widgets/state_ui/state_message.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

Widget _pageLoader(BuildContext context) => const Center(
  child: Padding(padding: Insets.mediumAll, child: CircularProgressIndicator()),
);

extension PagingListDelegateX<ItemType> on PagingController<int, ItemType> {
  /// App-wide default set of loading / error / empty indicators for a paged
  /// list. Being an extension on the controller, it cannot be handed a
  /// controller of a different type by mistake.
  PagedChildBuilderDelegate<ItemType> defaultListDelegate({
    required BuildContext context,
    required ItemWidgetBuilder<ItemType> itemBuilder,
  }) {
    return PagedChildBuilderDelegate<ItemType>(
      itemBuilder: itemBuilder,
      animateTransitions: true,
      transitionDuration: Time.small,
      firstPageErrorIndicatorBuilder: (context) {
        return StateMessage(
          icon: Icons.error_outline,
          iconColor: context.colorScheme.error,
          title: context.l10n.defaultErrorMessage,
          action: FilledButton(
            onPressed: refresh,
            child: Text(context.l10n.retry),
          ),
        );
      },
      newPageErrorIndicatorBuilder: (context) {
        return InkWell(
          onTap: retryLastFailedRequest,
          child: Padding(
            padding: Insets.smallAll,
            child: ColumnPadded(
              children: [
                Text(
                  context.l10n.defaultErrorMessage,
                  textAlign: TextAlign.center,
                ),
                const Icon(Icons.refresh),
              ],
            ),
          ),
        );
      },
      firstPageProgressIndicatorBuilder: _pageLoader,
      newPageProgressIndicatorBuilder: _pageLoader,
      noItemsFoundIndicatorBuilder: (context) {
        return EmptyState(
          title: context.l10n.noItemsFoundError,
          action: FilledButton(
            onPressed: refresh,
            child: Text(context.l10n.retry),
          ),
        );
      },
    );
  }
}
