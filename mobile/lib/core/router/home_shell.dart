import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/dashboard/presentation/providers/dashboard_data_providers.dart';
import '../../features/sales_order/presentation/providers/sales_order_list_provider.dart';
import '../../shared/theme/app_motion.dart';
import '../l10n/l10n.dart';
import 'home_tabs.dart';

/// Main screen with bottom navigation: Dashboard, Produk, Kategori, Pelanggan,
/// Pesanan — **only the tabs the user's role may open** ([HomeTab]). Each tab
/// keeps its own navigation stack and scroll position. "Stok Menipis" is not
/// a tab: it is opened from the dashboard card.
///
/// The router enforces the same rule (a hidden tab's route redirects), so a
/// tab can't be reached by deep link either. When permissions change (they are
/// refreshed on resume and after a 403), both follow at once.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = HomeTab.allowedFor(ref.watch(currentUserProvider));
    final current = HomeTab.values[shell.currentIndex];
    // -1 only for the frame before the router moves off a tab that was just
    // taken away; the first tab is the best stand-in.
    final selected = tabs.indexOf(current).clamp(0, tabs.isEmpty ? 0 : tabs.length - 1);

    return Scaffold(
      // The fade between tabs happens inside the branch container
      // ([FadingBranchContainer]): wrapping `shell` in an AnimatedSwitcher put
      // the shell — which has a GlobalKey — in two places during the
      // cross-fade ("Duplicate GlobalKey" on every tab switch).
      body: shell,
      // A bar needs two destinations; with one tab there is nothing to switch.
      bottomNavigationBar: tabs.length < 2
          ? null
          : NavigationBar(
              selectedIndex: selected,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (i) {
                final tab = tabs[i];
                // Data changed elsewhere (stock movements, status changes on the
                // order detail) — show fresh data when the tab is opened.
                if (tab == HomeTab.dashboard && tab != current) {
                  ref.invalidate(dashboardSummaryProvider);
                  ref.invalidate(dashboardSalesTrendProvider);
                  ref.invalidate(dashboardTopProductsProvider);
                  ref.invalidate(dashboardCategoryBreakdownProvider);
                  ref.invalidate(dashboardLowStockCountProvider);
                }
                if (tab == HomeTab.salesOrders && tab != current) ref.invalidate(salesOrderListProvider);
                shell.goBranch(tab.branch, initialLocation: tab == current);
              },
              destinations: [for (final tab in tabs) _destinationOf(context, tab)],
            ),
    );
  }
}

/// The branch navigators, one per tab, with the newly selected tab fading
/// in (no fade with reduce motion). Every child keeps its place and its
/// wrapper on every build — only the animation each one listens to changes —
/// so no branch is ever re-parented and each keeps its stack and scroll.
class FadingBranchContainer extends StatefulWidget {
  const FadingBranchContainer({super.key, required this.currentIndex, required this.children});

  final int currentIndex;
  final List<Widget> children;

  @override
  State<FadingBranchContainer> createState() => _FadingBranchContainerState();
}

class _FadingBranchContainerState extends State<FadingBranchContainer> with SingleTickerProviderStateMixin {
  late final _fade = AnimationController(vsync: this, value: 1);

  @override
  void didUpdateWidget(FadingBranchContainer old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _fade.duration = AppMotion.durationOf(context, AppMotion.fast);
      _fade.forward(from: _fade.duration == Duration.zero ? 1 : 0);
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.currentIndex,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          TickerMode(
            enabled: i == widget.currentIndex,
            child: FadeTransition(
              opacity: i == widget.currentIndex ? _fade : kAlwaysCompleteAnimation,
              child: widget.children[i],
            ),
          ),
      ],
    );
  }
}

NavigationDestination _destinationOf(BuildContext context, HomeTab tab) {
  final l10n = context.l10n;
  return switch (tab) {
    HomeTab.dashboard => NavigationDestination(
      key: const Key('tab_dashboard'),
      icon: const Icon(Icons.dashboard_outlined),
      selectedIcon: const Icon(Icons.dashboard),
      label: l10n.navDashboard,
    ),
    HomeTab.products => NavigationDestination(
      key: const Key('tab_products'),
      icon: const Icon(Icons.inventory_2_outlined),
      selectedIcon: const Icon(Icons.inventory_2),
      label: l10n.navProducts,
    ),
    HomeTab.categories => NavigationDestination(
      key: const Key('tab_categories'),
      icon: const Icon(Icons.label_outline),
      selectedIcon: const Icon(Icons.label),
      label: l10n.navCategories,
    ),
    HomeTab.customers => NavigationDestination(
      key: const Key('tab_customers'),
      icon: const Icon(Icons.people_outline),
      selectedIcon: const Icon(Icons.people),
      label: l10n.navCustomers,
    ),
    HomeTab.salesOrders => NavigationDestination(
      key: const Key('tab_sales_orders'),
      icon: const Icon(Icons.receipt_long_outlined),
      selectedIcon: const Icon(Icons.receipt_long),
      label: l10n.navOrders,
    ),
  };
}
