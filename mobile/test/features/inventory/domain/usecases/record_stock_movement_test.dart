import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/inventory/domain/entities/inventory.dart';
import 'package:inventory_intel/features/inventory/domain/usecases/record_stock_movement.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/inventory_fixtures.dart';

void main() {
  late MockInventoryRepository repo;
  late RecordStockMovement usecase;

  setUpAll(registerInventoryFallbacks);

  setUp(() {
    repo = MockInventoryRepository();
    usecase = RecordStockMovement(repo);
  });

  MovementResult result() => MovementResult(movement: movement(1), inventory: inventory(1));

  group('valid movements are sent (reason trimmed)', () {
    final cases = <({String name, MovementInput input, MovementInput sent})>[
      (
        name: 'IN',
        input: const MovementInput(type: MovementType.stockIn, quantity: 5, reason: ' restock '),
        sent: const MovementInput(type: MovementType.stockIn, quantity: 5, reason: 'restock'),
      ),
      (
        name: 'OUT (stock sufficiency is left to the backend)',
        input: const MovementInput(type: MovementType.stockOut, quantity: 999999),
        sent: const MovementInput(type: MovementType.stockOut, quantity: 999999),
      ),
      (
        name: 'ADJUSTMENT to zero',
        input: const MovementInput(type: MovementType.adjustment, quantity: 0),
        sent: const MovementInput(type: MovementType.adjustment, quantity: 0),
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.recordMovement(1, c.sent)).thenAnswer((_) async => result());

        await usecase(1, c.input);

        verify(() => repo.recordMovement(1, c.sent)).called(1);
      });
    }
  });

  group('invalid movements are rejected locally', () {
    final cases = <({String name, int productId, MovementInput input, Set<String> fields})>[
      (
        name: 'missing quantity',
        productId: 1,
        input: const MovementInput(type: MovementType.stockIn, quantity: null),
        fields: {'quantity'},
      ),
      (
        name: 'zero IN',
        productId: 1,
        input: const MovementInput(type: MovementType.stockIn, quantity: 0),
        fields: {'quantity'},
      ),
      (
        name: 'zero OUT',
        productId: 1,
        input: const MovementInput(type: MovementType.stockOut, quantity: 0),
        fields: {'quantity'},
      ),
      (
        name: 'negative ADJUSTMENT',
        productId: 1,
        input: const MovementInput(type: MovementType.adjustment, quantity: -1),
        fields: {'quantity'},
      ),
      (
        name: 'quantity above the backend cap',
        productId: 1,
        input: const MovementInput(type: MovementType.stockIn, quantity: MovementRules.maxQuantity + 1),
        fields: {'quantity'},
      ),
      (
        name: 'reason too long',
        productId: 1,
        input: MovementInput(type: MovementType.stockIn, quantity: 1, reason: 'x' * 501),
        fields: {'reason'},
      ),
      (
        name: 'invalid product id',
        productId: 0,
        input: const MovementInput(type: MovementType.stockIn, quantity: 1),
        fields: {'product_id'},
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        await expectLater(
          usecase(c.productId, c.input),
          throwsA(isA<ValidationFailure>().having((f) => f.messages.keys.toSet(), 'fields', c.fields)),
        );
        verifyNever(() => repo.recordMovement(any(), any()));
      });
    }
  });

  test('propagates the backend insufficient-stock 422', () async {
    when(() => repo.recordMovement(1, any())).thenThrow(insufficientStockFailure);

    await expectLater(
      usecase(1, const MovementInput(type: MovementType.stockOut, quantity: 21)),
      throwsA(
        isA<ValidationFailure>().having(
          (f) => f.messages['quantity'],
          'quantity',
          'insufficient stock: 20 available, 21 requested',
        ),
      ),
    );
  });
}
