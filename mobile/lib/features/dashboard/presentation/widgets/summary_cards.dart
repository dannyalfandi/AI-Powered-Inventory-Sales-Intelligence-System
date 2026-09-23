import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/animated_count.dart';
import '../../domain/entities/dashboard.dart';

/// Four headline numbers of the selected range, in the order a seller reads
/// them: money in, how many orders produced it, how many items, per-order size.
class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // The value is passed as a number, not a string, so the card can count up
    // to it; each card keeps its own formatter because money and counts are
    // written differently.
    final cards = [
      _CardData(l10n.dashboardSummaryRevenue, summary.totalRevenue, _rupiah, Icons.payments_outlined),
      _CardData(l10n.dashboardSummaryOrders, summary.totalOrders, _count, Icons.receipt_long_outlined),
      _CardData(l10n.dashboardSummaryItemsSold, summary.totalItemsSold, _count, Icons.inventory_2_outlined),
      _CardData(
        l10n.dashboardSummaryAverageOrder,
        summary.averageOrderValue,
        _rupiah,
        Icons.calculate_outlined,
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.75,
      children: [for (final c in cards) _SummaryCard(data: c)],
    );
  }

  static String _rupiah(num value) => formatRupiah(value.round());

  static String _count(num value) => '${value.round()}';
}

class _CardData {
  const _CardData(this.label, this.value, this.format, this.icon);

  final String label;
  final num value;
  final String Function(num value) format;
  final IconData icon;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _CardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  data.label,
                  style: theme.textTheme.metricLabel?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Scaled down rather than wrapped: a long Rupiah figure must stay on
          // one line, and the card's height is fixed by the grid.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedCount(
              value: data.value,
              format: data.format,
              style: theme.textTheme.metric?.copyWith(color: theme.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
