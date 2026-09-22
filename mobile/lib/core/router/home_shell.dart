import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/providers/dashboard_data_providers.dart';
import '../l10n/l10n.dart';
import '../../features/sales_order/presentation/providers/sales_order_list_provider.dart';

/// Main screen with bottom navigation: Dashboard, Produk, Kategori, Pelanggan,
/// Pesanan. Each tab keeps its own navigation stack and scroll position.
/// "Stok Menipis" is not a tab: it is opened from the dashboard card.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  // Branch order must match the StatefulShellRoute in app_router.dart.
  static const dashboardBranch = 0;
  static const salesOrdersBranch = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          // Data changed elsewhere (stock movements, status changes on the
          // order detail) — show fresh data when the tab is opened.
          if (index == dashboardBranch && index != shell.currentIndex) {
            ref.invalidate(dashboardSummaryProvider);
            ref.invalidate(dashboardSalesTrendProvider);
            ref.invalidate(dashboardTopProductsProvider);
            ref.invalidate(dashboardCategoryBreakdownProvider);
            ref.invalidate(dashboardLowStockCountProvider);
          }
          if (index == salesOrdersBranch && index != shell.currentIndex) ref.invalidate(salesOrderListProvider);
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: context.l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: context.l10n.navProducts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.label_outline),
            selectedIcon: const Icon(Icons.label),
            label: context.l10n.navCategories,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: context.l10n.navCustomers,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: context.l10n.navOrders,
          ),
        ],
      ),
    );
  }
}
