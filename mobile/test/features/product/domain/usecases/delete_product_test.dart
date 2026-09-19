import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/product/domain/usecases/delete_product.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/product_fixtures.dart';

void main() {
  late MockProductRepository repo;
  late DeleteProduct usecase;

  setUp(() {
    repo = MockProductRepository();
    usecase = DeleteProduct(repo);
  });

  test('deletes via the repository', () async {
    when(() => repo.deleteProduct(4)).thenAnswer((_) async {});

    await usecase(4);

    verify(() => repo.deleteProduct(4)).called(1);
  });

  test('propagates failure', () async {
    when(() => repo.deleteProduct(4)).thenThrow(const ServerFailure('not found', statusCode: 404));

    await expectLater(usecase(4), throwsA(isA<ServerFailure>()));
  });

  test('rejects invalid id without calling the repository', () async {
    await expectLater(usecase(0), throwsA(isA<ValidationFailure>()));
    verifyNever(() => repo.deleteProduct(any()));
  });
}
