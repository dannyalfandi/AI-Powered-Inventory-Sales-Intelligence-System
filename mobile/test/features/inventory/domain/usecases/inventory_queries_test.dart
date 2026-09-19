import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/inventory/domain/usecases/get_inventory.dart';
import 'package:inventory_intel/features/inventory/domain/usecases/get_low_stock_items.dart';
import 'package:inventory_intel/features/inventory/domain/usecases/get_stock_movements.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/inventory_fixtures.dart';

void main() {
  late MockInventoryRepository repo;

  setUp(() => repo = MockInventoryRepository());

  group('GetInventory', () {
    test('loads the stock of a product', () async {
      when(() => repo.getInventory(3)).thenAnswer((_) async => inventory(3, quantity: 7));

      expect((await GetInventory(repo)(3)).quantity, 7);
    });

    test('rejects an invalid product id locally', () async {
      await expectLater(GetInventory(repo)(0), throwsA(isA<ValidationFailure>()));
      verifyNever(() => repo.getInventory(any()));
    });
  });

  group('GetStockMovements', () {
    final cases = <({String name, int page, int pageSize, int wantPage, int wantSize})>[
      (name: 'defaults kept', page: 1, pageSize: 20, wantPage: 1, wantSize: 20),
      (name: 'page below 1', page: -2, pageSize: 20, wantPage: 1, wantSize: 20),
      (name: 'page size clamped', page: 3, pageSize: 1000, wantPage: 3, wantSize: 100),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.getMovements(1, page: c.wantPage, pageSize: c.wantSize))
            .thenAnswer((_) async => pageOf([movement(1)]));

        await GetStockMovements(repo)(1, page: c.page, pageSize: c.pageSize);

        verify(() => repo.getMovements(1, page: c.wantPage, pageSize: c.wantSize)).called(1);
      });
    }

    test('rejects an invalid product id locally', () async {
      await expectLater(GetStockMovements(repo)(0), throwsA(isA<ValidationFailure>()));
    });
  });

  group('GetLowStockItems', () {
    test('clamps pagination', () async {
      when(() => repo.getLowStock(page: 1, pageSize: 100)).thenAnswer((_) async => pageOf([lowStockItem(1)]));

      final r = await GetLowStockItems(repo)(page: 0, pageSize: 500);

      expect(r.items.single.productId, 1);
    });
  });
}
