import 'package:flutter/material.dart';

import '../../domain/entities/inventory.dart';

/// Current quantity, threshold and low-stock status of one product.
class StockSummaryCard extends StatelessWidget {
  const StockSummaryCard({super.key, required this.inventory});

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final low = inventory.isLowStock;
    final empty = inventory.quantity == 0;

    return Card(
      key: const Key('stock_summary_card'),
      margin: EdgeInsets.zero,
      color: low ? scheme.errorContainer : scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stok saat ini', style: theme.textTheme.labelLarge),
                  Text(
                    '${inventory.quantity}',
                    key: const Key('stock_quantity'),
                    style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Batas stok menipis: ${inventory.lowStockThreshold}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Chip(
              key: const Key('stock_status'),
              avatar: Icon(low ? Icons.warning_amber_rounded : Icons.check_circle_outline, size: 18),
              label: Text(empty ? 'Habis' : (low ? 'Stok menipis' : 'Aman')),
            ),
          ],
        ),
      ),
    );
  }
}
