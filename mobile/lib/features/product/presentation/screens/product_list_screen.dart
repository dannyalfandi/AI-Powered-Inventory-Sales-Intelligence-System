import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/state_views.dart';
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
        title: const Text('Hapus produk?'),
        content: Text('"${p.name}" (${p.sku}) akan dihapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _delete(Product p) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(productListProvider.notifier).delete(p.id);
      messenger.showSnackBar(SnackBar(content: Text('${p.name} dihapus')));
    } on Failure catch (f) {
      messenger.showSnackBar(SnackBar(content: Text('Gagal menghapus: ${f.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Cari nama atau SKU',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: _onSearchChanged,
              // Drop focus when touching the list/FAB; otherwise Flutter restores
              // focus (and the keyboard) here after every dialog or route pop.
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    tooltip: 'Hapus pencarian',
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
        heroTag: 'product_fab',
        onPressed: () => context.pushNamed(AppRoutes.productCreate),
        icon: const Icon(Icons.add),
        label: const Text('Produk'),
      ),
      body: products.when(
        loading: () => const LoadingView(),
        error: (e, _) => _Refreshable(
          onRefresh: _refresh,
          child: ErrorView(
            message: errorMessage(e),
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
                    ? 'Belum ada produk.\nTambahkan produk pertama.'
                    : 'Tidak ada produk untuk "${state.search}".',
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
                if (i == state.items.length) return _ListFooter(state: state);
                final p = state.items[i];
                return Dismissible(
                  key: ValueKey(p.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Icon(Icons.delete_outline),
                  ),
                  confirmDismiss: (_) => _confirmDelete(p),
                  onDismissed: (_) => _delete(p),
                  child: ProductTile(
                    product: p,
                    onTap: () => context.pushNamed(
                      AppRoutes.productDetail,
                      pathParameters: {'id': '${p.id}'},
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

class _ListFooter extends ConsumerWidget {
  const _ListFooter({required this.state});

  final ProductListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Widget child;
    if (state.isLoadingMore) {
      child = const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2));
    } else if (state.loadMoreError != null) {
      child = TextButton.icon(
        onPressed: () => ref.read(productListProvider.notifier).loadMore(),
        icon: const Icon(Icons.refresh),
        label: Text('Gagal memuat: ${state.loadMoreError!.message}'),
      );
    } else if (state.hasMore) {
      child = TextButton(
        onPressed: () => ref.read(productListProvider.notifier).loadMore(),
        child: const Text('Muat lebih banyak'),
      );
    } else {
      child = Text('${state.total} produk', style: theme.textTheme.bodySmall);
    }
    return Padding(padding: const EdgeInsets.all(16), child: Center(child: child));
  }
}

/// Makes non-list content (empty/error) pull-to-refreshable.
class _Refreshable extends StatelessWidget {
  const _Refreshable({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
