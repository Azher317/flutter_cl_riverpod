import 'package:app/core/either.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/network/paginated.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Fetch a page, signalling failure by throwing.
typedef PageChanged<T> = Future<Paginated<T>> Function(int pageKey);

/// Fetch a page as the project-standard [Either] — the [Left] failure is
/// surfaced on the controller instead of being thrown.
typedef PageChangedEither<T> =
    Future<Either<Failure, Paginated<T>>> Function(int pageKey);

/// Handles a single page request for [pageKey] against [controller].
typedef _PageRequestHandler<T> =
    Future<void> Function(PagingController<int, T> controller, int pageKey);

/// Creates a [PagingController] wired to a [PageChanged] fetch function that
/// throws on failure.
const usePagingController = _PagingControllerHookCreator();

/// Creates a [PagingController] wired to a [PageChangedEither] fetch function
/// that returns the project-standard [Either].
const usePagingControllerEither = _PagingControllerHookCreatorEither();

class _PagingControllerHookCreator {
  const _PagingControllerHookCreator();

  PagingController<int, ItemType> call<ItemType>({
    int page = firstPage,
    required PageChanged<ItemType> listen,
    List<Object?>? keys,
  }) {
    return use(
      _PagingControllerHook<ItemType>(
        page: page,
        onRequest: (controller, pageKey) =>
            controller.appendPageFrom(listen, pageKey),
        keys: keys,
      ),
    );
  }
}

class _PagingControllerHookCreatorEither {
  const _PagingControllerHookCreatorEither();

  PagingController<int, ItemType> call<ItemType>({
    int page = firstPage,
    required PageChangedEither<ItemType> listen,
    List<Object?>? keys,
  }) {
    return use(
      _PagingControllerHook<ItemType>(
        page: page,
        onRequest: (controller, pageKey) =>
            controller.appendPageFromEither(listen, pageKey),
        keys: keys,
      ),
    );
  }
}

class _PagingControllerHook<ItemType>
    extends Hook<PagingController<int, ItemType>> {
  const _PagingControllerHook({
    required this.page,
    required this.onRequest,
    super.keys,
  });

  final int page;
  final _PageRequestHandler<ItemType> onRequest;

  @override
  _PagingControllerHookState<ItemType> createState() {
    return _PagingControllerHookState<ItemType>();
  }
}

class _PagingControllerHookState<ItemType>
    extends
        HookState<
          PagingController<int, ItemType>,
          _PagingControllerHook<ItemType>
        > {
  late final _controller = PagingController<int, ItemType>(
    firstPageKey: hook.page,
  );

  @override
  void initHook() {
    // Register exactly one page-request listener, but route each request
    // through the `hook` getter — which always returns the *current* hook — so
    // the fetch closure (and any state it captures, e.g. a search query) is
    // read at request time, not frozen at construction.
    _controller.addPageRequestListener(
      (pageKey) => hook.onRequest(_controller, pageKey),
    );
  }

  @override
  PagingController<int, ItemType> build(BuildContext context) => _controller;

  @override
  void dispose() => _controller.dispose();

  @override
  String get debugLabel => 'usePagingController';
}

extension PagingControllerX<ItemType> on PagingController<int, ItemType> {
  /// Runs a throwing [PageChanged] for [pageKey], appending the page or
  /// surfacing the error.
  Future<void> appendPageFrom(PageChanged<ItemType> callback, int pageKey) async {
    try {
      addItems(await callback(pageKey), pageKey);
    } catch (e, stackTrace) {
      AppLogger.handle(e, stackTrace);
      error = e;
    }
  }

  /// Runs an [Either]-returning [PageChangedEither] for [pageKey], mapping
  /// [Left] onto [error] and [Right] onto [addItems].
  Future<void> appendPageFromEither(
    PageChangedEither<ItemType> callback,
    int pageKey,
  ) async {
    try {
      (await callback(pageKey)).fold(
        (failure) {
          AppLogger.handle(failure, StackTrace.current);
          error = failure;
        },
        (page) => addItems(page, pageKey),
      );
    } catch (e, stackTrace) {
      AppLogger.handle(e, stackTrace);
      error = e;
    }
  }
}
