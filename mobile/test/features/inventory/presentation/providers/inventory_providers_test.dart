import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/inventory/domain/entities/inventory.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/low_stock_list_provider.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/stock_movement_list_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/inventory_fixtures.dart';

void main() {
  late MockInventoryRepository repo;

  setUpAll(registerInventoryFallbacks);
  setUp(() => repo = MockInventoryRepository());

  ProviderContainer makeContainer() => ProviderContainer.test(
        overrides: [inventoryRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
      );

  group('productInventoryProvider', () {
    test('loads the stock', () async {
      when(() => repo.getInventory(1)).thenAnswer((_) async => inventory(1, quantity: 20));
      final container = makeContainer();
      container.listen(productInventoryProvider(1), (_, _) {});

      expect((await container.read(productInventoryProvider(1).future)).quantity, 20);
    });

    test('recordMovement shows the returned stock and reloads history + low-stock list', () async {
      when(() => repo.getInventory(1)).thenAnswer((_) async => inventory(1, quantity: 20));
      when(() => repo.getMovements(1, page: 1, pageSize: 20)).thenAnswer((_) async => pageOf([movement(1)]));
      when(() => repo.getLowStock(page: 1, pageSize: 20)).thenAnswer((_) async => pageOf([lowStockItem(2)]));
      const input = MovementInput(type: MovementType.stockOut, quantity: 15);
      when(() => repo.recordMovement(1, input)).thenAnswer(
        (_) async => MovementResult(
          movement: movement(2, type: MovementType.stockOut, quantity: 15, before: 20, after: 5),
          inventory: inventory(1, quantity: 5),
        ),
      );
      final container = makeContainer();
      container.listen(productInventoryProvider(1), (_, _) {});
      container.listen(stockMovementListProvider(1), (_, _) {});
      container.listen(lowStockListProvider, (_, _) {});
      await container.read(productInventoryProvider(1).future);
      await container.read(stockMovementListProvider(1).future);
      await container.read(lowStockListProvider.future);

      final result = await container.read(productInventoryProvider(1).notifier).recordMovement(input);

      expect(result.movement.quantityAfter, 5);
      final inv = container.read(productInventoryProvider(1)).requireValue;
      expect(inv.quantity, 5);
      expect(inv.isLowStock, isTrue);
      await container.read(stockMovementListProvider(1).future);
      await container.read(lowStockListProvider.future);
      verify(() => repo.getMovements(1, page: 1, pageSize: 20)).called(2);
      verify(() => repo.getLowStock(page: 1, pageSize: 20)).called(2);
    });

    test('recordMovement rethrows the insufficient-stock 422 and keeps the stock', () async {
      when(() => repo.getInventory(1)).thenAnswer((_) async => inventory(1, quantity: 20));
      when(() => repo.recordMovement(1, any())).thenThrow(insufficientStockFailure);
      final container = makeContainer();
      container.listen(productInventoryProvider(1), (_, _) {});
      await container.read(productInventoryProvider(1).future);

      await expectLater(
        container
            .read(productInventoryProvider(1).notifier)
            .recordMovement(const MovementInput(type: MovementType.stockOut, quantity: 21)),
        throwsA(isA<ValidationFailure>()),
      );

      expect(container.read(productInventoryProvider(1)).requireValue.quantity, 20);
    });
  });

  group('stockMovementListProvider', () {
    test('loads newest first and appends the next page', () async {
      when(() => repo.getMovements(1, page: 1, pageSize: 20))
          .thenAnswer((_) async => pageOf([movement(3), movement(2)], pageSize: 2, total: 3));
      when(() => repo.getMovements(1, page: 2, pageSize: 2))
          .thenAnswer((_) async => pageOf([movement(1)], page: 2, pageSize: 2, total: 3));
      final container = makeContainer();
      container.listen(stockMovementListProvider(1), (_, _) {});
      await container.read(stockMovementListProvider(1).future);

      await container.read(stockMovementListProvider(1).notifier).loadMore();

      final state = container.read(stockMovementListProvider(1)).requireValue;
      expect(state.items.map((m) => m.id), [3, 2, 1]);
      expect(state.hasMore, isFalse);
    });

    test('load-more failure keeps loaded items', () async {
      when(() => repo.getMovements(1, page: 1, pageSize: 20))
          .thenAnswer((_) async => pageOf([movement(2)], pageSize: 1, total: 2));
      when(() => repo.getMovements(1, page: 2, pageSize: 1)).thenThrow(const NetworkFailure('offline'));
      final container = makeContainer();
      container.listen(stockMovementListProvider(1), (_, _) {});
      await container.read(stockMovementListProvider(1).future);

      await container.read(stockMovementListProvider(1).notifier).loadMore();

      final state = container.read(stockMovementListProvider(1)).requireValue;
      expect(state.items.map((m) => m.id), [2]);
      expect(state.loadMoreError, isA<NetworkFailure>());
    });
  });

  group('lowStockListProvider', () {
    test('loads and paginates', () async {
      when(() => repo.getLowStock(page: 1, pageSize: 20))
          .thenAnswer((_) async => pageOf([lowStockItem(1, quantity: 0)], pageSize: 1, total: 2));
      when(() => repo.getLowStock(page: 2, pageSize: 1))
          .thenAnswer((_) async => pageOf([lowStockItem(2, quantity: 3)], page: 2, pageSize: 1, total: 2));
      final container = makeContainer();
      container.listen(lowStockListProvider, (_, _) {});
      await container.read(lowStockListProvider.future);

      await container.read(lowStockListProvider.notifier).loadMore();

      expect(container.read(lowStockListProvider).requireValue.items.map((i) => i.productId), [1, 2]);
    });

    test('initial failure is exposed as AsyncError', () async {
      when(() => repo.getLowStock(page: 1, pageSize: 20)).thenThrow(const NetworkFailure('offline'));
      final container = makeContainer();
      container.listen(lowStockListProvider, (_, _) {});

      await expectLater(container.read(lowStockListProvider.future), throwsA(isA<NetworkFailure>()));
    });
  });
}
