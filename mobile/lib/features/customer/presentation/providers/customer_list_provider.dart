import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
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

/// User-facing message for a failed customer delete.
///
/// A 409 means the customer still has orders that are not cancelled. As with
/// categories, the backend sends only a sentence (code `conflict`, no
/// `details`) already written in the requested language, so it is quoted
/// rather than parsed for a count.
String customerDeleteErrorMessage(BuildContext context, Failure failure, Customer customer) {
  final l10n = context.l10n;
  final reason = errorMessage(context, failure);
  if (failure is ServerFailure && failure.isConflict) {
    return l10n.customerDeleteBlockedBody(customer.name, reason);
  }
  return l10n.customerDeleteFailed(reason);
}

/// First page of customers matching [query] (name, email or phone), for
/// pickers such as the order form. Refine the query to find others.
@riverpod
Future<List<Customer>> customerSearch(Ref ref, String query) async =>
    (await ref.watch(getCustomersUseCaseProvider)(search: query)).items;
