import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/providers/low_stock_list_provider.dart';

/// Main screen with bottom navigation: Produk, Kategori, Stok Menipis. Each
/// tab keeps its own navigation stack and scroll position.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const lowStockBranch = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) {
          // Stock changes elsewhere (movements, new products) — show fresh data.
          if (index == lowStockBranch) ref.invalidate(lowStockListProvider);
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
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning_amber),
            label: 'Stok Menipis',
          ),
        ],
      ),
    );
  }
}
