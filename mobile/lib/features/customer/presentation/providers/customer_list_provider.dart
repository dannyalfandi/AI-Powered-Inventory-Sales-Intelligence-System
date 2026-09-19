import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/customer.dart';
import 'customer_providers.dart';

part 'customer_list_provider.g.dart';

/// Current search text (name, email or phone). [CustomerList] watches it.
@riverpod
class CustomerSearchQuery extends _$CustomerSearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query.trim();
}

@riverpod
class CustomerList extends _$CustomerList {
  @override
  Future<PagedState<Customer>> build() async {
    final search = ref.watch(customerSearchQueryProvider);
    final first = await ref.watch(getCustomersUseCaseProvider)(
      page: 1,
      pageSize: ApiConstants.defaultPageSize,
      search: search,
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
      final next = await ref.read(getCustomersUseCaseProvider)(
        page: current.page + 1,
        pageSize: current.pageSize,
        search: ref.read(customerSearchQueryProvider),
      );
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.append(next, (c) => c.id));
    } on Failure catch (f) {
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: f));
    }
  }

  /// False if the list changed while the next page was loading.
  bool _stillLoading(PagedState<Customer> loading) {
    if (!ref.mounted) return false;
    if (identical(state.value, loading)) return true;
    final now = state.value;
    if (now != null && now.isLoadingMore) state = AsyncData(now.copyWith(isLoadingMore: false));
    return false;
  }

  /// Deletes on the server first, then removes the row. Not optimistic: a
  /// 409 (customer still has orders that are not cancelled) is an expected
  /// outcome, so the row must simply stay. Rethrows the [Failure].
  Future<void> delete(int id) async {
    await ref.read(deleteCustomerUseCaseProvider)(id);
    final current = state.value;
    if (!ref.mounted || current == null) return;
    state = AsyncData(
      current.copyWith(
        items: current.items.where((c) => c.id != id).toList(),
        total: current.total > 0 ? current.total - 1 : 0,
      ),
    );
  }
}

/// User-facing message for a failed customer delete. A 409 means the
/// customer still has orders that are not cancelled (backend: "customer 9
/// still has 2 sales order(s) that are not cancelled").
String customerDeleteErrorMessage(Failure failure, Customer customer) {
  if (failure is ServerFailure && failure.isConflict) {
    final count = RegExp(r'has (\d+) sales order').firstMatch(failure.message)?.group(1);
    final orders = count == null ? 'pesanan' : '$count pesanan';
    return 'Pelanggan "${customer.name}" masih punya $orders yang belum dibatalkan '
        '(menunggu, dikonfirmasi, atau sudah dikirim). '
        'Pelanggan dengan riwayat pesanan tidak bisa dihapus; batalkan pesanan yang masih '
        'menunggu/dikonfirmasi bila memang tidak jadi.';
  }
  return 'Gagal menghapus pelanggan: ${failure.message}';
}

/// First page of customers matching [query] (name, email or phone), for
/// pickers such as the order form. Refine the query to find others.
@riverpod
Future<List<Customer>> customerSearch(Ref ref, String query) async =>
    (await ref.watch(getCustomersUseCaseProvider)(search: query)).items;
