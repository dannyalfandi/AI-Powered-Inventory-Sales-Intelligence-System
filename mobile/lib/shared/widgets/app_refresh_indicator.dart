import 'package:flutter/material.dart';

/// Pull-to-refresh, themed once for the whole app.
///
/// `RefreshIndicator` already draws its arrow in `colorScheme.primary`, so it
/// follows the accent the user picked without any help. What it does not do is
/// lift the disc off the page: its default background is the canvas colour, so
/// on a scrolling list the spinner appears to float on nothing. This raises it
/// onto a container surface, which reads in both light and dark mode.
///
/// There is no `RefreshIndicatorThemeData` in this Flutter version, which is
/// why this is a widget rather than an entry in [AppTheme].
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: onRefresh,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: child,
      );
}
