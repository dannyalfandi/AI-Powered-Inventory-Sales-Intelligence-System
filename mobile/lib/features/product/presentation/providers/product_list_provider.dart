import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import 'product_providers.dart';

part 'product_list_provider.freezed.dart';
part 'product_list_provider.g.dart';

/// Loaded pages of the product list. Initial loading/error is expressed by the
/// surrounding `AsyncValue`; only "load more" status lives here because the
/// already-loaded items must stay visible while the next page loads.
@freezed
abstract class ProductListState with _$ProductListState {
  const ProductListState._();

  const factory ProductListState({
    required List<Product> items,
    required int page,
    required int pageSize,
    required int total,
    @Default('') String search,
    @Default(false) bool isLoadingMore,
    Failure? loadMoreError,
  }) = _ProductListState;

  bool get hasMore => page * pageSize < total;
}

/// Current search text. [ProductList] watches it, so changing the query
/// rebuilds the list from page 1 and Riverpod discards stale in-flight results.
@riverpod
class ProductSearchQuery extends _$ProductSearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query.trim();
}

@riverpod
class ProductList extends _$ProductList {
  @override
  Future<ProductListState> build() async {
    final search = ref.watch(productSearchQueryProvider);
    final page = await ref.watch(getProductsUseCaseProvider)(
      page: 1,
      pageSize: ApiConstants.defaultPageSize,
      search: search,
    );
    return ProductListState(
      items: page.items,
      page: page.page,
      pageSize: page.pageSize,
      total: page.total,
      search: search,
    );
  }

  /// Appends the next page. Errors are kept in [ProductListState.loadMoreError]
  /// instead of replacing the whole list with an error state.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || state.isLoading || !current.hasMore || current.isLoadingMore) {
      return;
    }
    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    try {
      final next = await ref.read(getProductsUseCaseProvider)(
        page: current.page + 1,
        pageSize: current.pageSize,
        search: current.search,
      );
      // Drop the result if the list was rebuilt (search/refresh) meanwhile.
      if (!ref.mounted || state.value?.page != current.page || state.value?.search != current.search) {
        return;
      }
      final seen = current.items.map((p) => p.id).toSet();
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items.where((p) => !seen.contains(p.id))],
          page: next.page,
          total: next.total,
          isLoadingMore: false,
        ),
      );
    } on Failure catch (f) {
      if (!ref.mounted) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: f));
    }
  }

  /// Removes the product optimistically (required by `Dismissible`), and
  /// restores it if the API call fails. Rethrows the [Failure] for the UI.
  Future<void> delete(int id) async {
    final before = state.value;
    if (before != null) {
      state = AsyncData(
        before.copyWith(
          items: before.items.where((p) => p.id != id).toList(),
          total: before.total > 0 ? before.total - 1 : 0,
        ),
      );
    }
    try {
      await ref.read(deleteProductUseCaseProvider)(id);
    } on Failure {
      if (ref.mounted && before != null) state = AsyncData(before);
      rethrow;
    }
  }
}
