import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/domain/entities/category.dart';
import 'package:inventory_intel/features/category/domain/usecases/create_category.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/category_fixtures.dart';

void main() {
  late MockCategoryRepository repo;
  late CreateCategory usecase;

  setUpAll(registerCategoryFallbacks);

  setUp(() {
    repo = MockCategoryRepository();
    usecase = CreateCategory(repo);
  });

  test('trims input and creates the category', () async {
    const trimmed = CategoryInput(name: 'Minuman', description: 'Kopi, teh');
    when(() => repo.createCategory(trimmed)).thenAnswer((_) async => category(1, name: 'Minuman'));

    final result = await usecase(const CategoryInput(name: '  Minuman ', description: ' Kopi, teh '));

    expect(result.name, 'Minuman');
    verify(() => repo.createCategory(trimmed)).called(1);
  });

  group('rejects invalid input locally', () {
    final cases = <({String name, CategoryInput input})>[
      (name: 'blank name', input: const CategoryInput(name: '   ')),
      (name: 'name longer than 100', input: CategoryInput(name: 'N' * (CategoryRules.nameMaxLength + 1))),
    ];

    for (final c in cases) {
      test(c.name, () async {
        await expectLater(
          usecase(c.input),
          throwsA(isA<ValidationFailure>().having((f) => f.issues.keys, 'fields', ['name'])),
        );
        verifyNever(() => repo.createCategory(any()));
      });
    }
  });

  test('propagates duplicate name conflict from the backend', () async {
    when(() => repo.createCategory(any()))
        .thenThrow(const ServerFailure('conflict', statusCode: 409, code: 'conflict'));

    await expectLater(
      usecase(const CategoryInput(name: 'Minuman')),
      throwsA(isA<ServerFailure>().having((f) => f.isConflict, 'isConflict', true)),
    );
  });
}
