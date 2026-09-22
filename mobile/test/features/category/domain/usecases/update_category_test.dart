import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/domain/entities/category.dart';
import 'package:inventory_intel/features/category/domain/usecases/update_category.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/category_fixtures.dart';

void main() {
  late MockCategoryRepository repo;
  late UpdateCategory usecase;

  setUpAll(registerCategoryFallbacks);

  setUp(() {
    repo = MockCategoryRepository();
    usecase = UpdateCategory(repo);
  });

  group('valid patches are trimmed and sent', () {
    final cases = <({String name, CategoryPatch patch, CategoryPatch sent})>[
      (name: 'name trimmed', patch: const CategoryPatch(name: ' Snack '), sent: const CategoryPatch(name: 'Snack')),
      (
        name: 'description cleared',
        patch: const CategoryPatch(description: ''),
        sent: const CategoryPatch(description: ''),
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.updateCategory(3, c.sent)).thenAnswer((_) async => category(3));

        await usecase(3, c.patch);

        verify(() => repo.updateCategory(3, c.sent)).called(1);
      });
    }
  });

  group('invalid patches are rejected locally', () {
    final cases = <({String name, int id, CategoryPatch patch, Set<String> fields})>[
      (name: 'blank name', id: 3, patch: const CategoryPatch(name: ' '), fields: {'name'}),
      (name: 'invalid id', id: 0, patch: const CategoryPatch(name: 'A'), fields: {'id'}),
    ];

    for (final c in cases) {
      test(c.name, () async {
        await expectLater(
          usecase(c.id, c.patch),
          throwsA(isA<ValidationFailure>().having((f) => f.issues.keys.toSet(), 'fields', c.fields)),
        );
        verifyNever(() => repo.updateCategory(any(), any()));
      });
    }
  });
}
