import '../entities/dashboard.dart';
import '../entities/forecast.dart';

/// Analytics data access contract. Implementations throw only `Failure`
/// subclasses (see core/error/failure.dart), never raw transport exceptions.
///
/// Each method maps to one endpoint so the dashboard can render, fail and
/// retry per section instead of as one all-or-nothing page.
abstract interface class DashboardRepository {
  Future<DashboardSummary> getSummary(AnalyticsRange range);

  Future<SalesTrend> getSalesTrend(AnalyticsRange range, TrendGranularity granularity);

  Future<List<TopProduct>> getTopProducts(AnalyticsRange range, {int limit});

  Future<List<CategoryBreakdown>> getCategoryBreakdown(AnalyticsRange range);

  /// Products at or below their low-stock threshold right now (not range-bound).
  Future<int> getLowStockAlertCount();

  /// Demand forecast for the best sellers of the range. A report whose
  /// `available` is false (the ML service is down) is a normal result, not a
  /// Failure: only transport and parsing problems throw.
  Future<ForecastReport> getForecast(AnalyticsRange range, {int limit, int horizonDays});

  /// Trend sentence per product, same rules as [getForecast].
  Future<InsightReport> getInsights(AnalyticsRange range, {int limit});
}
