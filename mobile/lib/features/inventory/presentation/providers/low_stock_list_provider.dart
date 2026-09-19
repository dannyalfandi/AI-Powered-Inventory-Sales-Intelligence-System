import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/inventory.dart';
import 'inventory_providers.dart';

part 'low_stock_list_provider.g.dart';

/// Products at or below their low-stock threshold, lowest stock first.
@riverpod
class LowStockList extends _$LowStockList {
  @override
  Future<PagedState<LowStockItem>> build() async {
    final first = await ref.watch(getLowStockItemsUseCaseProvider)(
      pageSize: ApiConstants.defaultPageSize,
    );
    return PagedState.first(first);
  }

  /// Appends the next page; errors go to [PagedState.loadMoreError].
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || state.isLoading || !current.canLoadMore) return;
    final loading = current.copyWith(isLoadingMore: true, loadMoreError: null);
    state = AsyncData(loading);

    try {
      final next = await ref.read(getLowStockItemsUseCaseProvider)(
        page: current.page + 1,
        pageSize: current.pageSize,
      );
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.append(next, (i) => i.productId));
    } on Failure catch (f) {
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: f));
    }
  }

  /// False if the list was rebuilt (movement recorded, refresh) while loading.
  bool _stillLoading(PagedState<LowStockItem> loading) {
    if (!ref.mounted) return false;
    if (identical(state.value, loading)) return true;
    final now = state.value;
    if (now != null && now.isLoadingMore) state = AsyncData(now.copyWith(isLoadingMore: false));
    return false;
  }
}
