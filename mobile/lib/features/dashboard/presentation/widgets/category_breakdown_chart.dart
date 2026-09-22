import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/dashboard.dart';

/// Revenue share per category, as a donut plus a legend with the exact numbers
/// (a pie alone cannot be read precisely on a phone).
///
/// Products without a category come back from the backend with
/// `category_id: null` and the name "Tanpa Kategori"; that slice is always
/// grey, so it reads as "not classified" rather than as another category.
class CategoryBreakdownChart extends StatelessWidget {
  const CategoryBreakdownChart({super.key, required this.categories});

  final List<CategoryBreakdown> categories;

  static const _palette = [
    Color(0xFF2E7D32),
    Color(0xFF1565C0),
    Color(0xFFEF6C00),
    Color(0xFF6A1B9A),
    Color(0xFF00838F),
    Color(0xFFC62828),
    Color(0xFF4E342E),
    Color(0xFF283593),
  ];
  static const _uncategorizedColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final withRevenue = categories.where((c) => c.revenue > 0).toList();
    if (withRevenue.isEmpty) {
      return SizedBox(
        height: 140,
        child: EmptyView(message: context.l10n.dashboardCategoryEmpty, icon: Icons.pie_chart_outline),
      );
    }

    final total = withRevenue.fold<int>(0, (sum, c) => sum + c.revenue);
    final colors = <Color>[];
    var paletteIndex = 0;
    for (final c in withRevenue) {
      if (c.isUncategorized) {
        colors.add(_uncategorizedColor);
      } else {
        colors.add(_palette[paletteIndex % _palette.length]);
        paletteIndex++;
      }
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 44,
              sections: [
                for (var i = 0; i < withRevenue.length; i++)
                  PieChartSectionData(
                    value: withRevenue[i].revenue.toDouble(),
                    color: colors[i],
                    radius: 40,
                    title: _percentLabel(withRevenue[i].revenue, total),
                    titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < withRevenue.length; i++)
          _LegendRow(category: withRevenue[i], color: colors[i], total: total),
      ],
    );
  }

  /// Hides the label on slivers too small to hold text.
  static String _percentLabel(int revenue, int total) {
    final share = revenue / total * 100;
    return share < 8 ? '' : '${share.round()}%';
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.category, required this.color, required this.total});

  final CategoryBreakdown category;
  final Color color;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final share = (category.revenue / total * 100).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category.categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: category.isUncategorized
                  ? theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)
                  : theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          Text('$share%', style: theme.textTheme.bodySmall),
          const SizedBox(width: 12),
          Text(
            formatRupiah(category.revenue),
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
