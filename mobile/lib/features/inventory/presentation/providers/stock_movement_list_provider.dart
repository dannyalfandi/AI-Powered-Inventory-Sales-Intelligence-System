import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/inventory.dart';
import 'inventory_providers.dart';

part 'stock_movement_list_provider.g.dart';

/// Movement history of one product, newest first, loaded page by page.
@riverpod
class StockMovementList extends _$StockMovementList {
  @override
  Future<PagedState<StockMovement>> build(int productId) async {
    final first = await ref.watch(getStockMovementsUseCaseProvider)(
      productId,
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
      final next = await ref.read(getStockMovementsUseCaseProvider)(
        productId,
        page: current.page + 1,
        pageSize: current.pageSize,
      );
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.append(next, (m) => m.id));
    } on Failure catch (f) {
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: f));
    }
  }

  /// False if the list was rebuilt (new movement, refresh) while loading.
  bool _stillLoading(PagedState<StockMovement> loading) {
    if (!ref.mounted) return false;
    if (identical(state.value, loading)) return true;
    final now = state.value;
    if (now != null && now.isLoadingMore) state = AsyncData(now.copyWith(isLoadingMore: false));
    return false;
  }
}
