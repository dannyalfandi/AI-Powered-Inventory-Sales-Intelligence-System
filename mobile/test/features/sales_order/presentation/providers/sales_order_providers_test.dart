import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/low_stock_list_provider.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/order_form_provider.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_detail_provider.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_list_provider.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/customer_fixtures.dart';
import '../../../../helpers/inventory_fixtures.dart';
import '../../../../helpers/product_fixtures.dart';
import '../../../../helpers/sales_order_fixtures.dart';

void main() {
  late MockSalesOrderRepository repo;
  late MockInventoryRepository inventory;

  setUpAll(registerSalesOrderFallbacks);
  setUp(() {
    repo = MockSalesOrderRepository();
    inventory = MockInventoryRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer.test(
        overrides: [
          salesOrderRepositoryProvider.overrideWithValue(repo),
          inventoryRepositoryProvider.overrideWithValue(inventory),
        ],
        retry: (_, _) => null,
      );

  void stubList({OrderStatus? status, int? customerId, required List<SalesOrder> items}) {
    when(() => repo.getOrders(page: 1, pageSize: 20, status: status, customerId: customerId))
        .thenAnswer((_) async => orderPage(items));
  }

  group('salesOrderListProvider', () {
    test('filters by status and customer', () async {
      stubList(items: [salesOrder(1), salesOrder(2, status: OrderStatus.confirmed)]);
      stubList(status: OrderStatus.confirmed, items: [salesOrder(2, status: OrderStatus.confirmed)]);
      stubList(status: OrderStatus.confirmed, customerId: 7, items: []);
      final container = makeContainer();
      container.listen(salesOrderListProvider, (_, _) {});
      expect((await container.read(salesOrderListProvider.future)).items, hasLength(2));

      container.read(salesOrderFiltersProvider.notifier).setStatus(OrderStatus.confirmed);
      expect((await container.read(salesOrderListProvider.future)).items.single.id, 2);

      container.read(salesOrderFiltersProvider.notifier).setCustomer(7, 'Budi');
      expect((await container.read(salesOrderListProvider.future)).items, isEmpty);
      expect(container.read(salesOrderFiltersProvider).customerName, 'Budi');

      container.read(salesOrderFiltersProvider.notifier).clearCustomer();
      expect(container.read(salesOrderFiltersProvider).customerId, isNull);
    });

    test('loadMore keeps the filter', () async {
      when(() => repo.getOrders(page: 1, pageSize: 20, status: OrderStatus.pending, customerId: null))
          .thenAnswer((_) async => orderPage([salesOrder(2)], pageSize: 1, total: 2));
      when(() => repo.getOrders(page: 2, pageSize: 1, status: OrderStatus.pending, customerId: null))
          .thenAnswer((_) async => orderPage([salesOrder(1)], page: 2, pageSize: 1, total: 2));
      final container = makeContainer();
      container.listen(salesOrderListProvider, (_, _) {});
      container.read(salesOrderFiltersProvider.notifier).setStatus(OrderStatus.pending);
      await container.read(salesOrderListProvider.future);

      await container.read(salesOrderListProvider.notifier).loadMore();

      expect(container.read(salesOrderListProvider).requireValue.items.map((o) => o.id), [2, 1]);
    });
  });

  group('salesOrderDetailProvider.changeStatus', () {
    test('confirm shows the returned order and refreshes list and stock screens', () async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
      when(() => repo.changeStatus(1, OrderStatus.confirmed))
          .thenAnswer((_) async => salesOrder(1, status: OrderStatus.confirmed));
      stubList(items: [salesOrder(1)]);
      when(() => inventory.getLowStock(page: 1, pageSize: 20)).thenAnswer((_) async => pageOf([lowStockItem(10)]));
      final container = makeContainer();
      container.listen(salesOrderDetailProvider(1), (_, _) {});
      container.listen(salesOrderListProvider, (_, _) {});
      container.listen(lowStockListProvider, (_, _) {});
      await container.read(salesOrderDetailProvider(1).future);
      await container.read(salesOrderListProvider.future);
      await container.read(lowStockListProvider.future);

      await container.read(salesOrderDetailProvider(1).notifier).changeStatus(OrderStatus.confirmed);

      expect(container.read(salesOrderDetailProvider(1)).requireValue.status, OrderStatus.confirmed);
      await container.read(salesOrderListProvider.future);
      await container.read(lowStockListProvider.future);
      verify(() => repo.getOrders(page: 1, pageSize: 20, status: null, customerId: null)).called(2);
      verify(() => inventory.getLowStock(page: 1, pageSize: 20)).called(2);
    });

    test('ship does not refresh stock screens', () async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1, status: OrderStatus.confirmed));
      when(() => repo.changeStatus(1, OrderStatus.shipped))
          .thenAnswer((_) async => salesOrder(1, status: OrderStatus.shipped));
      when(() => inventory.getLowStock(page: 1, pageSize: 20)).thenAnswer((_) async => pageOf([lowStockItem(10)]));
      final container = makeContainer();
      container.listen(salesOrderDetailProvider(1), (_, _) {});
      container.listen(lowStockListProvider, (_, _) {});
      await container.read(salesOrderDetailProvider(1).future);
      await container.read(lowStockListProvider.future);

      await container.read(salesOrderDetailProvider(1).notifier).changeStatus(OrderStatus.shipped);

      await container.read(lowStockListProvider.future);
      verify(() => inventory.getLowStock(page: 1, pageSize: 20)).called(1);
    });

    test('short stock keeps the order and rethrows the per-item 422', () async {
      when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
      when(() => repo.changeStatus(1, OrderStatus.confirmed)).thenThrow(tehShortFailure);
      final container = makeContainer();
      container.listen(salesOrderDetailProvider(1), (_, _) {});
      await container.read(salesOrderDetailProvider(1).future);

      await expectLater(
        container.read(salesOrderDetailProvider(1).notifier).changeStatus(OrderStatus.confirmed),
        throwsA(isA<ValidationFailure>()),
      );

      expect(container.read(salesOrderDetailProvider(1)).requireValue.status, OrderStatus.pending);
      verify(() => repo.getOrderById(1)).called(1);
    });

    test('a status 422 (changed elsewhere) reloads the order', () async {
      var calls = 0;
      when(() => repo.getOrderById(1)).thenAnswer(
        (_) async => ++calls == 1 ? salesOrder(1) : salesOrder(1, status: OrderStatus.cancelled),
      );
      when(() => repo.changeStatus(1, OrderStatus.confirmed)).thenThrow(
        const ValidationFailure('x', messages: {'status': "an order that is CANCELLED can't change status anymore"}),
      );
      final container = makeContainer();
      container.listen(salesOrderDetailProvider(1), (_, _) {});
      await container.read(salesOrderDetailProvider(1).future);

      await expectLater(
        container.read(salesOrderDetailProvider(1).notifier).changeStatus(OrderStatus.confirmed),
        throwsA(isA<ValidationFailure>()),
      );

      expect((await container.read(salesOrderDetailProvider(1).future)).status, OrderStatus.cancelled);
    });
  });

  group('statusChangeErrorLines', () {
    final order = salesOrder(1);

    test('names the short item and translates the numbers', () {
      expect(statusChangeErrorLines(tehShortFailure, order), ['Teh Melati (TEH-1): stok tersedia 3, dibutuhkan 5.']);
    });

    test('one line per problem item, including deleted products', () {
      final lines = statusChangeErrorLines(
        const ValidationFailure('x', messages: {
          'items[0].product_id': 'product 10 (KOPI-1) is no longer available',
          'items[1].quantity': 'insufficient stock for product 20 (TEH-1): 0 available, 5 requested',
        }),
        order,
      );
      expect(lines, [
        'Kopi Arabica (KOPI-1): produk sudah dihapus, tidak bisa dikonfirmasi.',
        'Teh Melati (TEH-1): stok tersedia 0, dibutuhkan 5.',
      ]);
    });

    test('non-validation failures fall back to their message', () {
      expect(statusChangeErrorLines(const NetworkFailure('offline'), order), ['offline']);
    });
  });

  group('orderFormProvider', () {
    test('adds products once, tracks quantities and the running total', () {
      final container = makeContainer();
      final form = container.read(orderFormProvider.notifier);
      container.listen(orderFormProvider, (_, _) {});

      expect(form.addProduct(product(10, price: 45000)), isTrue);
      expect(form.addProduct(product(20, price: 10000)), isTrue);
      expect(form.addProduct(product(10, price: 45000)), isFalse, reason: 'duplicate product is refused');
      form.setQuantity(0, 3);
      form.setQuantity(1, 5);

      final state = container.read(orderFormProvider);
      expect(state.lines, hasLength(2));
      expect(state.total, 3 * 45000 + 5 * 10000);

      form.setQuantity(1, null); // field cleared
      expect(container.read(orderFormProvider).total, 135000);
      form.removeLine(0);
      expect(container.read(orderFormProvider).lines.single.product.id, 20);
    });

    test('submit sends customer, lines and notes, and refreshes the list', () async {
      const sent = SalesOrderInput(
        customerId: 9,
        items: [OrderLineInput(productId: 10, quantity: 2)],
        notes: 'sore',
      );
      when(() => repo.createOrder(sent)).thenAnswer((_) async => salesOrder(5));
      stubList(items: []);
      final container = makeContainer();
      container.listen(orderFormProvider, (_, _) {});
      container.listen(salesOrderListProvider, (_, _) {});
      await container.read(salesOrderListProvider.future);
      final form = container.read(orderFormProvider.notifier)
        ..setCustomer(customer(9))
        ..addProduct(product(10))
        ..setQuantity(0, 2)
        ..setNotes('sore');

      final created = await form.submit();

      expect(created.id, 5);
      await container.read(salesOrderListProvider.future);
      verify(() => repo.getOrders(page: 1, pageSize: 20, status: null, customerId: null)).called(2);
    });
  });
}
