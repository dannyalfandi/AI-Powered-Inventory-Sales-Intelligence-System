import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';
import 'package:inventory_intel/features/sales_order/domain/usecases/change_order_status.dart';
import 'package:inventory_intel/features/sales_order/domain/usecases/create_sales_order.dart';
import 'package:inventory_intel/features/sales_order/domain/usecases/get_sales_orders.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/sales_order_fixtures.dart';

void main() {
  late MockSalesOrderRepository repo;

  setUpAll(registerSalesOrderFallbacks);
  setUp(() => repo = MockSalesOrderRepository());

  group('state machine (mirrors backend orderTransitions)', () {
    const allowed = {
      (OrderStatus.pending, OrderStatus.confirmed),
      (OrderStatus.pending, OrderStatus.cancelled),
      (OrderStatus.confirmed, OrderStatus.shipped),
      (OrderStatus.confirmed, OrderStatus.cancelled),
    };
    for (final from in OrderStatus.values) {
      for (final to in OrderStatus.values) {
        test('${from.name} → ${to.name}', () {
          expect(from.canMoveTo(to), allowed.contains((from, to)));
        });
      }
    }

    test('SHIPPED and CANCELLED are final', () {
      expect(OrderStatus.shipped.isFinal, isTrue);
      expect(OrderStatus.cancelled.isFinal, isTrue);
      expect(OrderStatus.pending.isFinal, isFalse);
    });
  });

  group('OrderRules.validate', () {
    SalesOrderInput input({int? customer = 7, List<OrderLineInput>? items, String notes = ''}) => SalesOrderInput(
          customerId: customer,
          items: items ?? const [OrderLineInput(productId: 10, quantity: 1)],
          notes: notes,
        );

    final cases = <({String name, SalesOrderInput input, Map<String, String> want})>[
      (name: 'valid', input: input(), want: {}),
      (name: 'customer required', input: input(customer: null), want: {'customer_id': 'Pilih pelanggan'}),
      (name: 'at least one item', input: input(items: []), want: {'items': 'Tambahkan minimal satu produk'}),
      (
        name: 'duplicate product points at the first line',
        input: input(items: const [
          OrderLineInput(productId: 10, quantity: 1),
          OrderLineInput(productId: 20, quantity: 1),
          OrderLineInput(productId: 10, quantity: 2),
        ]),
        want: {'items[2].product_id': 'Produk ini sudah ada di baris 1; gabungkan jumlahnya'},
      ),
      (
        name: 'quantity must be present, positive and within the cap',
        input: input(items: const [
          OrderLineInput(productId: 10, quantity: null),
          OrderLineInput(productId: 20, quantity: 0),
          OrderLineInput(productId: 30, quantity: 1000001),
        ]),
        want: {
          'items[0].quantity': 'Jumlah wajib diisi',
          'items[1].quantity': 'Jumlah harus lebih dari 0',
          'items[2].quantity': 'Jumlah maksimal 1000000',
        },
      ),
      (
        name: 'too many items',
        input: input(items: [for (var i = 1; i <= 101; i++) OrderLineInput(productId: i, quantity: 1)]),
        want: {'items': 'Maksimal 100 produk per pesanan'},
      ),
    ];

    for (final c in cases) {
      test(c.name, () => expect(OrderRules.validate(c.input), c.want));
    }
  });

  group('CreateSalesOrder', () {
    test('rejects a duplicate product locally, without calling the API', () async {
      await expectLater(
        CreateSalesOrder(repo)(const SalesOrderInput(customerId: 7, items: [
          OrderLineInput(productId: 10, quantity: 1),
          OrderLineInput(productId: 10, quantity: 1),
        ])),
        throwsA(isA<ValidationFailure>().having((f) => f.messages.keys, 'fields', ['items[1].product_id'])),
      );
      verifyNever(() => repo.createOrder(any()));
    });

    test('valid order is sent with trimmed notes', () async {
      const sent = SalesOrderInput(customerId: 7, items: [OrderLineInput(productId: 10, quantity: 3)], notes: 'sore');
      when(() => repo.createOrder(sent)).thenAnswer((_) async => salesOrder(1));

      await CreateSalesOrder(repo)(sent.copyWith(notes: '  sore '));

      verify(() => repo.createOrder(sent)).called(1);
    });

    test('propagates backend 422 (e.g. deleted product)', () async {
      when(() => repo.createOrder(any())).thenThrow(
        const ValidationFailure('x', messages: {'items[0].product_id': 'product 10 does not exist'}),
      );

      await expectLater(
        CreateSalesOrder(repo)(const SalesOrderInput(customerId: 7, items: [OrderLineInput(productId: 10, quantity: 1)])),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });

  group('ChangeOrderStatus', () {
    test('allowed transition calls the API', () async {
      when(() => repo.changeStatus(1, OrderStatus.confirmed))
          .thenAnswer((_) async => salesOrder(1, status: OrderStatus.confirmed));

      final o = await ChangeOrderStatus(repo)(salesOrder(1), OrderStatus.confirmed);

      expect(o.status, OrderStatus.confirmed);
    });

    final rejected = [
      (OrderStatus.pending, OrderStatus.shipped),
      (OrderStatus.confirmed, OrderStatus.confirmed),
      (OrderStatus.shipped, OrderStatus.cancelled),
      (OrderStatus.cancelled, OrderStatus.confirmed),
    ];
    for (final (from, to) in rejected) {
      test('${from.name} → ${to.name} is rejected locally with a status error', () async {
        await expectLater(
          ChangeOrderStatus(repo)(salesOrder(1, status: from), to),
          throwsA(isA<ValidationFailure>().having((f) => f.messages.keys, 'fields', ['status'])),
        );
        verifyNever(() => repo.changeStatus(any(), any()));
      });
    }
  });

  test('GetSalesOrders clamps paging and drops a non-positive customer filter', () async {
    when(() => repo.getOrders(page: 1, pageSize: 100, status: OrderStatus.shipped, customerId: null))
        .thenAnswer((_) async => orderPage([]));

    await GetSalesOrders(repo)(page: 0, pageSize: 999, status: OrderStatus.shipped, customerId: 0);

    verify(() => repo.getOrders(page: 1, pageSize: 100, status: OrderStatus.shipped, customerId: null)).called(1);
  });
}
