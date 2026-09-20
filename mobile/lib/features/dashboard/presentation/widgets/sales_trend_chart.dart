import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/dashboard.dart';

/// Revenue per period. The backend gap-fills empty periods with zeros, so the
/// x axis is simply the point index.
class SalesTrendChart extends StatelessWidget {
  const SalesTrendChart({super.key, required this.trend});

  final SalesTrend trend;

  static const _height = 220.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final points = trend.points;
    if (points.isEmpty) {
      return const SizedBox(
        height: _height,
        child: EmptyView(message: 'Tidak ada periode pada rentang ini.', icon: Icons.show_chart),
      );
    }
    if (!trend.hasSales) {
      return const SizedBox(
        height: _height,
        child: EmptyView(message: 'Belum ada penjualan pada rentang ini.', icon: Icons.show_chart),
      );
    }

    // Round the axis up so the top label is a whole step, never a clipped peak.
    final step = _niceStep(trend.maxRevenue / 4);
    final maxY = step * 4;
    final labelEvery = (points.length / 4).ceil().clamp(1, points.length);

    return SizedBox(
      height: _height,
      // Right padding: the label of the last point is centred on it and would
      // otherwise be clipped by the card edge.
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxY,
            minX: 0,
            maxX: (points.length - 1).toDouble(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: step,
              getDrawingHorizontalLine: (_) => FlLine(color: theme.colorScheme.outlineVariant, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: step,
                  reservedSize: 58,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      formatRupiahCompact(value.round()),
                      style: theme.textTheme.labelSmall,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final i = value.round();
                    if (i < 0 || i >= points.length) return const SizedBox.shrink();
                    if (i % labelEvery != 0 && i != points.length - 1) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(formatDayMonth(points[i].periodStart), style: theme.textTheme.labelSmall),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                getTooltipItems: (spots) => [
                  for (final s in spots)
                    LineTooltipItem(
                      '${_periodLabel(points[s.x.round()])}\n'
                      '${formatRupiah(points[s.x.round()].revenue)} - '
                      '${points[s.x.round()].orders} pesanan',
                      TextStyle(color: theme.colorScheme.onInverseSurface, fontSize: 12),
                    ),
                ],
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].revenue.toDouble())],
                isCurved: false,
                barWidth: 2,
                color: theme.colorScheme.primary,
                dotData: FlDotData(show: points.length <= 15),
                belowBarData: BarAreaData(show: true, color: theme.colorScheme.primary.withValues(alpha: 0.12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _periodLabel(SalesTrendPoint p) => p.periodStart == p.periodEnd
      ? formatDate(p.periodStart)
      : '${formatDayMonth(p.periodStart)} - ${formatDate(p.periodEnd)}';

  /// Rounds an axis step up to 1/2/5 x 10^n so labels stay readable.
  static double _niceStep(double raw) {
    if (raw <= 1) return 1;
    final magnitude = 1.0 * _pow10(raw.floor().toString().length - 1);
    final normalized = raw / magnitude;
    final factor = normalized <= 1 ? 1 : (normalized <= 2 ? 2 : (normalized <= 5 ? 5 : 10));
    return factor * magnitude;
  }

  static int _pow10(int exp) {
    var v = 1;
    for (var i = 0; i < exp; i++) {
      v *= 10;
    }
    return v;
  }
}
