import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_status_colors.dart';
import '../../../../shared/widgets/skeleton.dart';

/// Badge for the number of products at or below their low-stock threshold.
///
/// The card is tappable in every state — including while the count is loading
/// or failed — so the Low Stock page stays reachable even when this one
/// endpoint is down. The count is "right now" data, not range-bound.
class LowStockCard extends StatelessWidget {
  const LowStockCard({super.key, required this.count, required this.onTap, required this.onRetry});

  final AsyncValue<int> count;
  /// Null when the user can't open the low-stock list (no inventory.view).
  final VoidCallback? onTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final value = count.value;
    final alerting = (value ?? 0) > 0;
    final colors = AppStatusColors.of(context);
    final color = alerting ? colors.warning.accent : colors.positive.accent;

    final l10n = context.l10n;
    return Card(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: ListTile(
        onTap: onTap,
        leading: Icon(alerting ? Icons.warning_amber : Icons.check_circle_outline, color: color),
        title: Text(l10n.dashboardLowStockTitle),
        subtitle: Text(switch (count) {
          AsyncValue(hasError: true) => l10n.dashboardLowStockCountFailed,
          AsyncValue(hasValue: true, value: final v) when v == 0 => l10n.dashboardLowStockAllGood,
          AsyncValue(hasValue: true) => l10n.dashboardLowStockSubtitle,
          _ => l10n.commonLoading,
        }),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (count.hasError)
              IconButton(onPressed: onRetry, icon: const Icon(Icons.refresh), tooltip: l10n.dashboardLowStockReload)
            else if (!count.hasValue)
              const SkeletonBox(width: 34, height: 22, radius: 999)
            else
              _CountBadge(count: value!, color: color),
            if (onTap != null) const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
      child: Text(
        '$count',
        style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
