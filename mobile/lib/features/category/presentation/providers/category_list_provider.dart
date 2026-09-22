import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/category.dart';
import 'category_providers.dart';

part 'category_list_provider.g.dart';

/// Current search text. [CategoryList] watches it, so changing the query
/// rebuilds the list from page 1.
@riverpod
class CategorySearchQuery extends _$CategorySearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query.trim();
}

@riverpod
class CategoryList extends _$CategoryList {
  @override
  Future<PagedState<Category>> build() async {
    final search = ref.watch(categorySearchQueryProvider);
    final first = await ref.watch(getCategoriesUseCaseProvider)(
      page: 1,
      pageSize: ApiConstants.defaultPageSize,
      search: search,
    );
    return PagedState.first(first);
  }

  /// Appends the next page. Errors are kept in [PagedState.loadMoreError]
  /// instead of replacing the whole list with an error state.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || state.isLoading || !current.canLoadMore) return;
    final loading = current.copyWith(isLoadingMore: true, loadMoreError: null);
    state = AsyncData(loading);

    try {
      final next = await ref.read(getCategoriesUseCaseProvider)(
        page: current.page + 1,
        pageSize: current.pageSize,
        search: ref.read(categorySearchQueryProvider),
      );
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.append(next, (c) => c.id));
    } on Failure catch (f) {
      if (!_stillLoading(loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: f));
    }
  }

  /// False if the list changed while the next page was loading (search,
  /// refresh, delete): the result belongs to a stale list and is dropped.
  bool _stillLoading(PagedState<Category> loading) {
    if (!ref.mounted) return false;
    if (identical(state.value, loading)) return true;
    final now = state.value;
    if (now != null && now.isLoadingMore) state = AsyncData(now.copyWith(isLoadingMore: false));
    return false;
  }

  /// Deletes on the server first and only then removes the category from the
  /// list. Not optimistic (unlike products): a 409 "still used by products"
  /// is an expected outcome here, so the row must simply stay. Rethrows the
  /// [Failure] for the UI.
  Future<void> delete(int id) async {
    await ref.read(deleteCategoryUseCaseProvider)(id);
    ref.invalidate(categoryOptionsProvider);
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

/// Every category, for the product form's category picker. Invalidated
/// whenever categories are created, renamed or deleted.
@riverpod
Future<List<Category>> categoryOptions(Ref ref) => ref.watch(getCategoriesUseCaseProvider).all();

/// User-facing message for a failed category delete.
///
/// A 409 means products still use the category. The backend only sends a
/// sentence (code `conflict`, no `details`), and it is already written in the
/// language this app asked for via `Accept-Language`, so it is quoted as it
/// is instead of being parsed â€” the old English-only regex over that sentence
/// broke the moment the server answered in Indonesian.
String categoryDeleteErrorMessage(BuildContext context, Failure failure, Category category) {
  final l10n = context.l10n;
  final reason = errorMessage(context, failure);
  if (failure is ServerFailure && failure.isConflict) {
    return l10n.categoryDeleteBlockedBody(category.name, reason);
  }
  return l10n.categoryDeleteFailed(reason);
}
