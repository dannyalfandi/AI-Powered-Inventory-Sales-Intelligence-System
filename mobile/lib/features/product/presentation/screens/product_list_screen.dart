import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_refresh_indicator.dart';
import '../../../../shared/widgets/press_effect.dart';
import '../../../../shared/widgets/settings_action.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/product.dart';
import '../providers/product_list_provider.dart';
import '../widgets/product_tile.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(productSearchQueryProvider);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      ref.read(productListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {}); // toggles the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(productSearchQueryProvider.notifier).set(value);
    });
  }

  /// Shorthand so the callbacks below read like the build method.
  AppLocalizations get l10n => context.l10n;

  Future<void> _refresh() async {
    ref.invalidate(productListProvider);
    try {
      await ref.read(productListProvider.future);
    } on Failure {
      // Shown by the error state of productListProvider.
    }
  }

  Future<bool> _confirmDelete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.productDeleteConfirmTitle),
        content: Text(l10n.productDeleteConfirmBody(p.name, p.sku)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonDelete)),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _delete(Product p) async {
    final messenger = ScaffoldMessenger.of(context);
    final deleted = l10n.productDeleted(p.name);
    try {
      await ref.read(productListProvider.notifier).delete(p.id);
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(SnackBar(content: Text(deleted)));
    } on Failure catch (f) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.productDeleteFailed(errorMessage(context, f)))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    final canDelete = ref.hasPermission(Permissions.productsDelete);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productsTitle),
        actions: const [SettingsAction()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.productsSearchHint,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: _onSearchChanged,
              // Drop focus when touching the list/FAB; otherwise Flutter restores
              // focus (and the keyboard) here after every dialog or route pop.
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
      floatingActionButton: ref.hasPermission(Permissions.productsCreate)
          ? FloatingActionButton.extended(
              heroTag: 'product_fab',
              onPressed: () => context.pushNamed(AppRoutes.productCreate),
              icon: const Icon(Icons.add),
              label: Text(l10n.productsTitle),
            )
          : null,
      body: products.when(
        loading: () => const SkeletonList(),
        error: (e, _) => _Refreshable(
          onRefresh: _refresh,
          child: ErrorView(
            message: errorMessage(context, e),
            onRetry: () => ref.invalidate(productListProvider),
          ),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return _Refreshable(
              onRefresh: _refresh,
              child: EmptyView(
                icon: state.search.isEmpty ? Icons.inventory_2_outlined : Icons.search_off,
                message: state.search.isEmpty
                    ? l10n.productsEmptyHint
                    : l10n.productsEmptyForSearch(state.search),
              ),
            );
          }
          return AppRefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: state.items.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i == state.items.length) return _ListFooter(state: state);
                final p = state.items[i];
                final tile = PressEffect(
                  child: ProductTile(
                    product: p,
                    onTap: () => context.pushNamed(
                      AppRoutes.productDetail,
                      pathParameters: {'id': '${p.id}'},
                    ),
                  ),
                );
                // Without products.delete the row simply doesn't swipe.
                if (!canDelete) return KeyedSubtree(key: ValueKey(p.id), child: tile);
                return Dismissible(
                  key: ValueKey(p.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: const Icon(Icons.delete_outline),
                  ),
                  confirmDismiss: (_) => _confirmDelete(p),
                  onDismissed: (_) => _delete(p),
                  child: tile,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ListFooter extends ConsumerWidget {
  const _ListFooter({required this.state});

  final ProductListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Widget child;
    if (state.isLoadingMore) {
      return const SkeletonList(rows: 1, padding: EdgeInsets.zero);
    } else if (state.loadMoreError != null) {
      child = TextButton.icon(
        onPressed: () => ref.read(productListProvider.notifier).loadMore(),
        icon: const Icon(Icons.refresh),
        label: Text(context.l10n.commonLoadFailed(errorMessage(context, state.loadMoreError!))),
      );
    } else if (state.hasMore) {
      child = TextButton(
        onPressed: () => ref.read(productListProvider.notifier).loadMore(),
        child: Text(context.l10n.commonLoadMore),
      );
    } else {
      child = Text(context.l10n.productsCount(state.total), style: theme.textTheme.bodySmall);
    }
    return Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Center(child: child));
  }
}

/// Makes non-list content (empty/error) pull-to-refreshable.
class _Refreshable extends StatelessWidget {
  const _Refreshable({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        ),
      ),
    );
  }
}
