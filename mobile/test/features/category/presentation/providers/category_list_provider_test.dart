import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_list_provider.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/category_fixtures.dart';

void main() {
  late MockCategoryRepository repo;

  setUp(() => repo = MockCategoryRepository());

  ProviderContainer makeContainer() {
    final container = ProviderContainer.test(
      overrides: [categoryRepositoryProvider.overrideWithValue(repo)],
      retry: (_, _) => null,
    );
    container.listen(categoryListProvider, (_, _) {});
    return container;
  }

  void stubPage({int page = 1, int pageSize = 20, String search = '', required Object result}) {
    final call = when(() => repo.getCategories(page: page, pageSize: pageSize, search: search));
    if (result is Failure) {
      call.thenThrow(result);
    } else {
      call.thenAnswer((_) async => result as dynamic);
    }
  }

  test('build loads the first page', () async {
    stubPage(result: categoryPage([category(1), category(2)]));
    final container = makeContainer();

    final state = await container.read(categoryListProvider.future);

    expect(state.items.map((c) => c.id), [1, 2]);
    expect(state.hasMore, isFalse);
  });

  test('initial failure is exposed as AsyncError', () async {
    stubPage(result: const NetworkFailure('offline'));
    final container = makeContainer();

    await expectLater(container.read(categoryListProvider.future), throwsA(isA<NetworkFailure>()));
  });

  test('changing the search query reloads page 1 with that query', () async {
    stubPage(result: categoryPage([category(1), category(2)]));
    stubPage(search: 'minum', result: categoryPage([category(2, name: 'Minuman')]));
    final container = makeContainer();
    await container.read(categoryListProvider.future);

    container.read(categorySearchQueryProvider.notifier).set(' minum ');
    final state = await container.read(categoryListProvider.future);

    expect(state.items.map((c) => c.name), ['Minuman']);
  });

  group('loadMore', () {
    test('appends the next page with the page size from meta', () async {
      stubPage(result: categoryPage([category(1), category(2)], pageSize: 2, total: 3));
      stubPage(page: 2, pageSize: 2, result: categoryPage([category(3)], page: 2, pageSize: 2, total: 3));
      final container = makeContainer();
      await container.read(categoryListProvider.future);

      await container.read(categoryListProvider.notifier).loadMore();

      final state = container.read(categoryListProvider).requireValue;
      expect(state.items.map((c) => c.id), [1, 2, 3]);
      expect(state.hasMore, isFalse);
    });

    test('failure keeps loaded items and records loadMoreError', () async {
      stubPage(result: categoryPage([category(1)], pageSize: 1, total: 2));
      stubPage(page: 2, pageSize: 1, result: const ServerFailure('boom', statusCode: 500));
      final container = makeContainer();
      await container.read(categoryListProvider.future);

      await container.read(categoryListProvider.notifier).loadMore();

      final state = container.read(categoryListProvider).requireValue;
      expect(state.items.map((c) => c.id), [1]);
      expect(state.loadMoreError, isA<ServerFailure>());
      expect(state.isLoadingMore, isFalse);
    });
  });

  group('delete', () {
    test('removes the category', () async {
      stubPage(result: categoryPage([category(1), category(2)]));
      when(() => repo.deleteCategory(1)).thenAnswer((_) async {});
      final container = makeContainer();
      await container.read(categoryListProvider.future);

      await container.read(categoryListProvider.notifier).delete(1);

      final state = container.read(categoryListProvider).requireValue;
      expect(state.items.map((c) => c.id), [2]);
      expect(state.total, 1);
    });

    test('409 (still used by products) keeps the category and rethrows', () async {
      stubPage(result: categoryPage([category(9), category(2)]));
      when(() => repo.deleteCategory(9)).thenThrow(categoryInUseFailure);
      final container = makeContainer();
      await container.read(categoryListProvider.future);

      await expectLater(
        container.read(categoryListProvider.notifier).delete(9),
        throwsA(isA<ServerFailure>().having((f) => f.isConflict, 'isConflict', true)),
      );

      expect(container.read(categoryListProvider).requireValue.items.map((c) => c.id), [9, 2]);
    });
  });

  test('categoryOptions loads every category', () async {
    stubPage(pageSize: 100, result: categoryPage([category(1), category(2)], pageSize: 100));
    final container = ProviderContainer.test(
      overrides: [categoryRepositoryProvider.overrideWithValue(repo)],
      retry: (_, _) => null,
    );

    expect((await container.read(categoryOptionsProvider.future)).map((c) => c.id), [1, 2]);
  });

  group('categoryDeleteErrorMessage', () {
    final minuman = category(9, name: 'Minuman');

    test('409 explains that products still use the category, with the count', () {
      final msg = categoryDeleteErrorMessage(categoryInUseFailure, minuman);
      expect(msg, contains('"Minuman" masih dipakai oleh 3 produk'));
      expect(msg, contains('Pindahkan produk'));
    });

    test('409 without a count in the message still explains the conflict', () {
      final msg = categoryDeleteErrorMessage(const ServerFailure('conflict', statusCode: 409), minuman);
      expect(msg, contains('masih dipakai oleh beberapa produk'));
    });

    test('other failures are reported as a failed delete', () {
      final msg = categoryDeleteErrorMessage(const NetworkFailure('offline'), minuman);
      expect(msg, 'Gagal menghapus kategori: offline');
    });
  });
}
