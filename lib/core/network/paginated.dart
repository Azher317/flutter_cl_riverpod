import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Shape every paginated payload exposes to [PaginatedExtension.addItems],
/// regardless of the wire format it was parsed from (see [PaginatedResponse]).
abstract interface class Paginated<T> {
  List<T> get result;

  int get total;
}

const int defaultLimitSize = 25;
const int firstPage = 1;

extension PaginatedExtension<T> on PagingController<int, T> {
  /// Appends [data] to the controller, deciding whether it was the final page
  /// from the items actually returned — never from an assumed page size. A
  /// short page (fewer rows than requested) or an empty page therefore closes
  /// the list instead of drifting or looping.
  void addItems(Paginated<T> data, int pageKey) {
    final loaded = (itemList?.length ?? 0) + data.result.length;
    final isLastPage = data.result.isEmpty || loaded >= data.total;
    if (isLastPage) {
      appendLastPage(data.result);
    } else {
      appendPage(data.result, pageKey + 1);
    }
  }
}
