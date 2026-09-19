import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_providers.dart';
import 'package:inventory_intel/features/sales_order/presentation/screens/sales_order_list_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/sales_order_fixtures.dart';

void main() {
  late MockSalesOrderRepository repo;

  setUpAll(registerSalesOrderFallbacks);
  setUp(() => repo = MockSalesOrderRepository());

  Widget app() => ProviderScope(
        overrides: [salesOrderRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
        child: const MaterialApp(home: SalesOrderListScreen()),
      );

  testWidgets('shows number, customer, total and a badge per status; status chip filters', (tester) async {
    when(() => repo.getOrders(page: 1, pageSize: 20, status: null, customerId: null)).thenAnswer(
      (_) async => orderPage([
        salesOrder(2, status: OrderStatus.shipped),
        salesOrder(1, status: OrderStatus.cancelled),
      ]),
    );
    when(() => repo.getOrders(page: 1, pageSize: 20, status: OrderStatus.pending, customerId: null))
        .thenAnswer((_) async => orderPage([]));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('SO-20260920-0002'), findsOneWidget);
    expect(find.textContaining('Budi Santoso'), findsNWidgets(2));
    expect(find.text('Rp 185.000'), findsNWidgets(2));
    expect(find.byKey(const ValueKey('status_badge_shipped')), findsOneWidget);
    expect(find.byKey(const ValueKey('status_badge_cancelled')), findsOneWidget);

    await tester.tap(find.byKey(const Key('order_filter_status_pending')));
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada pesanan dengan filter ini.'), findsOneWidget);
    verify(() => repo.getOrders(page: 1, pageSize: 20, status: OrderStatus.pending, customerId: null)).called(1);
  });
}
