import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/managed_user.dart';
import 'user_providers.dart';

part 'user_list_provider.g.dart';

/// Current search text (name or email). [UserList] watches it.
@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query.trim();
}

@riverpod
class UserList extends _$UserList {
  @override
  Future<PagedState<ManagedUser>> build() async {
    final search = ref.watch(userSearchQueryProvider);
    final first = await ref.watch(getUsersUseCaseProvider)(pageSize: ApiConstants.defaultPageSize, search: search);
    return PagedState.first(first);
  }

  /// Appends the next page; a failure is kept in [PagedState.loadMoreError].
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || state.isLoading || !current.canLoadMore) return;
    final loading = current.copyWith(isLoadingMore: true, loadMoreError: null);
    state = AsyncData(loading);
    try {
      final next = await ref.read(getUsersUseCaseProvider)(
        page: current.page + 1,
        pageSize: current.pageSize,
        search: ref.read(userSearchQueryProvider),
      );
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.append(next, (u) => u.id));
    } on Failure catch (f) {
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: f));
    }
  }

  /// Deletes on the server, then drops the row. Not optimistic: a 403 (a
  /// Super Admin, for a non-Super-Admin) or 409 must leave the row where it
  /// is. Rethrows the [Failure] for the UI.
  Future<void> delete(int id) async {
    await ref.read(deleteUserUseCaseProvider)(id);
    final current = state.value;
    if (!ref.mounted || current == null) return;
    state = AsyncData(
      current.copyWith(
        items: current.items.where((u) => u.id != id).toList(),
        total: current.total > 0 ? current.total - 1 : 0,
      ),
    );
  }
}
