import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/pagination/paged.dart';

void main() {
  group('hasMore', () {
    final cases = <({String name, int page, int pageSize, int total, bool want})>[
      (name: 'more pages left', page: 1, pageSize: 20, total: 21, want: true),
      (name: 'exactly one full page', page: 1, pageSize: 20, total: 20, want: false),
      (name: 'empty', page: 1, pageSize: 20, total: 0, want: false),
      (name: 'last page', page: 3, pageSize: 10, total: 25, want: false),
    ];

    for (final c in cases) {
      test(c.name, () {
        final r = PageResult<int>(items: const [], page: c.page, pageSize: c.pageSize, total: c.total);
        expect(r.hasMore, c.want);
        expect(PagedState.first(r).hasMore, c.want);
      });
    }
  });

  test('append adds the next page, skips duplicates and clears load-more status', () {
    final state = PagedState<int>(
      items: const [1, 2],
      page: 1,
      pageSize: 2,
      total: 4,
      isLoadingMore: true,
      loadMoreError: const NetworkFailure('offline'),
    );

    final next = state.append(const PageResult(items: [2, 3], page: 2, pageSize: 2, total: 5), (i) => i);

    expect(next.items, [1, 2, 3]);
    expect(next.page, 2);
    expect(next.total, 5);
    expect(next.isLoadingMore, isFalse);
    expect(next.loadMoreError, isNull);
  });

  test('canLoadMore is false while a page is loading', () {
    const state = PagedState<int>(items: [1], page: 1, pageSize: 1, total: 5, isLoadingMore: true);
    expect(state.hasMore, isTrue);
    expect(state.canLoadMore, isFalse);
  });
}
