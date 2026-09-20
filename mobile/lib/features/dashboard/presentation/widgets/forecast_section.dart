import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/forecast.dart';
import 'unavailable_view.dart';

/// Predicted demand per product: one row each, with a sparkline of the
/// horizon and the total it adds up to.
///
/// Three "nothing to show" cases, deliberately told apart:
///  * the ML service is down → [UnavailableView], calm and grey;
///  * nothing was sold in the range → an empty state;
///  * one product failed while others worked → that row alone is greyed out.
class ForecastSection extends StatelessWidget {
  const ForecastSection({super.key, required this.report, required this.onRetry});

  final ForecastReport report;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (!report.available) {
      return UnavailableView(
        message: 'Prediksi permintaan sedang tidak tersedia',
        detail: 'Layanan forecasting sedang mati. Data penjualan lain di halaman ini tetap terbaru.',
        onRetry: onRetry,
      );
    }
    if (report.products.isEmpty) {
      // A minimum height, not a fixed one: the message wraps on narrow phones.
      return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 120),
        child: const EmptyView(
          message: 'Belum ada produk terjual pada rentang ini, jadi belum ada yang bisa diprediksi.',
          icon: Icons.query_stats_outlined,
        ),
      );
    }

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${report.horizonDays} hari ke depan, dari rata-rata penjualan harian',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        for (final product in report.products) _ForecastRow(product: product),
      ],
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.product});

  final ProductForecast product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final failed = product.hasError;
    final titleColor = failed ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        // A failed product stays in the list (its name is still useful), but
        // reads as inactive rather than as an alarm.
        opacity: failed ? 0.6 : 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(color: titleColor),
                  ),
                  Text(
                    failed ? '${product.sku} · ${product.error}' : product.sku,
                    maxLines: 2,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (failed)
              Icon(Icons.remove, color: theme.colorScheme.onSurfaceVariant)
            else ...[
              SizedBox(width: 64, height: 28, child: _Sparkline(product: product)),
              const SizedBox(width: 12),
              _Total(product: product),
            ],
          ],
        ),
      ),
    );
  }
}

/// Total over the horizon — the number a seller acts on ("stock about this
/// many"), with the per-day average underneath for context.
class _Total extends StatelessWidget {
  const _Total({required this.product});

  final ProductForecast product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = product.forecast.length;
    final perDay = days == 0 ? 0.0 : product.totalPredicted / days;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${_unit(product.totalPredicted)} unit',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          '${_unit(perDay)}/hari',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  /// One decimal, Indonesian comma; whole numbers stay whole.
  static String _unit(double value) {
    final text = value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
    return text.replaceAll('.', ',');
  }
}

/// Tiny line of the predicted days: no axes, no labels, just the shape.
/// A flat moving-average forecast draws a flat line, which is honest.
class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.product});

  final ProductForecast product;

  @override
  Widget build(BuildContext context) {
    final points = product.forecast;
    if (points.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    // Give a flat line room to sit in the middle of the box.
    final maxY = product.peakPredicted == 0 ? 1.0 : product.peakPredicted * 1.4;
    return Semantics(
      label: 'Prediksi ${product.productName} sampai ${formatDayMonth(points.last.date)}',
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          minX: 0,
          maxX: (points.length - 1).toDouble().clamp(1, double.infinity),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].predictedQuantity)],
              isCurved: false,
              barWidth: 2,
              color: theme.colorScheme.primary,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: theme.colorScheme.primary.withValues(alpha: 0.12)),
            ),
          ],
        ),
      ),
    );
  }
}
