import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_status_colors.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../domain/entities/inventory.dart';

/// Current quantity, threshold and low-stock status of one product.
class StockSummaryCard extends StatelessWidget {
  const StockSummaryCard({super.key, required this.inventory});

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = AppStatusColors.of(context);
    final low = inventory.isLowStock;
    final empty = inventory.quantity == 0;
    // Out of stock is not the same as merely low: one stops you selling today,
    // the other is a reminder to reorder. They get different colours.
    final palette = empty
        ? colors.negative
        : low
            ? colors.warning
            : colors.positive;

    return Card(
      key: const Key('stock_summary_card'),
      color: palette.container,
      child: Padding(
        padding: AppSpacing.allLg,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.inventoryCurrentStock,
                    style: theme.textTheme.labelLarge?.copyWith(color: palette.onContainer),
                  ),
                  Text(
                    '${inventory.quantity}',
                    key: const Key('stock_quantity'),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: palette.onContainer,
                      fontFeatures: AppTypography.tabularFigures,
                    ),
                  ),
                  Text(
                    l10n.inventoryThresholdLine(inventory.lowStockThreshold),
                    style: theme.textTheme.bodyMedium?.copyWith(color: palette.onContainer),
                  ),
                ],
              ),
            ),
            Chip(
              key: const Key('stock_status'),
              backgroundColor: palette.onContainer.withValues(alpha: 0.10),
              side: BorderSide(color: palette.onContainer.withValues(alpha: 0.35)),
              avatar: Icon(
                empty
                    ? Icons.remove_shopping_cart_outlined
                    : low
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                size: 18,
                color: palette.onContainer,
              ),
              labelStyle: theme.textTheme.labelMedium?.copyWith(color: palette.onContainer),
              label: Text(
                empty
                    ? l10n.inventoryOutOfStock
                    : (low ? l10n.productStockLow : l10n.inventoryHealthy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
