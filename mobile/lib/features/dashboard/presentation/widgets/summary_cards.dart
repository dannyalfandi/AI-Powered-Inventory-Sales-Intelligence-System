import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/dashboard.dart';

/// Four headline numbers of the selected range, in the order a seller reads
/// them: money in, how many orders produced it, how many items, per-order size.
class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cards = [
      _CardData(l10n.dashboardSummaryRevenue, formatRupiah(summary.totalRevenue), Icons.payments_outlined),
      _CardData(l10n.dashboardSummaryOrders, '${summary.totalOrders}', Icons.receipt_long_outlined),
      _CardData(l10n.dashboardSummaryItemsSold, '${summary.totalItemsSold}', Icons.inventory_2_outlined),
      _CardData(
        l10n.dashboardSummaryAverageOrder,
        formatRupiah(summary.averageOrderValue),
        Icons.calculate_outlined,
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.75,
      children: [for (final c in cards) _SummaryCard(data: c)],
    );
  }
}

class _CardData {
  const _CardData(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _CardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.label,
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              data.value,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
