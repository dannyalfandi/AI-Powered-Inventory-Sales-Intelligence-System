import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_refresh_indicator.dart';
import '../../../../shared/widgets/paged_list.dart';
import '../../../../shared/widgets/press_effect.dart';
import '../../../../shared/widgets/settings_action.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../customer/presentation/widgets/customer_picker.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/sales_order.dart';
import '../providers/sales_order_list_provider.dart';
import '../widgets/order_status_badge.dart';

class SalesOrderListScreen extends ConsumerStatefulWidget {
  const SalesOrderListScreen({super.key});

  @override
  ConsumerState<SalesOrderListScreen> createState() => _SalesOrderListScreenState();
}

class _SalesOrderListScreenState extends ConsumerState<SalesOrderListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    listenNearEnd(_scrollController, () => ref.read(salesOrderListProvider.notifier).loadMore());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(salesOrderListProvider);
    try {
      await ref.read(salesOrderListProvider.future);
    } on Failure {
      // Shown by the error state of salesOrderListProvider.
    }
  }

  Future<void> _pickCustomerFilter() async {
    final c = await pickCustomer(context, title: context.l10n.ordersFilterCustomerPick);
    if (c != null) ref.read(salesOrderFiltersProvider.notifier).setCustomer(c.id, c.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final orders = ref.watch(salesOrderListProvider);
    final filter = ref.watch(salesOrderFiltersProvider);
    // The customer picker lists GET /customers, which needs customers.view.
    // Without it the picker isn't offered; a filter already set still shows,
    // and can still be cleared.
    final canPickCustomer = ref.hasPermission(Permissions.customersView);
    final filtered = filter.status != null || filter.customerId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ordersTitle),
        actions: const [SettingsAction()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.md),
              children: [
                if (filter.customerId == null && canPickCustomer)
                  ActionChip(
                    key: const Key('order_filter_customer'),
                    avatar: const Icon(Icons.person_search_outlined, size: 18),
                    label: Text(l10n.ordersFilterCustomerClear),
                    onPressed: _pickCustomerFilter,
                  )
                else if (filter.customerId != null)
                  InputChip(
                    key: const Key('order_filter_customer'),
                    avatar: const Icon(Icons.person_outline, size: 18),
                    label: Text(filter.customerName ?? l10n.orderCustomerFallback('${filter.customerId}')),
                    onPressed: canPickCustomer ? _pickCustomerFilter : null,
                    onDeleted: () => ref.read(salesOrderFiltersProvider.notifier).clearCustomer(),
                  ),
                const SizedBox(width: AppSpacing.sm),
                ChoiceChip(
                  key: const Key('order_filter_status_all'),
                  label: Text(l10n.ordersFilterStatusAll),
                  selected: filter.status == null,
                  onSelected: (_) => ref.read(salesOrderFiltersProvider.notifier).setStatus(null),
                ),
                for (final s in OrderStatus.values) ...[
                  const SizedBox(width: AppSpacing.sm),
                  ChoiceChip(
                    key: Key('order_filter_status_${s.name}'),
                    avatar: Icon(s.icon, size: 18),
                    label: Text(s.label(context)),
                    selected: filter.status == s,
                    onSelected: (_) => ref.read(salesOrderFiltersProvider.notifier).setStatus(s),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ref.hasPermission(Permissions.salesOrdersCreate)
          ? FloatingActionButton.extended(
              heroTag: 'order_fab',
              onPressed: () => context.pushNamed(AppRoutes.salesOrderCreate),
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(l10n.ordersTitle),
            )
          : null,
      body: orders.when(
        skipLoadingOnReload: true,
        loading: () => const SkeletonList(),
        error: (e, _) => RefreshableView(
          onRefresh: _refresh,
          child: ErrorView(message: errorMessage(context, e), onRetry: () => ref.invalidate(salesOrderListProvider)),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return RefreshableView(
              onRefresh: _refresh,
              child: EmptyView(
                icon: filtered ? Icons.filter_alt_off_outlined : Icons.receipt_long_outlined,
                message: filtered ? l10n.ordersEmptyForFilter : l10n.ordersEmptyHint,
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
                if (i == state.items.length) {
                  return PagedListFooter(
                    state: state,
                    onLoadMore: () => ref.read(salesOrderListProvider.notifier).loadMore(),
                    totalLabel: (n) => l10n.ordersCount(n),
                  );
                }
                final o = state.items[i];
                return PressEffect(
                  child: SalesOrderTile(
                    order: o,
                    onTap: () =>
                        context.pushNamed(AppRoutes.salesOrderDetail, pathParameters: {'id': '${o.id}'}),
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

class SalesOrderTile extends StatelessWidget {
  const SalesOrderTile({super.key, required this.order, this.onTap});

  final SalesOrder order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      title: Text(order.orderNumber, style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
      subtitle: Text(
        '${order.customer?.name ?? context.l10n.orderCustomerFallback('${order.customerId}')} '
        '· ${formatDateTime(order.createdAt)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(formatRupiah(order.totalAmount), style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          OrderStatusBadge(status: order.status),
        ],
      ),
    );
  }
}
