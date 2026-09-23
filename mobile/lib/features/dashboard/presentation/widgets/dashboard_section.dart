import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_motion.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/skeleton.dart';
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
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: Padding(
        padding: AppSpacing.allMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
                ?trailing,
              ],
            ),
            const SizedBox(height: AppSpacing.md),
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
    this.skeleton,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) builder;
  final double placeholderHeight;

  /// The loading placeholder, shaped like this section's own content. Falls
  /// back to text lines, which suits the list-like sections; the chart and
  /// the card grid pass their own.
  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if (value.hasError && !value.isLoading) {
      // A minimum height, not a fixed one: the retry button must stay inside
      // the box (and therefore tappable) however long the message is.
      content = ConstrainedBox(
        key: const ValueKey('error'),
        constraints: BoxConstraints(minHeight: placeholderHeight),
        child: ErrorView(message: errorMessage(context, value.error!), onRetry: onRetry),
      );
    } else if (!value.hasValue) {
      content = KeyedSubtree(
        key: const ValueKey('loading'),
        child: skeleton ?? const SkeletonLines(lines: 3, hasLeading: true),
      );
    } else {
      content = Column(
        key: const ValueKey('data'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: AppSpacing.xs,
            child: value.isLoading ? const LinearProgressIndicator(minHeight: 2) : null,
          ),
          builder(context, value.requireValue),
        ],
      );
    }

    // Keys, so the switcher can tell the three states apart: real data fades
    // out of the skeleton instead of replacing it in one frame. Data that is
    // merely *refreshing* keeps the same key, so it stays put under the
    // hairline progress bar rather than flashing.
    return AnimatedSwitcher(
      duration: AppMotion.durationOf(context, AppMotion.page),
      child: content,
    );
  }
}
