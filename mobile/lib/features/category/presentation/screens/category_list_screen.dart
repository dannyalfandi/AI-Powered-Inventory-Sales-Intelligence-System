import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/paged_list.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/category.dart';
import '../providers/category_list_provider.dart';

class CategoryListScreen extends ConsumerStatefulWidget {
  const CategoryListScreen({super.key});

  @override
  ConsumerState<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends ConsumerState<CategoryListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(categorySearchQueryProvider);
    listenNearEnd(_scrollController, () => ref.read(categoryListProvider.notifier).loadMore());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Shorthand so the callbacks below read like the build method.
  AppLocalizations get l10n => context.l10n;

  void _onSearchChanged(String value) {
    setState(() {}); // toggles the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(categorySearchQueryProvider.notifier).set(value);
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(categoryListProvider);
    try {
      await ref.read(categoryListProvider.future);
    } on Failure {
      // Shown by the error state of categoryListProvider.
    }
  }

  Future<bool> _confirmDelete(Category c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.categoryDeleteConfirmTitle),
        content: Text(l10n.categoryDeleteConfirmBody(c.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonDelete)),
        ],
      ),
    );
    return ok ?? false;
  }

  /// Confirms, deletes on the server, and returns whether the row may be
  /// dismissed. On failure the row slides back.
  Future<bool> _confirmAndDelete(Category c) async {
    if (!await _confirmDelete(c)) return false;
    if (!mounted) return false;
    final messenger = ScaffoldMessenger.of(context);
    final deleted = l10n.categoryDeleted(c.name);
    try {
      await ref.read(categoryListProvider.notifier).delete(c.id);
      messenger.showSnackBar(SnackBar(content: Text(deleted)));
      return true;
    } on Failure catch (f) {
      if (!mounted) return false;
      final message = categoryDeleteErrorMessage(context, f, c);
      if (f is ServerFailure && f.isConflict) {
        // Not a transient error: explain what to do instead of a snackbar.
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.link),
            title: Text(l10n.categoryDeleteBlockedTitle),
            content: Text(message),
            actions: [
              FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonUnderstood)),
            ],
          ),
        );
      } else {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryListProvider);
    final search = ref.watch(categorySearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoriesTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.categoriesSearchHint,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: _onSearchChanged,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    tooltip: l10n.commonClearSearch,
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'category_fab',
        onPressed: () => context.pushNamed(AppRoutes.categoryCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.categoriesTitle),
      ),
      body: categories.when(
        loading: () => const LoadingView(),
        error: (e, _) => RefreshableView(
          onRefresh: _refresh,
          child: ErrorView(
            message: errorMessage(context, e),
            onRetry: () => ref.invalidate(categoryListProvider),
          ),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return RefreshableView(
              onRefresh: _refresh,
              child: EmptyView(
                icon: search.isEmpty ? Icons.category_outlined : Icons.search_off,
                message: search.isEmpty
                    ? l10n.categoriesEmptyHint
                    : l10n.categoriesEmptyForSearch(search),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: state.items.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i == state.items.length) {
                  return PagedListFooter(
                    state: state,
                    onLoadMore: () => ref.read(categoryListProvider.notifier).loadMore(),
                    totalLabel: (n) => l10n.categoriesCount(n),
                  );
                }
                final c = state.items[i];
                return Dismissible(
                  key: ValueKey(c.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Icon(Icons.delete_outline),
                  ),
                  // The provider already removed the row once the server confirmed.
                  confirmDismiss: (_) => _confirmAndDelete(c),
                  child: ListTile(
                    leading: const Icon(Icons.label_outline),
                    title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: c.description.isEmpty
                        ? null
                        : Text(c.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => context.pushNamed(
                      AppRoutes.categoryEdit,
                      pathParameters: {'id': '${c.id}'},
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
