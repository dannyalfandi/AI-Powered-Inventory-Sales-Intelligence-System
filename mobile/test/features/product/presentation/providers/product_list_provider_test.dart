import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_list_provider.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/product_fixtures.dart';

void main() {
  late MockProductRepository repo;

  setUp(() => repo = MockProductRepository());

  ProviderContainer makeContainer() {
    final container = ProviderContainer.test(
      overrides: [productRepositoryProvider.overrideWithValue(repo)],
      retry: (_, _) => null,
    );
    // productListProvider is auto-dispose; keep it alive for the test.
    container.listen(productListProvider, (_, _) {});
    return container;
  }

  void stubPage({int page = 1, int pageSize = 20, String search = '', required Object result}) {
    final call = when(() => repo.getProducts(page: page, pageSize: pageSize, search: search));
    if (result is Failure) {
      call.thenThrow(result);
    } else {
      call.thenAnswer((_) async => result as dynamic);
    }
  }

  test('build loads the first page', () async {
    stubPage(result: productPage([product(1), product(2)], total: 2));
    final container = makeContainer();

    final state = await container.read(productListProvider.future);

    expect(state.items.map((p) => p.id), [1, 2]);
    expect(state.hasMore, isFalse);
  });

  test('initial failure is exposed as AsyncError with the Failure', () async {
    stubPage(result: const NetworkFailure('offline'));
    final container = makeContainer();

    await expectLater(container.read(productListProvider.future), throwsA(isA<NetworkFailure>()));
    expect(container.read(productListProvider).error, isA<NetworkFailure>());
  });

  test('changing the search query reloads page 1 with that query', () async {
    stubPage(result: productPage([product(1), product(2)]));
    stubPage(search: 'kopi', result: productPage([product(2, name: 'Kopi')]));
    final container = makeContainer();
    await container.read(productListProvider.future);

    container.read(productSearchQueryProvider.notifier).set('  kopi ');
    final state = await container.read(productListProvider.future);

    expect(state.search, 'kopi');
    expect(state.items.map((p) => p.id), [2]);
  });

  group('loadMore', () {
    final cases = <({String name, Object page2, List<int> wantIds, bool wantError})>[
      (
        name: 'appends next page and skips duplicates',
        page2: productPage([product(2), product(3)], page: 2, pageSize: 2, total: 3),
        wantIds: [1, 2, 3],
        wantError: false,
      ),
      (
        name: 'failure keeps loaded items and records loadMoreError',
        page2: const ServerFailure('boom', statusCode: 500),
        wantIds: [1, 2],
        wantError: true,
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        // First request always asks for 20; backend meta says page_size 2, so
        // loadMore must request page 2 with the page size from meta.
        stubPage(result: productPage([product(1), product(2)], pageSize: 2, total: 3));
        stubPage(page: 2, pageSize: 2, result: c.page2);
        final container = makeContainer();
        await container.read(productListProvider.future);

        await container.read(productListProvider.notifier).loadMore();

        final state = container.read(productListProvider).requireValue;
        expect(state.items.map((p) => p.id), c.wantIds);
        expect(state.isLoadingMore, isFalse);
        expect(state.loadMoreError != null, c.wantError);
      });
    }

    test('does nothing when there are no more pages', () async {
      stubPage(result: productPage([product(1)], total: 1));
      final container = makeContainer();
      await container.read(productListProvider.future);

      await container.read(productListProvider.notifier).loadMore();

      verifyNever(() => repo.getProducts(page: 2, pageSize: any(named: 'pageSize'), search: any(named: 'search')));
    });
  });

  group('delete', () {
    test('removes the product', () async {
      stubPage(result: productPage([product(1), product(2)]));
      when(() => repo.deleteProduct(1)).thenAnswer((_) async {});
      final container = makeContainer();
      await container.read(productListProvider.future);

      await container.read(productListProvider.notifier).delete(1);

      final state = container.read(productListProvider).requireValue;
      expect(state.items.map((p) => p.id), [2]);
      expect(state.total, 1);
    });

    test('restores the product and rethrows when the API fails', () async {
      stubPage(result: productPage([product(1), product(2)]));
      when(() => repo.deleteProduct(1)).thenThrow(const NetworkFailure('offline'));
      final container = makeContainer();
      await container.read(productListProvider.future);

      await expectLater(
        container.read(productListProvider.notifier).delete(1),
        throwsA(isA<NetworkFailure>()),
      );

      expect(container.read(productListProvider).requireValue.items.map((p) => p.id), [1, 2]);
    });
  });
}
