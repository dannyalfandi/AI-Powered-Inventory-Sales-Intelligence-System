import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_refresh_indicator.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../domain/entities/dashboard.dart';
import '../../domain/entities/forecast.dart';
import '../providers/dashboard_data_providers.dart';
import '../providers/dashboard_filter_provider.dart';
import '../widgets/category_breakdown_chart.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/date_range_bar.dart';
import '../widgets/forecast_section.dart';
import '../widgets/insights_section.dart';
import '../widgets/low_stock_card.dart';
import '../widgets/sales_trend_chart.dart';
import '../widgets/summary_cards.dart';
import '../widgets/top_products_section.dart';

/// Home tab: sales analytics for a date range, one section per endpoint.
///
/// Each section is its own `ConsumerWidget` so a rebuild caused by one
/// provider (or by the granularity toggle) does not rebuild the other four —
/// with five parallel calls on this page that matters.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Subscribe (without rebuilding on data) so every section stays alive while
    // the page is: scrolling a card out of the ListView would otherwise dispose
    // its provider, and a date change would reload it late, on scroll back.
    ref.listen(dashboardSummaryProvider, (_, _) {});
    ref.listen(dashboardSalesTrendProvider, (_, _) {});
    ref.listen(dashboardTopProductsProvider, (_, _) {});
    ref.listen(dashboardCategoryBreakdownProvider, (_, _) {});
    ref.listen(dashboardLowStockCountProvider, (_, _) {});
    ref.listen(dashboardForecastProvider, (_, _) {});
    ref.listen(dashboardInsightsProvider, (_, _) {});

    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          IconButton(
            tooltip: l10n.dashboardRefresh,
            onPressed: () => _refreshAll(ref),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            key: const Key('dashboard_settings_button'),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: AppRefreshIndicator(
        onRefresh: () async => _refreshAll(ref),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: const [
            _DateRangeSection(),
            _SummarySection(),
            _LowStockSection(),
            _SalesTrendSection(),
            _InsightsSection(),
            _ForecastSection(),
            _TopProductsSection(),
            _CategorySection(),
          ],
        ),
      ),
    );
  }

  void _refreshAll(WidgetRef ref) {
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(dashboardSalesTrendProvider);
    ref.invalidate(dashboardTopProductsProvider);
    ref.invalidate(dashboardCategoryBreakdownProvider);
    ref.invalidate(dashboardLowStockCountProvider);
    ref.invalidate(dashboardForecastProvider);
    ref.invalidate(dashboardInsightsProvider);
  }
}

class _DateRangeSection extends ConsumerWidget {
  const _DateRangeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(dashboardDateRangeProvider);
    final notifier = ref.read(dashboardDateRangeProvider.notifier);
    return DateRangeBar(range: range, onPreset: notifier.setPresetDays, onCustomRange: notifier.setCustomRange);
  }
}

class _SummarySection extends ConsumerWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    return DashboardSection(
      title: context.l10n.dashboardSummaryTitle,
      child: AsyncSection<DashboardSummary>(
        value: summary,
        onRetry: () => ref.invalidate(dashboardSummaryProvider),
        placeholderHeight: 160,
        skeleton: const SkeletonSummaryGrid(),
        builder: (context, data) => SummaryCards(summary: data),
      ),
    );
  }
}

class _LowStockSection extends ConsumerWidget {
  const _LowStockSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LowStockCard(
      count: ref.watch(dashboardLowStockCountProvider),
      onTap: () => context.pushNamed(AppRoutes.lowStock),
      onRetry: () => ref.invalidate(dashboardLowStockCountProvider),
    );
  }
}

class _SalesTrendSection extends ConsumerWidget {
  const _SalesTrendSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trend = ref.watch(dashboardSalesTrendProvider);
    final granularity = ref.watch(trendGranularityFilterProvider);
    return DashboardSection(
      title: context.l10n.dashboardTrendTitle,
      trailing: SegmentedButton<TrendGranularity>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: [
          ButtonSegment(value: TrendGranularity.daily, label: Text(context.l10n.dashboardTrendDaily)),
          ButtonSegment(value: TrendGranularity.weekly, label: Text(context.l10n.dashboardTrendWeekly)),
        ],
        selected: {granularity},
        onSelectionChanged: (s) => ref.read(trendGranularityFilterProvider.notifier).set(s.first),
      ),
      child: AsyncSection<SalesTrend>(
        value: trend,
        onRetry: () => ref.invalidate(dashboardSalesTrendProvider),
        placeholderHeight: 220,
        skeleton: const SkeletonChart(height: 200),
        builder: (context, data) => SalesTrendChart(trend: data),
      ),
    );
  }
}

class _TopProductsSection extends ConsumerWidget {
  const _TopProductsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(dashboardTopProductsProvider);
    return DashboardSection(
      title: context.l10n.dashboardTopProductsTitle,
      child: AsyncSection<List<TopProduct>>(
        value: products,
        onRetry: () => ref.invalidate(dashboardTopProductsProvider),
        skeleton: const SkeletonList(rows: 4, padding: EdgeInsets.zero),
        builder: (context, data) => TopProductsSection(products: data),
      ),
    );
  }
}

class _CategorySection extends ConsumerWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(dashboardCategoryBreakdownProvider);
    return DashboardSection(
      title: context.l10n.dashboardCategoryTitle,
      child: AsyncSection<List<CategoryBreakdown>>(
        value: categories,
        onRetry: () => ref.invalidate(dashboardCategoryBreakdownProvider),
        placeholderHeight: 180,
        skeleton: const SkeletonChart(height: 160),
        builder: (context, data) => CategoryBreakdownChart(categories: data),
      ),
    );
  }
}

class _InsightsSection extends ConsumerWidget {
  const _InsightsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(dashboardInsightsProvider);
    return DashboardSection(
      title: context.l10n.dashboardInsightsTitle,
      child: AsyncSection<InsightReport>(
        value: insights,
        onRetry: () => ref.invalidate(dashboardInsightsProvider),
        placeholderHeight: 160,
        skeleton: const SkeletonLines(lines: 3, hasLeading: true),
        builder: (context, data) =>
            InsightsSection(report: data, onRetry: () => ref.invalidate(dashboardInsightsProvider)),
      ),
    );
  }
}

class _ForecastSection extends ConsumerWidget {
  const _ForecastSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(dashboardForecastProvider);
    return DashboardSection(
      title: context.l10n.dashboardForecastTitle,
      child: AsyncSection<ForecastReport>(
        value: forecast,
        onRetry: () => ref.invalidate(dashboardForecastProvider),
        placeholderHeight: 160,
        skeleton: const SkeletonList(rows: 3, padding: EdgeInsets.zero),
        builder: (context, data) =>
            ForecastSection(report: data, onRetry: () => ref.invalidate(dashboardForecastProvider)),
      ),
    );
  }
}
