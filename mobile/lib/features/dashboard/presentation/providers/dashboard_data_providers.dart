import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/dashboard.dart';
import '../../domain/entities/forecast.dart';
import 'dashboard_filter_provider.dart';
import 'dashboard_providers.dart';

part 'dashboard_data_providers.g.dart';

// One provider per analytics endpoint: a failing endpoint only puts its own
// section into an error state, and each section shows its own spinner.
//
// All four range-based providers watch `dashboardDateRangeProvider`, so one
// date change refreshes them together — and only the trend also watches the
// granularity, so the daily/weekly toggle costs exactly one request.

@riverpod
Future<DashboardSummary> dashboardSummary(Ref ref) {
  final range = ref.watch(dashboardDateRangeProvider);
  return ref.watch(getDashboardSummaryUseCaseProvider)(range);
}

@riverpod
Future<SalesTrend> dashboardSalesTrend(Ref ref) {
  final range = ref.watch(dashboardDateRangeProvider);
  final granularity = ref.watch(trendGranularityFilterProvider);
  return ref.watch(getSalesTrendUseCaseProvider)(range, granularity);
}

@riverpod
Future<List<TopProduct>> dashboardTopProducts(Ref ref) {
  final range = ref.watch(dashboardDateRangeProvider);
  return ref.watch(getTopProductsUseCaseProvider)(range);
}

@riverpod
Future<List<CategoryBreakdown>> dashboardCategoryBreakdown(Ref ref) {
  final range = ref.watch(dashboardDateRangeProvider);
  return ref.watch(getCategoryBreakdownUseCaseProvider)(range);
}

/// Products at or below their low-stock threshold. Not range-bound: it is
/// "right now" state, so it deliberately does not watch the date range.
@riverpod
Future<int> dashboardLowStockCount(Ref ref) => ref.watch(getLowStockAlertCountUseCaseProvider)();

/// Demand forecast for the best sellers of the range. Like the sections
/// above it follows the date range, so one change reloads it with the rest.
///
/// A report whose `available` is false (the ML service is down) is data, not
/// an error: the section renders a calm "unavailable" state, and `AsyncError`
/// stays reserved for problems reaching our own API.
@riverpod
Future<ForecastReport> dashboardForecast(Ref ref) {
  final range = ref.watch(dashboardDateRangeProvider);
  return ref.watch(getDemandForecastUseCaseProvider)(range);
}

/// Per-product trend sentences, same rules as [dashboardForecast].
@riverpod
Future<InsightReport> dashboardInsights(Ref ref) {
  final range = ref.watch(dashboardDateRangeProvider);
  return ref.watch(getBusinessInsightsUseCaseProvider)(range);
}
