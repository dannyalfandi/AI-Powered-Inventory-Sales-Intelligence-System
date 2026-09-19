import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/product/domain/usecases/get_product_by_id.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/product_fixtures.dart';

void main() {
  late MockProductRepository repo;
  late GetProductById usecase;

  setUp(() {
    repo = MockProductRepository();
    usecase = GetProductById(repo);
  });

  test('returns the product from the repository', () async {
    when(() => repo.getProductById(7)).thenAnswer((_) async => product(7));

    expect(await usecase(7), product(7));
  });

  test('propagates not-found ServerFailure', () async {
    when(() => repo.getProductById(7))
        .thenThrow(const ServerFailure('not found', statusCode: 404, code: 'not_found'));

    await expectLater(
      usecase(7),
      throwsA(isA<ServerFailure>().having((f) => f.isNotFound, 'isNotFound', true)),
    );
  });

  for (final id in [0, -1]) {
    test('rejects invalid id $id without calling the repository', () async {
      await expectLater(usecase(id), throwsA(isA<ValidationFailure>()));
      verifyNever(() => repo.getProductById(any()));
    });
  }
}
