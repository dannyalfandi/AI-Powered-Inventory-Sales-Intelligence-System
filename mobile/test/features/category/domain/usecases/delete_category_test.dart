import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/domain/usecases/delete_category.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/category_fixtures.dart';

void main() {
  late MockCategoryRepository repo;
  late DeleteCategory usecase;

  setUp(() {
    repo = MockCategoryRepository();
    usecase = DeleteCategory(repo);
  });

  test('deletes by id', () async {
    when(() => repo.deleteCategory(9)).thenAnswer((_) async {});

    await usecase(9);

    verify(() => repo.deleteCategory(9)).called(1);
  });

  test('propagates 409 while products still use the category', () async {
    when(() => repo.deleteCategory(9)).thenThrow(categoryInUseFailure);

    await expectLater(
      usecase(9),
      throwsA(isA<ServerFailure>().having((f) => f.isConflict, 'isConflict', true)),
    );
  });

  test('rejects an invalid id locally', () async {
    await expectLater(usecase(0), throwsA(isA<ValidationFailure>()));
    verifyNever(() => repo.deleteCategory(any()));
  });
}
