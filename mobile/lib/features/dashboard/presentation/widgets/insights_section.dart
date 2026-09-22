import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/forecast.dart';
import 'unavailable_view.dart';

/// One sentence per product, written by the backend (statistics, not an LLM),
/// with a badge for the direction. Same three "nothing to show" cases as the
/// forecast section.
class InsightsSection extends StatelessWidget {
  const InsightsSection({super.key, required this.report, required this.onRetry});

  final InsightReport report;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (!report.available) {
      return UnavailableView(
        message: context.l10n.dashboardInsightsUnavailable,
        detail: context.l10n.dashboardInsightsUnavailableDetail,
        onRetry: onRetry,
        icon: Icons.lightbulb_outline,
      );
    }
    if (report.products.isEmpty) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 120),
        child: EmptyView(
          message: context.l10n.dashboardInsightsEmpty,
          icon: Icons.lightbulb_outline,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final product in report.products) _InsightRow(insight: product)],
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight});

  final ProductInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final failed = insight.hasError;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: failed ? 0.6 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    insight.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                if (insight.trend != null) TrendBadge(trend: insight.trend!, changePercent: insight.changePercent),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              insight.summary ?? insight.error ?? context.l10n.dashboardInsightsNone,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

extension TrendDirectionText on TrendDirection {
  /// Needs a context because the wording is read from the ARB files; the
  /// enum value is what the ML service sends.
  String label(BuildContext context) => switch (this) {
    TrendDirection.increasing => context.l10n.trendUp,
    TrendDirection.decreasing => context.l10n.trendDown,
    TrendDirection.stable => context.l10n.trendStable,
  };

  IconData get icon => switch (this) {
    TrendDirection.increasing => Icons.trending_up,
    TrendDirection.decreasing => Icons.trending_down,
    TrendDirection.stable => Icons.trending_flat,
  };
}

/// Direction chip. Colour carries the meaning, but the icon and the label
/// carry it too, so it still reads without colour.
class TrendBadge extends StatelessWidget {
  const TrendBadge({super.key, required this.trend, this.changePercent});

  final TrendDirection trend;
  final double? changePercent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final (bg, fg) = switch (trend) {
      TrendDirection.increasing =>
        dark ? (const Color(0xFF1B5E20), const Color(0xFFC8E6C9)) : (const Color(0xFFD7F2DA), const Color(0xFF1B5E20)),
      TrendDirection.decreasing =>
        dark ? (const Color(0xFF7F1D1D), const Color(0xFFFFCDD2)) : (const Color(0xFFFDE0E0), const Color(0xFFB3261E)),
      TrendDirection.stable => (theme.colorScheme.surfaceContainerHighest, theme.colorScheme.onSurfaceVariant),
    };

    return Container(
      key: ValueKey('trend_badge_${trend.name}'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(trend.icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(_label(context), style: theme.textTheme.labelMedium?.copyWith(color: fg)),
        ],
      ),
    );
  }

  /// "Up 32%" when there is a number, just the direction otherwise.
  String _label(BuildContext context) {
    final change = changePercent;
    if (change == null || trend == TrendDirection.stable) return trend.label(context);
    final rounded = change.abs().round();
    return switch (trend) {
      TrendDirection.increasing => context.l10n.trendUpPercent(rounded),
      TrendDirection.decreasing => context.l10n.trendDownPercent(rounded),
      TrendDirection.stable => trend.label(context),
    };
  }
}
