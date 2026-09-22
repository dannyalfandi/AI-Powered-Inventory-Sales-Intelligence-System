import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/paged_list.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/providers/product_form_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/stock_movement_list_provider.dart';
import '../widgets/movement_form_sheet.dart';
import '../widgets/movement_tile.dart';
import '../widgets/stock_summary_card.dart';

/// Product detail: product info, current stock, "record movement" and the
/// movement history (newest first, infinite scroll).
class ProductStockScreen extends ConsumerStatefulWidget {
  const ProductStockScreen({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductStockScreen> createState() => _ProductStockScreenState();
}

class _ProductStockScreenState extends ConsumerState<ProductStockScreen> {
  final _scrollController = ScrollController();

  int get _id => widget.productId;

  @override
  void initState() {
    super.initState();
    listenNearEnd(_scrollController, () => ref.read(stockMovementListProvider(_id).notifier).loadMore());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(productDetailProvider(_id))
      ..invalidate(productInventoryProvider(_id))
      ..invalidate(stockMovementListProvider(_id));
    try {
      await Future.wait([
        ref.read(productDetailProvider(_id).future),
        ref.read(productInventoryProvider(_id).future),
        ref.read(stockMovementListProvider(_id).future),
      ]);
    } on Failure {
      // Each section shows its own error state.
    }
  }

  Future<void> _recordMovement() async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showMovementFormSheet(context, productId: _id);
    if (result == null || !mounted) return;
    final m = result.movement;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.movementRecorded(m.type.label(context), m.quantityBefore, m.quantityAfter),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productDetailProvider(_id));

    // A missing product (404) or a failed first load replaces the whole page.
    if (!product.hasValue) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.productStockTitle)),
        body: product.hasError
            ? ErrorView(
                message: errorMessage(context, product.error!),
                onRetry: () => ref.invalidate(productDetailProvider(_id)),
              )
            : const LoadingView(),
      );
    }

    final p = product.requireValue;
    return Scaffold(
      appBar: AppBar(
        title: Text(p.name, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: context.l10n.inventoryEditProduct,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.pushNamed(AppRoutes.productEdit, pathParameters: {'id': '$_id'}),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('record_movement_button'),
        onPressed: _recordMovement,
        icon: const Icon(Icons.swap_vert),
        label: Text(context.l10n.productStockRecordMovement),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverList.list(
                children: [
                  _ProductHeader(product: p),
                  const SizedBox(height: 16),
                  _StockSection(productId: _id),
                  const SizedBox(height: 24),
                  Text(context.l10n.productStockHistory, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            _MovementHistory(productId: _id),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = product.category;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.sku, style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              formatRupiah(product.price),
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Chip(
              key: const Key('product_category_chip'),
              avatar: const Icon(Icons.label_outline, size: 18),
              label: Text(category?.name ?? context.l10n.productNoCategory),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        if (product.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(product.description, style: theme.textTheme.bodyMedium),
        ],
      ],
    );
  }
}

class _StockSection extends ConsumerWidget {
  const _StockSection({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(productInventoryProvider(productId));
    return inventory.when(
      skipLoadingOnRefresh: true,
      loading: () => const SizedBox(height: 120, child: LoadingView()),
      error: (e, _) => Card(
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: 160,
          child: ErrorView(
            message: errorMessage(context, e),
            onRetry: () => ref.invalidate(productInventoryProvider(productId)),
          ),
        ),
      ),
      data: (inv) => StockSummaryCard(inventory: inv),
    );
  }
}

class _MovementHistory extends ConsumerWidget {
  const _MovementHistory({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movements = ref.watch(stockMovementListProvider(productId));
    return movements.when(
      skipLoadingOnRefresh: true,
      loading: () => const SliverToBoxAdapter(
        child: Padding(padding: EdgeInsets.all(24), child: LoadingView()),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: ErrorView(
          message: errorMessage(context, e),
          onRetry: () => ref.invalidate(stockMovementListProvider(productId)),
        ),
      ),
      data: (state) {
        if (state.items.isEmpty) {
          return SliverToBoxAdapter(
            child: EmptyView(
              icon: Icons.history,
              message: context.l10n.inventoryHistoryEmptyHint,
            ),
          );
        }
        return SliverList.separated(
          itemCount: state.items.length + 1,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            if (i == state.items.length) {
              return PagedListFooter(
                state: state,
                onLoadMore: () => ref.read(stockMovementListProvider(productId).notifier).loadMore(),
                totalLabel: (n) => context.l10n.inventoryMovementsCount(n),
              );
            }
            return MovementTile(movement: state.items[i]);
          },
        );
      },
    );
  }
}
