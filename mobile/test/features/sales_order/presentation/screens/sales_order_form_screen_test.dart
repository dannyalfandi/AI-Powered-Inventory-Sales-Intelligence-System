import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/customer/presentation/providers/customer_providers.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_providers.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_providers.dart';
import 'package:inventory_intel/features/sales_order/presentation/screens/sales_order_form_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/customer_fixtures.dart';
import '../../../../helpers/product_fixtures.dart';
import '../../../../helpers/sales_order_fixtures.dart';
import '../../../../helpers/l10n_harness.dart';

void main() {
  late MockSalesOrderRepository orders;
  late MockProductRepository products;
  late MockCustomerRepository customers;

  setUpAll(() {
    registerSalesOrderFallbacks();
    registerProductFallbacks();
  });

  setUp(() {
    orders = MockSalesOrderRepository();
    products = MockProductRepository();
    customers = MockCustomerRepository();
    when(() => products.getProducts(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
          search: any(named: 'search'),
        )).thenAnswer((_) async => productPage([
          product(10, name: 'Kopi Arabica', sku: 'KOPI-1', price: 45000),
          product(20, name: 'Teh Melati', sku: 'TEH-1', price: 10000),
        ]));
    stubCustomers(customers, [customer(7, name: 'Budi Santoso', email: 'budi@example.com')]);
    when(() => orders.getOrders(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
          status: any(named: 'status'),
          customerId: any(named: 'customerId'),
        )).thenAnswer((_) async => orderPage([]));
  });

  Widget app() => ProviderScope(
        overrides: [
          salesOrderRepositoryProvider.overrideWithValue(orders),
          productRepositoryProvider.overrideWithValue(products),
          customerRepositoryProvider.overrideWithValue(customers),
        ],
        retry: (_, _) => null,
        child: localizedApp(home: const SalesOrderFormScreen()),
      );

  Future<void> pickCustomer(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('order_form_customer')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();
  }

  Future<void> addProduct(WidgetTester tester, String name) async {
    await tester.tap(find.byKey(const Key('order_form_add_product')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('order_form_submit')));
    await tester.pumpAndSettle();
  }

  String total(WidgetTester tester) => tester.widget<Text>(find.byKey(const Key('order_form_total'))).data!;

  testWidgets('running total follows products and quantities', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(total(tester), 'Rp 0');

    await addProduct(tester, 'Kopi Arabica');
    expect(total(tester), 'Rp 45.000', reason: 'new line starts at quantity 1');
    await addProduct(tester, 'Teh Melati');
    await tester.enterText(find.byKey(const Key('order_line_qty_0')), '3');
    await tester.enterText(find.byKey(const Key('order_line_qty_1')), '5');
    await tester.pump();
    expect(total(tester), 'Rp 185.000');

    await tester.tap(find.byKey(const Key('order_line_remove_0')));
    await tester.pumpAndSettle();
    expect(total(tester), 'Rp 50.000');
  });

  testWidgets('a product already in the order is disabled in the picker', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await addProduct(tester, 'Kopi Arabica');

    await tester.tap(find.byKey(const Key('order_form_add_product')));
    await tester.pumpAndSettle();

    final kopi = tester.widget<ListTile>(find.ancestor(of: find.text('Kopi Arabica').last, matching: find.byType(ListTile)));
    expect(kopi.enabled, isFalse);
    expect(find.textContaining(l10nOf(tester).orderFormProductAlreadyAdded), findsOneWidget);
    await tester.tap(find.text('Kopi Arabica').last, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10)); // dismiss the sheet
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('order_line_qty_1')), findsNothing, reason: 'still one line');
  });

  testWidgets('quantity 0 and a missing customer are rejected before calling the API', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await addProduct(tester, 'Kopi Arabica');
    await tester.enterText(find.byKey(const Key('order_line_qty_0')), '0');

    await submit(tester);

    expect(find.text(l10nOf(tester).orderFormPickCustomer), findsWidgets);
    expect(find.text(l10nOf(tester).validationQuantityPositive), findsOneWidget);
    verifyNever(() => orders.createOrder(any()));
  });

  testWidgets('an order without products is rejected', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await pickCustomer(tester);

    await submit(tester);

    expect(find.text(l10nOf(tester).validationItemsRequired), findsOneWidget);
    verifyNever(() => orders.createOrder(any()));
  });

  testWidgets('valid order sends customer, products and quantities', (tester) async {
    // Fail after capturing, so the form stays (success navigates via GoRouter).
    when(() => orders.createOrder(any())).thenThrow(const NetworkFailure('offline'));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await pickCustomer(tester);
    await addProduct(tester, 'Kopi Arabica');
    await addProduct(tester, 'Teh Melati');
    await tester.enterText(find.byKey(const Key('order_line_qty_1')), '5');

    await submit(tester);

    final sent = verify(() => orders.createOrder(captureAny())).captured.single as SalesOrderInput;
    expect(sent, const SalesOrderInput(customerId: 7, items: [
      OrderLineInput(productId: 10, quantity: 1),
      OrderLineInput(productId: 20, quantity: 5),
    ]));
    expect(find.text(l10nOf(tester).orderCreateFailed(l10nOf(tester).networkUnreachable)), findsOneWidget);
  });

  testWidgets('backend 422 per item is shown under that line', (tester) async {
    when(() => orders.createOrder(any())).thenThrow(
      const ValidationFailure('x', messages: {'items[1].product_id': 'product 20 does not exist'}),
    );
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await pickCustomer(tester);
    await addProduct(tester, 'Kopi Arabica');
    await addProduct(tester, 'Teh Melati');

    await submit(tester);

    final qty1 = tester.widget<TextField>(find.descendant(
      of: find.byKey(const Key('order_line_qty_1')),
      matching: find.byType(TextField),
    ));
    expect(qty1.decoration?.errorText, 'product 20 does not exist');
  });
}
