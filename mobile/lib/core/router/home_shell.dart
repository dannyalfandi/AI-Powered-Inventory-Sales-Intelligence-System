import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/providers/low_stock_list_provider.dart';
import '../../features/sales_order/presentation/providers/sales_order_list_provider.dart';

/// Main screen with bottom navigation: Produk, Kategori, Pelanggan, Pesanan,
/// Stok Menipis. Each tab keeps its own navigation stack and scroll position.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  // Branch order must match the StatefulShellRoute in app_router.dart.
  static const salesOrdersBranch = 3;
  static const lowStockBranch = 4;

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
          if (index == lowStockBranch) ref.invalidate(lowStockListProvider);
          if (index == salesOrdersBranch && index != shell.currentIndex) ref.invalidate(salesOrderListProvider);
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Produk',
          ),
          NavigationDestination(
            icon: Icon(Icons.label_outline),
            selectedIcon: Icon(Icons.label),
            label: 'Kategori',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Pelanggan',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning_amber),
            label: 'Stok Menipis',
          ),
        ],
      ),
    );
  }
}
