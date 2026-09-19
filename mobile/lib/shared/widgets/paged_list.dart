import 'package:flutter/material.dart';

import '../../core/pagination/paged.dart';

/// Last row of an infinite-scroll list: spinner while loading the next page,
/// retry button after a failure, "load more" button, or the total count.
class PagedListFooter extends StatelessWidget {
  const PagedListFooter({
    super.key,
    required this.state,
    required this.onLoadMore,
    required this.totalLabel,
  });

  final PagedState<Object?> state;
  final VoidCallback onLoadMore;

  /// E.g. `(n) => '$n kategori'`.
  final String Function(int total) totalLabel;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (state.isLoadingMore) {
      child = const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2));
    } else if (state.loadMoreError != null) {
      child = TextButton.icon(
        onPressed: onLoadMore,
        icon: const Icon(Icons.refresh),
        label: Text('Gagal memuat: ${state.loadMoreError!.message}'),
      );
    } else if (state.hasMore) {
      child = TextButton(onPressed: onLoadMore, child: const Text('Muat lebih banyak'));
    } else {
      child = Text(totalLabel(state.total), style: Theme.of(context).textTheme.bodySmall);
    }
    return Padding(padding: const EdgeInsets.all(16), child: Center(child: child));
  }
}

/// Makes non-list content (empty/error views) pull-to-refreshable.
class RefreshableView extends StatelessWidget {
  const RefreshableView({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Calls [onNearEnd] when [controller] scrolls within 300px of the end.
void listenNearEnd(ScrollController controller, VoidCallback onNearEnd) {
  controller.addListener(() {
    if (controller.hasClients && controller.position.extentAfter < 300) onNearEnd();
  });
}
