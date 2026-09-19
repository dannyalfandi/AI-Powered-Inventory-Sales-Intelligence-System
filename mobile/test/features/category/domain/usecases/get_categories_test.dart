import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/domain/usecases/get_categories.dart';
import 'package:inventory_intel/features/category/domain/usecases/get_category_by_id.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/category_fixtures.dart';

void main() {
  late MockCategoryRepository repo;
  late GetCategories usecase;

  setUp(() {
    repo = MockCategoryRepository();
    usecase = GetCategories(repo);
  });

  group('normalizes arguments', () {
    final cases = <({String name, int page, int pageSize, String search, int wantPage, int wantSize, String wantSearch})>[
      (name: 'defaults kept', page: 1, pageSize: 20, search: '', wantPage: 1, wantSize: 20, wantSearch: ''),
      (name: 'page below 1', page: 0, pageSize: 20, search: '', wantPage: 1, wantSize: 20, wantSearch: ''),
      (name: 'page size clamped', page: 2, pageSize: 500, search: '', wantPage: 2, wantSize: 100, wantSearch: ''),
      (name: 'search trimmed', page: 1, pageSize: 20, search: ' minum ', wantPage: 1, wantSize: 20, wantSearch: 'minum'),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.getCategories(page: c.wantPage, pageSize: c.wantSize, search: c.wantSearch))
            .thenAnswer((_) async => categoryPage([]));

        await usecase(page: c.page, pageSize: c.pageSize, search: c.search);

        verify(() => repo.getCategories(page: c.wantPage, pageSize: c.wantSize, search: c.wantSearch)).called(1);
      });
    }
  });

  test('all() fetches pages of 100 until there are no more', () async {
    when(() => repo.getCategories(page: 1, pageSize: 100, search: ''))
        .thenAnswer((_) async => categoryPage([category(1), category(2)], pageSize: 2, total: 3));
    when(() => repo.getCategories(page: 2, pageSize: 100, search: ''))
        .thenAnswer((_) async => categoryPage([category(3)], page: 2, pageSize: 2, total: 3));

    final all = await usecase.all();

    expect(all.map((c) => c.id), [1, 2, 3]);
    verifyNever(() => repo.getCategories(page: 3, pageSize: any(named: 'pageSize'), search: any(named: 'search')));
  });

  test('all() stops at maxPages', () async {
    when(
      () => repo.getCategories(page: any(named: 'page'), pageSize: 100, search: ''),
    ).thenAnswer((inv) async => categoryPage([category(inv.namedArguments[#page] as int)], pageSize: 1, total: 999));

    final all = await usecase.all(maxPages: 3);

    expect(all, hasLength(3));
  });

  group('GetCategoryById', () {
    test('loads by id', () async {
      when(() => repo.getCategoryById(4)).thenAnswer((_) async => category(4));

      expect((await GetCategoryById(repo)(4)).id, 4);
    });

    test('rejects an invalid id locally', () async {
      await expectLater(GetCategoryById(repo)(-1), throwsA(isA<ValidationFailure>()));
      verifyNever(() => repo.getCategoryById(any()));
    });
  });
}
