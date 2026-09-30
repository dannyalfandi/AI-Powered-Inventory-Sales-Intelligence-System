import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';
import 'package:inventory_intel/features/sales_order/presentation/providers/sales_order_providers.dart';
import 'package:inventory_intel/features/sales_order/presentation/screens/sales_order_detail_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/auth_fixtures.dart';
import '../../../../helpers/inventory_fixtures.dart';
import '../../../../helpers/sales_order_fixtures.dart';
import '../../../../helpers/l10n_harness.dart';

void main() {
  late MockSalesOrderRepository repo;

  setUpAll(registerSalesOrderFallbacks);
  setUp(() {
    repo = MockSalesOrderRepository();
    when(() => repo.getOrders(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
          status: any(named: 'status'),
          customerId: any(named: 'customerId'),
        )).thenAnswer((_) async => orderPage([]));
  });

  Widget app() => ProviderScope(
        overrides: [
          salesOrderRepositoryProvider.overrideWithValue(repo),
          inventoryRepositoryProvider.overrideWithValue(MockInventoryRepository()),
          signedInAs(superAdmin),
        ],
        retry: (_, _) => null,
        child: localizedApp(home: const SalesOrderDetailScreen(orderId: 1)),
      );

  Finder action(OrderStatus s) => find.byKey(Key('order_action_${s.name}'));

  bool enabled(WidgetTester tester, OrderStatus s) =>
      tester.widget<ButtonStyleButton>(action(s)).onPressed != null;

  Future<void> tapAndConfirm(WidgetTester tester, OrderStatus s) async {
    await tester.tap(action(s));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('order_confirm_dialog_ok')));
  }

  testWidgets('shows customer, items with snapshot prices, and the total', (tester) async {
    when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('KOPI-1 · 3 × Rp 45.000'), findsOneWidget);
    expect(find.text('Rp 135.000'), findsOneWidget);
    expect(find.text('Rp 185.000'), findsOneWidget);
    expect(find.byKey(const ValueKey('status_badge_pending')), findsOneWidget);
  });

  group('action buttons follow the state machine', () {
    final cases = <(OrderStatus, List<OrderStatus>)>[
      (OrderStatus.pending, [OrderStatus.confirmed, OrderStatus.cancelled]),
      (OrderStatus.confirmed, [OrderStatus.shipped, OrderStatus.cancelled]),
      (OrderStatus.shipped, []),
      (OrderStatus.cancelled, []),
    ];
    for (final (status, actions) in cases) {
      testWidgets('${status.name}: ${actions.map((a) => a.name).join(', ')}', (tester) async {
        when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1, status: status));
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();

        for (final s in OrderStatus.values) {
          expect(action(s), actions.contains(s) ? findsOneWidget : findsNothing, reason: s.name);
        }
        expect(find.byKey(const Key('order_no_actions')), actions.isEmpty ? findsOneWidget : findsNothing);
      });
    }
  });

  testWidgets('confirm asks first and explains the stock effect; "Kembali" sends nothing', (tester) async {
    when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(action(OrderStatus.confirmed));
    await tester.pumpAndSettle();

    expect(find.text(l10nOf(tester).orderConfirmDialogTitle), findsOneWidget);
    expect(find.textContaining(l10nOf(tester).orderConfirmDialogBody), findsOneWidget);
    expect(find.textContaining('Teh Melati × 5'), findsOneWidget);
    await tester.tap(find.text(l10nOf(tester).commonBack));
    await tester.pumpAndSettle();
    verifyNever(() => repo.changeStatus(any(), any()));
  });

  testWidgets('cancelling a confirmed order says stock is returned', (tester) async {
    when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1, status: OrderStatus.confirmed));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(action(OrderStatus.cancelled));
    await tester.pumpAndSettle();

    expect(find.textContaining(l10nOf(tester).orderCancelDialogBodyConfirmed), findsOneWidget);
  });

  testWidgets('all actions are disabled while a status change is in flight', (tester) async {
    final response = Completer<SalesOrder>();
    when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
    when(() => repo.changeStatus(1, OrderStatus.confirmed)).thenAnswer((_) => response.future);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tapAndConfirm(tester, OrderStatus.confirmed);
    await tester.pump(); // dialog closes, request starts
    await tester.pump(const Duration(milliseconds: 300));

    expect(enabled(tester, OrderStatus.confirmed), isFalse);
    expect(enabled(tester, OrderStatus.cancelled), isFalse);
    expect(find.descendant(of: action(OrderStatus.confirmed), matching: find.byType(CircularProgressIndicator)),
        findsOneWidget);
    await tester.tap(action(OrderStatus.confirmed), warnIfMissed: false); // a second tap does nothing
    await tester.pump();
    verify(() => repo.changeStatus(1, OrderStatus.confirmed)).called(1);

    response.complete(salesOrder(1, status: OrderStatus.confirmed));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('status_badge_confirmed')), findsOneWidget);
    expect(action(OrderStatus.shipped), findsOneWidget);
    expect(enabled(tester, OrderStatus.shipped), isTrue);
  });

  testWidgets('short stock on confirm lists each problem item, and the order stays PENDING', (tester) async {
    when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
    when(() => repo.changeStatus(1, OrderStatus.confirmed)).thenThrow(tehShortFailure);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tapAndConfirm(tester, OrderStatus.confirmed);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('order_status_error_dialog')), findsOneWidget);
    expect(find.text(l10nOf(tester).orderConfirmBlockedTitle), findsOneWidget);
    expect(find.text(l10nOf(tester).orderItemProblem('Teh Melati (TEH-1)', tehShortFailure.messages['items[1].quantity']!)), findsOneWidget);
    expect(find.text(l10nOf(tester).orderStockProblemBody), findsOneWidget);
    await tester.tap(find.text(l10nOf(tester).commonUnderstood));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('status_badge_pending')), findsOneWidget);
    expect(enabled(tester, OrderStatus.confirmed), isTrue, reason: 'buttons are usable again');
  });

  testWidgets('network failure shows a snackbar and re-enables the buttons', (tester) async {
    when(() => repo.getOrderById(1)).thenAnswer((_) async => salesOrder(1));
    when(() => repo.changeStatus(1, OrderStatus.cancelled)).thenThrow(const NetworkFailure('Tidak dapat terhubung ke server.'));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tapAndConfirm(tester, OrderStatus.cancelled);
    await tester.pumpAndSettle();

    expect(find.text(l10nOf(tester).networkUnreachable), findsOneWidget);
    expect(enabled(tester, OrderStatus.cancelled), isTrue);
  });
}
