import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/product/domain/entities/product.dart';
import 'package:inventory_intel/features/product/domain/entities/product_input.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_form_provider.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/product_fixtures.dart';

void main() {
  late MockProductRepository repo;

  setUpAll(registerProductFallbacks);
  setUp(() => repo = MockProductRepository());

  ProviderContainer makeContainer(int? id) {
    final container = ProviderContainer.test(
      overrides: [productRepositoryProvider.overrideWithValue(repo)],
      retry: (_, _) => null,
    );
    container.listen(productFormProvider(id), (_, _) {});
    return container;
  }

  test('create mode: state is null and save calls createProduct', () async {
    const input = ProductInput(sku: 'NEW-1', name: 'Baru', price: 1000);
    when(() => repo.createProduct(input)).thenAnswer((_) async => product(10, sku: 'NEW-1'));
    final container = makeContainer(null);

    expect(await container.read(productFormProvider(null).future), isNull);
    final saved = await container.read(productFormProvider(null).notifier).save(input);

    expect(saved.id, 10);
    verify(() => repo.createProduct(input)).called(1);
  });

  test('edit mode: loads the product by id', () async {
    when(() => repo.getProductById(5)).thenAnswer((_) async => product(5));
    final container = makeContainer(5);

    expect(await container.read(productFormProvider(5).future), product(5));
  });

  test('edit mode: load failure is exposed as AsyncError', () async {
    when(() => repo.getProductById(5))
        .thenThrow(const ServerFailure('not found', statusCode: 404, code: 'not_found'));
    final container = makeContainer(5);

    await expectLater(container.read(productFormProvider(5).future), throwsA(isA<ServerFailure>()));
  });

  group('edit mode save sends only changed fields', () {
    final existing = product(5, sku: 'SKU-5', name: 'Beras', price: 70000, description: '5kg');

    final cases = <({String name, ProductInput input, ProductPatch? wantPatch})>[
      (
        name: 'price changed',
        input: const ProductInput(sku: 'SKU-5', name: 'Beras', description: '5kg', price: 75000),
        wantPatch: const ProductPatch(price: 75000),
      ),
      (
        name: 'name and sku changed (input trimmed before diff)',
        input: const ProductInput(sku: ' SKU-5B ', name: 'Beras Premium', description: '5kg', price: 70000),
        wantPatch: const ProductPatch(sku: 'SKU-5B', name: 'Beras Premium'),
      ),
      (
        name: 'nothing changed → no API call',
        input: const ProductInput(sku: 'SKU-5', name: 'Beras', description: '5kg', price: 70000),
        wantPatch: null,
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.getProductById(5)).thenAnswer((_) async => existing);
        when(() => repo.updateProduct(5, any())).thenAnswer((_) async => existing);
        final container = makeContainer(5);
        await container.read(productFormProvider(5).future);

        await container.read(productFormProvider(5).notifier).save(c.input);

        if (c.wantPatch == null) {
          verifyNever(() => repo.updateProduct(any(), any()));
        } else {
          verify(() => repo.updateProduct(5, c.wantPatch!)).called(1);
        }
      });
    }
  });

  group('edit mode category changes', () {
    const minuman = ProductCategory(id: 3, name: 'Minuman');
    final base = const ProductInput(sku: 'SKU-5', name: 'Beras', price: 70000);

    final cases = <({String name, Product existing, ProductInput input, ProductPatch? wantPatch})>[
      (
        name: 'assign a category',
        existing: product(5, sku: 'SKU-5', name: 'Beras', price: 70000),
        input: base.copyWith(categoryId: 3),
        wantPatch: const ProductPatch(categoryId: 3),
      ),
      (
        name: '"Tanpa Kategori" sends category_id 0',
        existing: product(5, sku: 'SKU-5', name: 'Beras', price: 70000, category: minuman),
        input: base,
        wantPatch: const ProductPatch(categoryId: ProductPatch.noCategory),
      ),
      (
        name: 'same category → no API call',
        existing: product(5, sku: 'SKU-5', name: 'Beras', price: 70000, category: minuman),
        input: base.copyWith(categoryId: 3),
        wantPatch: null,
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.getProductById(5)).thenAnswer((_) async => c.existing);
        when(() => repo.updateProduct(5, any())).thenAnswer((_) async => c.existing);
        final container = makeContainer(5);
        await container.read(productFormProvider(5).future);

        await container.read(productFormProvider(5).notifier).save(c.input);

        if (c.wantPatch == null) {
          verifyNever(() => repo.updateProduct(any(), any()));
        } else {
          verify(() => repo.updateProduct(5, c.wantPatch!)).called(1);
        }
      });
    }
  });

  test('create mode sends the selected category', () async {
    const input = ProductInput(sku: 'NEW-1', name: 'Baru', price: 1000, categoryId: 3);
    when(() => repo.createProduct(input)).thenAnswer((_) async => product(10));
    final container = makeContainer(null);
    await container.read(productFormProvider(null).future);

    await container.read(productFormProvider(null).notifier).save(input);

    verify(() => repo.createProduct(input)).called(1);
  });

  test('save rethrows backend validation failure', () async {
    when(() => repo.createProduct(any())).thenThrow(
      const ValidationFailure('request validation failed', messages: {'sku': 'is required'}),
    );
    final container = makeContainer(null);
    await container.read(productFormProvider(null).future);

    await expectLater(
      container.read(productFormProvider(null).notifier).save(const ProductInput(sku: 'A', name: 'B', price: 1)),
      throwsA(isA<ValidationFailure>()),
    );
  });
}
