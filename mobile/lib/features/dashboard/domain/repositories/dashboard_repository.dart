import '../entities/dashboard.dart';

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
}
