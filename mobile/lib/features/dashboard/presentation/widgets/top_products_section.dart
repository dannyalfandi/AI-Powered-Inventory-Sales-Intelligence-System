import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/dashboard.dart';

/// Best sellers of the range, ranked by revenue (the backend already sorts
/// them). The bar under each row is revenue relative to the top product, so the
/// list doubles as a bar chart without taking the height a real chart needs.
class TopProductsSection extends StatelessWidget {
  const TopProductsSection({super.key, required this.products});

  final List<TopProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return SizedBox(
        height: 120,
        child: EmptyView(
          message: context.l10n.dashboardTopProductsEmpty,
          icon: Icons.emoji_events_outlined,
        ),
      );
    }
    final top = products.map((p) => p.revenue).reduce((a, b) => a > b ? a : b);
    return Column(
      children: [
        for (var i = 0; i < products.length; i++) _TopProductRow(rank: i + 1, product: products[i], maxRevenue: top),
      ],
    );
  }
}

class _TopProductRow extends StatelessWidget {
  const _TopProductRow({required this.rank, required this.product, required this.maxRevenue});

  final int rank;
  final TopProduct product;
  final int maxRevenue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraction = maxRevenue == 0 ? 0.0 : product.revenue / maxRevenue;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 24, child: Text('$rank.', style: theme.textTheme.bodyMedium)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(
                      context.l10n.dashboardTopProductSold(product.sku, product.quantitySold),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                formatRupiah(product.revenue),
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}
