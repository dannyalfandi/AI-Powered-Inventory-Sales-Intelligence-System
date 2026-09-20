import 'package:flutter/material.dart';

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
        message: 'Insight bisnis sedang tidak tersedia',
        detail: 'Layanan analisis sedang mati. Angka penjualan di halaman ini tetap terbaru.',
        onRetry: onRetry,
        icon: Icons.lightbulb_outline,
      );
    }
    if (report.products.isEmpty) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 120),
        child: const EmptyView(
          message: 'Belum ada penjualan pada rentang ini, jadi belum ada insight.',
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
              insight.summary ?? insight.error ?? 'Tidak ada insight untuk produk ini.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

extension TrendDirectionText on TrendDirection {
  String get label => switch (this) {
    TrendDirection.increasing => 'Naik',
    TrendDirection.decreasing => 'Turun',
    TrendDirection.stable => 'Stabil',
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
          Text(_label, style: theme.textTheme.labelMedium?.copyWith(color: fg)),
        ],
      ),
    );
  }

  /// "Naik 32%" when there is a number, just the direction otherwise.
  String get _label {
    final change = changePercent;
    if (change == null) return trend.label;
    final rounded = change.abs().round();
    return trend == TrendDirection.stable ? trend.label : '${trend.label} $rounded%';
  }
}
