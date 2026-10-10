import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:inventory_intel/core/router/app_router.dart';
import 'package:inventory_intel/core/router/home_tabs.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_providers.dart';
import 'package:inventory_intel/features/auth/presentation/screens/no_access_screen.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_providers.dart';
import 'package:inventory_intel/features/customer/presentation/providers/customer_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:inventory_intel/features/inventory/presentation/screens/low_stock_screen.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_providers.dart';
import 'package:inventory_intel/features/product/presentation/screens/product_list_screen.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_providers.dart';
import 'package:inventory_intel/features/settings/presentation/screens/settings_screen.dart';
import 'package:inventory_intel/shared/widgets/settings_action.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/auth_fixtures.dart';
import '../../helpers/category_fixtures.dart';
import '../../helpers/customer_fixtures.dart';
import '../../helpers/dashboard_fixtures.dart';
import '../../helpers/inventory_fixtures.dart';
import '../../helpers/l10n_harness.dart';
import '../../helpers/product_fixtures.dart';
import '../../helpers/sales_order_fixtures.dart';

// Tabs and Dashboard sections follow the *.view permissions the backend
// demands for their endpoints (backend/internal/router/router.go), through
// the real router and the real shell.

/// The "Gudang" role of the demo: products.view only.
final gudang = userWith({Permissions.productsView});

/// A role with no view permission at all.
final nothing = userWith({Permissions.usersCreate});

const _allTabs = ['tab_dashboard', 'tab_products', 'tab_categories', 'tab_customers', 'tab_sales_orders'];

void main() {
  setUpAll(() {
    registerDashboardFallbacks();
    registerSalesOrderFallbacks();
  });

  late GoRouter router;
  late MockDashboardRepository dashboard;
  late MockProductRepository products;
  late MockCategoryRepository categories;
  late MockCustomerRepository customers;
  late MockSalesOrderRepository orders;

  Future<void> start(WidgetTester tester, AuthUser user, {String? at, MockInventoryRepository? inventory}) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final auth = MockAuthRepository();
    when(() => auth.hasSession).thenReturn(true);
    when(() => auth.currentUser()).thenAnswer((_) async => user);
    dashboard = MockDashboardRepository();
    stubDashboard(dashboard);
    products = MockProductRepository();
    when(() => products.getProducts(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
        .thenAnswer((_) async => productPage([]));
    categories = MockCategoryRepository();
    when(() => categories.getCategories(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
        .thenAnswer((_) async => const PageResult(items: [], page: 1, pageSize: 20, total: 0));
    customers = MockCustomerRepository();
    when(() => customers.getCustomers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
        .thenAnswer((_) async => const PageResult(items: [], page: 1, pageSize: 20, total: 0));
    orders = MockSalesOrderRepository();
    when(() => orders.getOrders(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
          status: any(named: 'status'),
          customerId: any(named: 'customerId'),
        )).thenAnswer((_) async => const PageResult(items: [], page: 1, pageSize: 20, total: 0));

    final container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        dashboardRepositoryProvider.overrideWithValue(dashboard),
        productRepositoryProvider.overrideWithValue(products),
        categoryRepositoryProvider.overrideWithValue(categories),
        customerRepositoryProvider.overrideWithValue(customers),
        salesOrderRepositoryProvider.overrideWithValue(orders),
        if (inventory != null) inventoryRepositoryProvider.overrideWithValue(inventory),
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      retry: (_, _) => null,
    );
    router = container.read(appRouterProvider);
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: localizedApp(routerConfig: router)));
    await tester.pumpAndSettle();
    if (at != null) {
      router.go(at);
      await tester.pumpAndSettle();
    }
  }

  String location() => router.routerDelegate.currentConfiguration.uri.path;

  List<String> visibleTabs() => [
    for (final key in _allTabs)
      if (find.byKey(Key(key)).evaluate().isNotEmpty) key,
  ];

  group('tab visibility (and where the app opens)', () {
    final cases = <(String, AuthUser, List<String>, String)>[
      ('Super Admin: every tab', superAdmin, _allTabs, '/'),
      ('Staff: every tab (it views everything)', staff, _allTabs, '/'),
      ('products.view + customers.view: those two, opening on Products',
          userWith({Permissions.productsView, Permissions.customersView}), ['tab_products', 'tab_customers'], '/products'),
      ('analytics.insights alone still opens the Dashboard',
          userWith({Permissions.analyticsInsights, Permissions.salesOrdersView}), ['tab_dashboard', 'tab_sales_orders'], '/'),
      // One tab: nothing to switch, so no bar at all.
      ('Gudang (products.view only): Products, without a bar', gudang, [], '/products'),
    ];
    for (final (name, user, tabs, home) in cases) {
      testWidgets(name, (tester) async {
        await start(tester, user);
        expect(location(), home);
        expect(visibleTabs(), tabs);
        expect(find.byType(NavigationBar), tabs.isEmpty ? findsNothing : findsOneWidget);
      });
    }

    testWidgets('Gudang can still reach Settings: every tab has the button', (tester) async {
      await start(tester, gudang);
      expect(find.byType(ProductListScreen), findsOneWidget);
      await tester.tap(find.byType(SettingsAction));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('no view permission at all: a friendly screen with Settings and Sign out', (tester) async {
      await start(tester, nothing);
      expect(location(), noAccessPath);
      expect(find.byType(NoAccessScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text(l10nOf(tester).noAccessTitle), findsOneWidget);

      await tester.tap(find.byKey(const Key('no_access_settings')));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      verifyZeroInteractions(dashboard);
      verifyZeroInteractions(products);
    });

    testWidgets('switching tabs goes to the right branch when some are hidden', (tester) async {
      await start(tester, userWith({Permissions.productsView, Permissions.customersView}));
      await tester.tap(find.byKey(const Key('tab_customers')));
      await tester.pumpAndSettle();
      expect(location(), '/customers');
      await tester.tap(find.byKey(const Key('tab_products')));
      await tester.pumpAndSettle();
      expect(location(), '/products');
    });
  });

  group('deep links to a tab (or a tab\'s screen) the role may not open', () {
    testWidgets('Gudang: everything else lands on Products', (tester) async {
      await start(tester, gudang);
      for (final path in [
        '/',
        '/categories',
        '/customers',
        '/sales-orders',
        '/categories/new',
        '/customers/3/edit',
        '/sales-orders/new',
        '/sales-orders/5',
        '/low-stock', // GET /inventory/low-stock needs inventory.view
        noAccessPath, // has a tab, so not "no access"
      ]) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(location(), '/products', reason: path);
      }
    });

    testWidgets('no view permission: every tab lands on the no-access screen', (tester) async {
      await start(tester, nothing);
      for (final tab in HomeTab.values) {
        router.go(tab.path);
        await tester.pumpAndSettle();
        expect(location(), noAccessPath, reason: tab.path);
      }
    });

    testWidgets('Staff: the no-access screen sends it home', (tester) async {
      await start(tester, staff, at: noAccessPath);
      expect(location(), '/');
    });
  });

  group('Dashboard sections: only what the permissions allow is requested', () {
    void expectAnalyticsView(bool called) {
      for (final call in <void Function()>[
        () => dashboard.getSummary(any()),
        () => dashboard.getSalesTrend(any(), any()),
        () => dashboard.getTopProducts(any(), limit: any(named: 'limit')),
        () => dashboard.getCategoryBreakdown(any()),
        () => dashboard.getLowStockAlertCount(),
      ]) {
        called ? verify(call).called(greaterThan(0)) : verifyNever(call);
      }
    }

    void expectForecast(bool called) {
      Future<Object> call() =>
          dashboard.getForecast(any(), limit: any(named: 'limit'), horizonDays: any(named: 'horizonDays'));
      called ? verify(call).called(greaterThan(0)) : verifyNever(call);
    }

    void expectInsights(bool called) {
      Future<Object> call() => dashboard.getInsights(any(), limit: any(named: 'limit'));
      called ? verify(call).called(greaterThan(0)) : verifyNever(call);
    }

    final cases = <(String, AuthUser, bool, bool, bool)>[
      ('Staff: every section', staff, true, true, true),
      ('Super Admin: every section', superAdmin, true, true, true),
      ('analytics.view only: no forecast, no insights', userWith({Permissions.analyticsView}), true, false, false),
      ('analytics.insights only: just insights', userWith({Permissions.analyticsInsights}), false, false, true),
      ('analytics.forecast only: just the forecast', userWith({Permissions.analyticsForecast}), false, true, false),
    ];
    for (final (name, user, view, forecast, insights) in cases) {
      testWidgets(name, (tester) async {
        tester.view.physicalSize = const Size(1200, 6000);
        addTearDown(tester.view.resetPhysicalSize);
        await start(tester, user);
        expect(find.byType(DashboardScreen), findsOneWidget);
        final l10n = l10nOf(tester);

        expectAnalyticsView(view);
        expectForecast(forecast);
        expectInsights(insights);
        expect(find.text(l10n.dashboardSummaryTitle), view ? findsOneWidget : findsNothing);
        expect(find.text(l10n.dashboardForecastTitle), forecast ? findsOneWidget : findsNothing);
        expect(find.text(l10n.dashboardInsightsTitle), insights ? findsOneWidget : findsNothing);
      });
    }

    testWidgets('Gudang: the Dashboard is hidden and nothing in analytics is called', (tester) async {
      await start(tester, gudang);
      expect(find.byType(DashboardScreen), findsNothing);
      verifyZeroInteractions(dashboard);
    });

    testWidgets('the low-stock card opens its list only with inventory.view', (tester) async {
      tester.view.physicalSize = const Size(1200, 6000);
      addTearDown(tester.view.resetPhysicalSize);
      await start(tester, userWith({Permissions.analyticsView}));
      await tester.tap(find.text(l10nOf(tester).dashboardLowStockTitle));
      await tester.pumpAndSettle();
      expect(find.byType(LowStockScreen), findsNothing, reason: 'no inventory.view: the card is not a link');
    });

    testWidgets('…and with inventory.view it does', (tester) async {
      tester.view.physicalSize = const Size(1200, 6000);
      addTearDown(tester.view.resetPhysicalSize);
      final inventory = MockInventoryRepository();
      when(() => inventory.getLowStock(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => const PageResult(items: [], page: 1, pageSize: 20, total: 0));
      await start(tester, userWith({Permissions.analyticsView, Permissions.inventoryView}), inventory: inventory);
      await tester.tap(find.text(l10nOf(tester).dashboardLowStockTitle));
      await tester.pumpAndSettle();
      expect(find.byType(LowStockScreen), findsOneWidget);
    });
  });

  group('Orders tab', () {
    testWidgets('the customer filter (GET /customers) needs customers.view', (tester) async {
      await start(tester, userWith({Permissions.salesOrdersView}));
      expect(location(), '/sales-orders');
      expect(find.byKey(const Key('order_filter_customer')), findsNothing);
    });

    testWidgets('with customers.view the filter is there', (tester) async {
      await start(tester, userWith({Permissions.salesOrdersView, Permissions.customersView}), at: '/sales-orders');
      expect(find.byKey(const Key('order_filter_customer')), findsOneWidget);
    });
  });
}
