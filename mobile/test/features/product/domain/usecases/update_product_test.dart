import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/product/domain/entities/product_input.dart';
import 'package:inventory_intel/features/product/domain/usecases/update_product.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/product_fixtures.dart';

void main() {
  late MockProductRepository repo;
  late UpdateProduct usecase;

  setUpAll(registerProductFallbacks);

  setUp(() {
    repo = MockProductRepository();
    usecase = UpdateProduct(repo);
  });

  group('valid patches are trimmed and sent', () {
    final cases = <({String name, ProductPatch patch, ProductPatch sent})>[
      (name: 'price only', patch: const ProductPatch(price: 5000), sent: const ProductPatch(price: 5000)),
      (name: 'name trimmed', patch: const ProductPatch(name: ' Teh '), sent: const ProductPatch(name: 'Teh')),
      (name: 'price zero allowed', patch: const ProductPatch(price: 0), sent: const ProductPatch(price: 0)),
      (name: 'empty description allowed', patch: const ProductPatch(description: ''), sent: const ProductPatch(description: '')),
      (name: 'category changed', patch: const ProductPatch(categoryId: 4), sent: const ProductPatch(categoryId: 4)),
      (
        name: 'category removed (0)',
        patch: const ProductPatch(categoryId: ProductPatch.noCategory),
        sent: const ProductPatch(categoryId: ProductPatch.noCategory),
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.updateProduct(3, c.sent)).thenAnswer((_) async => product(3));

        await usecase(3, c.patch);

        verify(() => repo.updateProduct(3, c.sent)).called(1);
      });
    }
  });

  group('invalid patches are rejected locally', () {
    final cases = <({String name, int id, ProductPatch patch, Set<String> fields})>[
      (name: 'blank sku', id: 3, patch: const ProductPatch(sku: '  '), fields: {'sku'}),
      (name: 'blank name', id: 3, patch: const ProductPatch(name: ''), fields: {'name'}),
      (name: 'negative price', id: 3, patch: const ProductPatch(price: -10), fields: {'price'}),
      (name: 'invalid id', id: 0, patch: const ProductPatch(price: 1), fields: {'id'}),
      (name: 'negative category id', id: 3, patch: const ProductPatch(categoryId: -1), fields: {'category_id'}),
    ];

    for (final c in cases) {
      test(c.name, () async {
        await expectLater(
          usecase(c.id, c.patch),
          throwsA(isA<ValidationFailure>().having((f) => f.issues.keys.toSet(), 'fields', c.fields)),
        );
        verifyNever(() => repo.updateProduct(any(), any()));
      });
    }
  });
}
