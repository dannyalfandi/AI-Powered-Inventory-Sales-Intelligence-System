import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/sales_order.dart';
import 'sales_order_providers.dart';

part 'sales_order_list_provider.freezed.dart';
part 'sales_order_list_provider.g.dart';

/// Order list filters. [customerName] is only for showing the active filter.
@freezed
abstract class SalesOrderFilter with _$SalesOrderFilter {
  const factory SalesOrderFilter({
    OrderStatus? status,
    int? customerId,
    String? customerName,
  }) = _SalesOrderFilter;
}

@riverpod
class SalesOrderFilters extends _$SalesOrderFilters {
  @override
  SalesOrderFilter build() => const SalesOrderFilter();

  void setStatus(OrderStatus? status) => state = state.copyWith(status: status);

  void setCustomer(int id, String name) => state = state.copyWith(customerId: id, customerName: name);

  void clearCustomer() => state = state.copyWith(customerId: null, customerName: null);
}

/// Orders matching [salesOrderFiltersProvider], newest first, page by page.
@riverpod
class SalesOrderList extends _$SalesOrderList {
  @override
  Future<PagedState<SalesOrder>> build() async {
    final filter = ref.watch(salesOrderFiltersProvider);
    final first = await ref.watch(getSalesOrdersUseCaseProvider)(
      pageSize: ApiConstants.defaultPageSize,
      status: filter.status,
      customerId: filter.customerId,
    );
    return PagedState.first(first);
  }

  /// Appends the next page; errors go to [PagedState.loadMoreError].
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || state.isLoading || !current.canLoadMore) return;
    final loading = current.copyWith(isLoadingMore: true, loadMoreError: null);
    state = AsyncData(loading);

    final filter = ref.read(salesOrderFiltersProvider);
    try {
      final next = await ref.read(getSalesOrdersUseCaseProvider)(
        page: current.page + 1,
        pageSize: current.pageSize,
        status: filter.status,
        customerId: filter.customerId,
      );
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.append(next, (o) => o.id));
    } on Failure catch (f) {
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: f));
    }
  }

  /// False if the list changed (filter, refresh) while the next page loaded.
  bool _stillLoading(PagedState<SalesOrder> loading) {
    if (!ref.mounted) return false;
    if (identical(state.value, loading)) return true;
    final now = state.value;
    if (now != null && now.isLoadingMore) state = AsyncData(now.copyWith(isLoadingMore: false));
    return false;
  }
}
