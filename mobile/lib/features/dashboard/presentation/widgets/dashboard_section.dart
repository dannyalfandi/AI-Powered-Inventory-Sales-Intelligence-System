import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/state_views.dart';

/// Card wrapper shared by every dashboard block: a title row plus content.
class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key, required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Renders one section from its own [AsyncValue] so a failing endpoint never
/// blanks the rest of the dashboard: loading and error stay inside this box,
/// and [onRetry] refetches only this section.
///
/// While refreshing (e.g. after a date-range change) the previous data stays on
/// screen under a thin progress bar instead of collapsing to a spinner.
class AsyncSection<T> extends StatelessWidget {
  const AsyncSection({
    super.key,
    required this.value,
    required this.onRetry,
    required this.builder,
    this.placeholderHeight = 140,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) builder;
  final double placeholderHeight;

  @override
  Widget build(BuildContext context) {
    if (value.hasError && !value.isLoading) {
      // A minimum height, not a fixed one: the retry button must stay inside
      // the box (and therefore tappable) however long the message is.
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: placeholderHeight),
        child: ErrorView(message: errorMessage(context, value.error!), onRetry: onRetry),
      );
    }
    if (!value.hasValue) {
      return SizedBox(height: placeholderHeight, child: const LoadingView());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 4, child: value.isLoading ? const LinearProgressIndicator(minHeight: 2) : null),
        builder(context, value.requireValue),
      ],
    );
  }
}
