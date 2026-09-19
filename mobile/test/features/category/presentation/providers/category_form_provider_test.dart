import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/domain/entities/category.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_form_provider.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/category_fixtures.dart';

void main() {
  late MockCategoryRepository repo;

  setUpAll(registerCategoryFallbacks);
  setUp(() => repo = MockCategoryRepository());

  ProviderContainer makeContainer(int? id) {
    final container = ProviderContainer.test(
      overrides: [categoryRepositoryProvider.overrideWithValue(repo)],
      retry: (_, _) => null,
    );
    container.listen(categoryFormProvider(id), (_, _) {});
    return container;
  }

  test('create mode: state is null and save calls createCategory', () async {
    const input = CategoryInput(name: 'Snack');
    when(() => repo.createCategory(input)).thenAnswer((_) async => category(10, name: 'Snack'));
    final container = makeContainer(null);

    expect(await container.read(categoryFormProvider(null).future), isNull);
    final saved = await container.read(categoryFormProvider(null).notifier).save(input);

    expect(saved.id, 10);
  });

  group('edit mode save sends only changed fields', () {
    final existing = category(5, name: 'Minuman', description: 'Kopi');

    final cases = <({String name, CategoryInput input, CategoryPatch? wantPatch})>[
      (
        name: 'name changed',
        input: const CategoryInput(name: 'Minuman Dingin', description: 'Kopi'),
        wantPatch: const CategoryPatch(name: 'Minuman Dingin'),
      ),
      (
        name: 'description cleared',
        input: const CategoryInput(name: 'Minuman'),
        wantPatch: const CategoryPatch(description: ''),
      ),
      (
        name: 'nothing changed (after trim) → no API call',
        input: const CategoryInput(name: ' Minuman ', description: 'Kopi'),
        wantPatch: null,
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.getCategoryById(5)).thenAnswer((_) async => existing);
        when(() => repo.updateCategory(5, any())).thenAnswer((_) async => existing);
        final container = makeContainer(5);
        await container.read(categoryFormProvider(5).future);

        await container.read(categoryFormProvider(5).notifier).save(c.input);

        if (c.wantPatch == null) {
          verifyNever(() => repo.updateCategory(any(), any()));
        } else {
          verify(() => repo.updateCategory(5, c.wantPatch!)).called(1);
        }
      });
    }
  });

  test('edit mode: load failure is exposed as AsyncError', () async {
    when(() => repo.getCategoryById(5)).thenThrow(const ServerFailure('not found', statusCode: 404));
    final container = makeContainer(5);

    await expectLater(container.read(categoryFormProvider(5).future), throwsA(isA<ServerFailure>()));
  });
}
