import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/theme/app_status_colors.dart';
import '../../../../shared/widgets/app_refresh_indicator.dart';
import '../../../../shared/widgets/paged_list.dart';
import '../../../../shared/widgets/press_effect.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/inventory.dart';
import '../providers/low_stock_list_provider.dart';

/// Products at or below their low-stock threshold, lowest stock first.
class LowStockScreen extends ConsumerStatefulWidget {
  const LowStockScreen({super.key});

  @override
  ConsumerState<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends ConsumerState<LowStockScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    listenNearEnd(_scrollController, () => ref.read(lowStockListProvider.notifier).loadMore());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(lowStockListProvider);
    try {
      await ref.read(lowStockListProvider.future);
    } on Failure {
      // Shown by the error state of lowStockListProvider.
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(lowStockListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inventoryLowStockTitle)),
      body: items.when(
        loading: () => const SkeletonList(),
        error: (e, _) => RefreshableView(
          onRefresh: _refresh,
          child: ErrorView(
            message: errorMessage(context, e),
            onRetry: () => ref.invalidate(lowStockListProvider),
          ),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return RefreshableView(
              onRefresh: _refresh,
              child: EmptyView(
                icon: Icons.verified_outlined,
                message: context.l10n.inventoryLowStockAllGood,
              ),
            );
          }
          return AppRefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.items.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i == state.items.length) {
                  return PagedListFooter(
                    state: state,
                    onLoadMore: () => ref.read(lowStockListProvider.notifier).loadMore(),
                    totalLabel: (n) => context.l10n.inventoryRestockCount(n),
                  );
                }
                final item = state.items[i];
                return PressEffect(
                  child: _LowStockTile(
                    item: item,
                    onTap: () => context.pushNamed(
                      AppRoutes.productDetail,
                      pathParameters: {'id': '${item.productId}'},
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

class _LowStockTile extends StatelessWidget {
  const _LowStockTile({required this.item, this.onTap});

  final LowStockItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final empty = item.quantity == 0;
    final colors = AppStatusColors.of(context);
    final palette = empty ? colors.negative : colors.warning;
    return ListTile(
      onTap: onTap,
      leading: Icon(
        empty ? Icons.remove_shopping_cart_outlined : Icons.warning_amber_rounded,
        color: palette.accent,
      ),
      title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${item.sku} · ${context.l10n.inventoryThresholdShort(item.lowStockThreshold)}'),
      trailing: Text(
        empty ? context.l10n.inventoryOutOfStock : context.l10n.inventoryRemaining(item.quantity),
        style: theme.textTheme.titleSmall?.copyWith(color: palette.accent),
      ),
    );
  }
}
