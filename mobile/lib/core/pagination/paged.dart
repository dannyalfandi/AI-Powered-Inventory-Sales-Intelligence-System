import 'package:freezed_annotation/freezed_annotation.dart';

import '../error/failure.dart';

part 'paged.freezed.dart';

/// One page of results plus the backend `meta` (`page`, `page_size`, `total`).
/// Pure Dart, so domain layers may use it.
@freezed
abstract class PageResult<T> with _$PageResult<T> {
  const PageResult._();

  const factory PageResult({
    required List<T> items,
    required int page,
    required int pageSize,
    required int total,
  }) = _PageResult<T>;

  bool get hasMore => page * pageSize < total;
}

/// Loaded pages of an infinite-scroll list. The initial load/error lives in the
/// surrounding `AsyncValue`; only "load more" status lives here, because the
/// items already loaded must stay visible while the next page loads.
@freezed
abstract class PagedState<T> with _$PagedState<T> {
  const PagedState._();

  const factory PagedState({
    required List<T> items,
    required int page,
    required int pageSize,
    required int total,
    @Default(false) bool isLoadingMore,
    Failure? loadMoreError,
  }) = _PagedState<T>;

  factory PagedState.first(PageResult<T> r) =>
      PagedState(items: r.items, page: r.page, pageSize: r.pageSize, total: r.total);

  bool get hasMore => page * pageSize < total;

  bool get canLoadMore => hasMore && !isLoadingMore;

  /// Appends [next], skipping items already loaded (rows can shift between
  /// page requests when data changes).
  PagedState<T> append(PageResult<T> next, Object Function(T) idOf) {
    final seen = items.map(idOf).toSet();
    return copyWith(
      items: [...items, ...next.items.where((e) => !seen.contains(idOf(e)))],
      page: next.page,
      total: next.total,
      isLoadingMore: false,
      loadMoreError: null,
    );
  }
}
