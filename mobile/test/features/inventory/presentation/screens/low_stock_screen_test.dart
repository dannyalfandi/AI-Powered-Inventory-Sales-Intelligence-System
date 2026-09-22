import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/inventory/domain/entities/inventory.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:inventory_intel/features/inventory/presentation/screens/low_stock_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/inventory_fixtures.dart';
import '../../../../helpers/l10n_harness.dart';

void main() {
  late MockInventoryRepository repo;

  setUp(() => repo = MockInventoryRepository());

  Widget app() => ProviderScope(
        overrides: [inventoryRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
        child: localizedApp(home: const LowStockScreen()),
      );

  void stubLowStock(Object result) {
    final call = when(() => repo.getLowStock(page: any(named: 'page'), pageSize: any(named: 'pageSize')));
    if (result is Failure) {
      call.thenThrow(result);
    } else {
      call.thenAnswer((_) async => result as dynamic);
    }
  }

  testWidgets('lists low-stock products; empty stock is shown as "Habis"', (tester) async {
    stubLowStock(
      pageOf([
        lowStockItem(1, name: 'Roti Tawar', quantity: 0),
        lowStockItem(2, name: 'Kopi Arabica', quantity: 3, threshold: 5),
      ]),
    );
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Roti Tawar'), findsOneWidget);
    expect(find.text(l10nOf(tester).inventoryOutOfStock), findsOneWidget);
    expect(find.text('Kopi Arabica'), findsOneWidget);
    expect(find.text(l10nOf(tester).inventoryRemaining(3)), findsOneWidget);
    expect(find.text('SKU-2 · ${l10nOf(tester).inventoryThresholdShort(5)}'), findsOneWidget);
    expect(find.text(l10nOf(tester).inventoryRestockCount(2)), findsOneWidget);
  });

  testWidgets('shows the all-good empty state', (tester) async {
    stubLowStock(pageOf(<LowStockItem>[]));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text(l10nOf(tester).inventoryLowStockAllGood), findsOneWidget);
  });

  testWidgets('shows error state and retries', (tester) async {
    stubLowStock(const NetworkFailure('Tidak dapat terhubung ke server.'));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text(l10nOf(tester).networkUnreachable), findsOneWidget);

    stubLowStock(pageOf([lowStockItem(1, name: 'Gula')]));
    await tester.tap(find.text(l10nOf(tester).commonRetry));
    await tester.pumpAndSettle();

    expect(find.text('Gula'), findsOneWidget);
  });

  testWidgets('"load more" fetches the next page', (tester) async {
    when(() => repo.getLowStock(page: 1, pageSize: 20))
        .thenAnswer((_) async => pageOf([lowStockItem(1, name: 'Gula')], pageSize: 1, total: 2));
    when(() => repo.getLowStock(page: 2, pageSize: 1))
        .thenAnswer((_) async => pageOf([lowStockItem(2, name: 'Garam')], page: 2, pageSize: 1, total: 2));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10nOf(tester).commonLoadMore));
    await tester.pumpAndSettle();

    expect(find.text('Garam'), findsOneWidget);
  });
}
