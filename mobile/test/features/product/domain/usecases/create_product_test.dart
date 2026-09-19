import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/product/domain/entities/product_input.dart';
import 'package:inventory_intel/features/product/domain/usecases/create_product.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/product_fixtures.dart';

void main() {
  late MockProductRepository repo;
  late CreateProduct usecase;

  setUpAll(registerProductFallbacks);

  setUp(() {
    repo = MockProductRepository();
    usecase = CreateProduct(repo);
  });

  test('trims input and creates the product', () async {
    const input = ProductInput(sku: '  KOPI-1 ', name: ' Kopi ', description: ' enak ', price: 45000);
    const trimmed = ProductInput(sku: 'KOPI-1', name: 'Kopi', description: 'enak', price: 45000);
    when(() => repo.createProduct(trimmed)).thenAnswer((_) async => product(1, sku: 'KOPI-1'));

    final result = await usecase(input);

    expect(result.sku, 'KOPI-1');
    verify(() => repo.createProduct(trimmed)).called(1);
  });

  group('rejects invalid input locally', () {
    final cases = <({String name, ProductInput input, Set<String> fields})>[
      (name: 'empty sku and name', input: const ProductInput(sku: ' ', name: '', price: 1), fields: {'sku', 'name'}),
      (name: 'negative price', input: const ProductInput(sku: 'A', name: 'B', price: -1), fields: {'price'}),
      (
        name: 'sku longer than 64',
        input: ProductInput(sku: 'X' * (ProductRules.skuMaxLength + 1), name: 'B', price: 0),
        fields: {'sku'},
      ),
      (
        name: 'name longer than 255',
        input: ProductInput(sku: 'A', name: 'N' * (ProductRules.nameMaxLength + 1), price: 0),
        fields: {'name'},
      ),
      (
        name: 'non-positive category id',
        input: const ProductInput(sku: 'A', name: 'B', price: 0, categoryId: 0),
        fields: {'category_id'},
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        await expectLater(
          usecase(c.input),
          throwsA(isA<ValidationFailure>().having((f) => f.messages.keys.toSet(), 'fields', c.fields)),
        );
        verifyNever(() => repo.createProduct(any()));
      });
    }
  });

  test('propagates duplicate SKU conflict from the backend', () async {
    when(() => repo.createProduct(any()))
        .thenThrow(const ServerFailure('conflict', statusCode: 409, code: 'conflict'));

    await expectLater(
      usecase(const ProductInput(sku: 'A', name: 'B', price: 0)),
      throwsA(isA<ServerFailure>().having((f) => f.isConflict, 'isConflict', true)),
    );
  });
}
