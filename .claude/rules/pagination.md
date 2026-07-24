---
paths:
  - "lib/core/pagination/**"
---

# Pagination

[lib/core/pagination/](../../lib/core/pagination/) wraps `infinite_scroll_pagination`
behind two hooks in
[pagination_controller.dart](../../lib/core/pagination/pagination_controller.dart):

- `usePagingController` — fetch signature `Future<Paginated<T>> Function(int page)`, throws on failure.
- `usePagingControllerEither` — fetch returns `Future<Either<Failure, Paginated<T>>>`; `Left` lands on `controller.error`.

Both must be called from a `HookWidget`/`HookConsumerWidget`. Each page request is
routed through the *current* hook, so the fetch closure (and any state it captures,
such as a search term) is read at request time, not frozen at construction.
Pass `keys:` when you want the controller **recreated** (full reset to page 1);
call `controller.refresh()` when you only want a refetch.

Server pages implement `Paginated<T>`
([paginated.dart](../../lib/core/network/paginated.dart)); `PaginatedResponse<T>`
([paginated_response.dart](../../lib/core/network/paginated_response.dart)) is the wire
shape (`items` / `totalCount`). `addItems` decides last-page from the rows actually
returned, never an assumed page size. List UI goes through
`controller.defaultListDelegate(context: ..., itemBuilder: ...)`
([paging_list_delegate.dart](../../lib/core/pagination/paging_list_delegate.dart)), which
supplies the loading / error+retry / empty indicators.
