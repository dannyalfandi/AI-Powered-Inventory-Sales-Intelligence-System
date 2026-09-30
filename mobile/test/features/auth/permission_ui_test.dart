import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_providers.dart';
import 'package:inventory_intel/features/category/presentation/screens/category_list_screen.dart';
import 'package:inventory_intel/features/customer/presentation/providers/customer_providers.dart';
import 'package:inventory_intel/features/customer/presentation/screens/customer_list_screen.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:inventory_intel/features/inventory/presentation/screens/product_stock_screen.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_providers.dart';
import 'package:inventory_intel/features/product/presentation/screens/product_list_screen.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_providers.dart';
import 'package:inventory_intel/features/sales_order/presentation/screens/sales_order_detail_screen.dart';
import 'package:inventory_intel/features/sales_order/presentation/screens/sales_order_list_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/auth_fixtures.dart';
import '../../helpers/category_fixtures.dart';
import '../../helpers/customer_fixtures.dart';
import '../../helpers/inventory_fixtures.dart';
import '../../helpers/l10n_harness.dart';
import '../../helpers/product_fixtures.dart';
import '../../helpers/sales_order_fixtures.dart';

// The rule under test: an action the user may not perform is not on screen
// at all — no FAB, no swipe, no button, no tap into an edit form — rather
// than shown disabled with no reason. (The backend enforces it anyway.)

Future<void> pump(WidgetTester tester, Widget screen, List<Override> overrides) async {
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, retry: (_, _) => null, child: localizedApp(home: screen)),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    registerProductFallbacks();
    registerCategoryFallbacks();
    registerCustomerFallbacks();
    registerSalesOrderFallbacks();
    registerInventoryFallbacks();
  });

  group('products list', () {
    late MockProductRepository repo;
    setUp(() {
      repo = MockProductRepository();
      when(() => repo.getProducts(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => productPage([product(1, name: 'Kopi')]));
    });

    testWidgets('Staff: no "add" button, rows do not swipe to delete', (tester) async {
      await pump(tester, const ProductListScreen(), [productRepositoryProvider.overrideWithValue(repo), signedInAs(staff)]);

      expect(find.text('Kopi'), findsOneWidget, reason: 'viewing is allowed');
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(Dismissible), findsNothing);
    });

    testWidgets('Super Admin: both are there', (tester) async {
      await pump(tester, const ProductListScreen(), [productRepositoryProvider.overrideWithValue(repo), signedInAs(superAdmin)]);

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(Dismissible), findsOneWidget);
    });

    testWidgets('delete without create: swipe yes, "add" no (each permission on its own)', (tester) async {
      await pump(tester, const ProductListScreen(), [
        productRepositoryProvider.overrideWithValue(repo),
        signedInAs(userWith({Permissions.productsView, Permissions.productsDelete})),
      ]);

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(Dismissible), findsOneWidget);
    });
  });

  group('categories list', () {
    late MockCategoryRepository repo;
    setUp(() {
      repo = MockCategoryRepository();
      when(() => repo.getCategories(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => categoryPage([category(1, name: 'Minuman')]));
    });

    ListTile row(WidgetTester tester) => tester.widget<ListTile>(find.ancestor(of: find.text('Minuman'), matching: find.byType(ListTile)));

    testWidgets('Staff: no add, no swipe-delete, and the row does not open the edit form', (tester) async {
      await pump(tester, const CategoryListScreen(), [categoryRepositoryProvider.overrideWithValue(repo), signedInAs(staff)]);

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(Dismissible), findsNothing);
      expect(row(tester).onTap, isNull);
    });

    testWidgets('Super Admin: all three', (tester) async {
      await pump(tester, const CategoryListScreen(), [categoryRepositoryProvider.overrideWithValue(repo), signedInAs(superAdmin)]);

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(Dismissible), findsOneWidget);
      expect(row(tester).onTap, isNotNull);
    });
  });

  group('customers list', () {
    late MockCustomerRepository repo;
    setUp(() {
      repo = MockCustomerRepository();
      when(() => repo.getCustomers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => customerPage([customer(1, name: 'Toko Budi')]));
    });

    ListTile row(WidgetTester tester) =>
        tester.widget<ListTile>(find.ancestor(of: find.text('Toko Budi'), matching: find.byType(ListTile)));

    testWidgets('Staff: no add, no swipe-delete, no edit', (tester) async {
      await pump(tester, const CustomerListScreen(), [customerRepositoryProvider.overrideWithValue(repo), signedInAs(staff)]);

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(Dismissible), findsNothing);
      expect(row(tester).onTap, isNull);
    });

    testWidgets('edit only: the row opens the form, nothing else', (tester) async {
      await pump(tester, const CustomerListScreen(), [
        customerRepositoryProvider.overrideWithValue(repo),
        signedInAs(userWith({Permissions.customersView, Permissions.customersUpdate})),
      ]);

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(Dismissible), findsNothing);
      expect(row(tester).onTap, isNotNull);
    });
  });

  group('sales orders', () {
    late MockSalesOrderRepository repo;
    setUp(() {
      repo = MockSalesOrderRepository();
      when(() => repo.getOrders(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
            status: any(named: 'status'),
            customerId: any(named: 'customerId'),
          )).thenAnswer((_) async => orderPage([salesOrder(1)]));
    });

    List<Override> as(Set<String> permissions) => [
      salesOrderRepositoryProvider.overrideWithValue(repo),
      inventoryRepositoryProvider.overrideWithValue(MockInventoryRepository()),
      signedInAs(userWith({Permissions.salesOrdersView, ...permissions})),
    ];

    Finder action(OrderStatus s) => find.byKey(Key('order_action_${s.name}'));

    testWidgets('list: "new order" only with sales_orders.create', (tester) async {
      await pump(tester, const SalesOrderListScreen(), as({}));
      expect(find.byType(FloatingActionButton), findsNothing);

      await pump(tester, const SalesOrderListScreen(), as({Permissions.salesOrdersCreate}));
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('pending order, Staff: Confirm and Cancel', (tester) async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
      await pump(tester, const SalesOrderDetailScreen(orderId: 1), [
        salesOrderRepositoryProvider.overrideWithValue(repo),
        inventoryRepositoryProvider.overrideWithValue(MockInventoryRepository()),
        signedInAs(staff),
      ]);

      expect(action(OrderStatus.confirmed), findsOneWidget);
      expect(action(OrderStatus.cancelled), findsOneWidget);
    });

    testWidgets('pending order, may cancel but not confirm: only Cancel', (tester) async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
      await pump(tester, const SalesOrderDetailScreen(orderId: 1), as({Permissions.salesOrdersCancel}));

      expect(action(OrderStatus.confirmed), findsNothing);
      expect(action(OrderStatus.cancelled), findsOneWidget);
    });

    testWidgets('confirmed order, may confirm only: nothing it can do, so no action bar at all', (tester) async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1, status: OrderStatus.confirmed));
      await pump(tester, const SalesOrderDetailScreen(orderId: 1), as({Permissions.salesOrdersConfirm}));

      expect(action(OrderStatus.shipped), findsNothing);
      expect(action(OrderStatus.cancelled), findsNothing);
      expect(find.byKey(const Key('order_no_actions')), findsNothing,
          reason: '"no more actions" is for final orders, not for a lack of permission');
    });

    testWidgets('view only: the order is readable, no buttons', (tester) async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
      await pump(tester, const SalesOrderDetailScreen(orderId: 1), as({}));

      expect(find.text('Budi Santoso'), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('a final order still says so, whatever the permissions', (tester) async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1, status: OrderStatus.shipped));
      await pump(tester, const SalesOrderDetailScreen(orderId: 1), as({}));

      expect(find.byKey(const Key('order_no_actions')), findsOneWidget);
    });
  });

  group('product detail (stock)', () {
    late MockProductRepository products;
    late MockInventoryRepository inventoryRepo;
    setUp(() {
      products = MockProductRepository();
      inventoryRepo = MockInventoryRepository();
      when(() => products.getProductById(1)).thenAnswer((_) async => product(1, name: 'Kopi'));
      when(() => inventoryRepo.getInventory(1)).thenAnswer((_) async => inventory(1));
      when(() => inventoryRepo.getMovements(1, page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => pageOf([movement(1)]));
    });

    List<Override> as(AuthUser user) => [
      productRepositoryProvider.overrideWithValue(products),
      inventoryRepositoryProvider.overrideWithValue(inventoryRepo),
      signedInAs(user),
    ];

    testWidgets('Staff: no edit button, no "record movement"', (tester) async {
      await pump(tester, const ProductStockScreen(productId: 1), as(staff));

      expect(find.byKey(const Key('edit_product_button')), findsNothing);
      expect(find.byKey(const Key('record_movement_button')), findsNothing);
    });

    testWidgets('a stock clerk (record_movement only): the movement button, not edit', (tester) async {
      await pump(
        tester,
        const ProductStockScreen(productId: 1),
        as(userWith({Permissions.productsView, Permissions.inventoryView, Permissions.inventoryRecordMovement})),
      );

      expect(find.byKey(const Key('edit_product_button')), findsNothing);
      expect(find.byKey(const Key('record_movement_button')), findsOneWidget);
    });

    testWidgets('Super Admin: both', (tester) async {
      await pump(tester, const ProductStockScreen(productId: 1), as(superAdmin));

      expect(find.byKey(const Key('edit_product_button')), findsOneWidget);
      expect(find.byKey(const Key('record_movement_button')), findsOneWidget);
    });
  });
}
