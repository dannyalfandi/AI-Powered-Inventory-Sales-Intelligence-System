import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/product/domain/usecases/get_products.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/product_fixtures.dart';

void main() {
  late MockProductRepository repo;
  late GetProducts usecase;

  setUp(() {
    repo = MockProductRepository();
    usecase = GetProducts(repo);
  });

  group('GetProducts normalizes params before calling the repository', () {
    final cases = <({String name, int page, int pageSize, String search, int wantPage, int wantSize, String wantSearch})>[
      (name: 'passes valid params', page: 2, pageSize: 20, search: 'kopi', wantPage: 2, wantSize: 20, wantSearch: 'kopi'),
      (name: 'page below 1 becomes 1', page: 0, pageSize: 20, search: '', wantPage: 1, wantSize: 20, wantSearch: ''),
      (name: 'page size clamped to 100', page: 1, pageSize: 500, search: '', wantPage: 1, wantSize: 100, wantSearch: ''),
      (name: 'page size at least 1', page: 1, pageSize: 0, search: '', wantPage: 1, wantSize: 1, wantSearch: ''),
      (name: 'search is trimmed', page: 1, pageSize: 20, search: '  teh ', wantPage: 1, wantSize: 20, wantSearch: 'teh'),
    ];

    for (final c in cases) {
      test(c.name, () async {
        final expected = productPage([product(1)]);
        when(() => repo.getProducts(page: c.wantPage, pageSize: c.wantSize, search: c.wantSearch))
            .thenAnswer((_) async => expected);

        final result = await usecase(page: c.page, pageSize: c.pageSize, search: c.search);

        expect(result, expected);
        verify(() => repo.getProducts(page: c.wantPage, pageSize: c.wantSize, search: c.wantSearch))
            .called(1);
      });
    }
  });

  test('propagates repository failure', () async {
    when(() => repo.getProducts(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
        .thenThrow(const NetworkFailure('offline'));

    expect(usecase(), throwsA(isA<NetworkFailure>()));
  });
}
