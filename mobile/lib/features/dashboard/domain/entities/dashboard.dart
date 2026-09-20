import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard.freezed.dart';

/// Inclusive date range the backend echoes back on every analytics response
/// (backend/internal/model/analytics.go — dates only, no time component).
@freezed
abstract class AnalyticsRange with _$AnalyticsRange {
  const AnalyticsRange._();

  const factory AnalyticsRange({required DateTime from, required DateTime to}) = _AnalyticsRange;

  /// Default window of the dashboard and of the backend: the last 30 days
  /// including [today].
  factory AnalyticsRange.last30Days(DateTime today) => AnalyticsRange.lastDays(today, 30);

  /// The last [days] days including [today], e.g. days = 7 → today - 6 .. today.
  factory AnalyticsRange.lastDays(DateTime today, int days) {
    final to = DateTime(today.year, today.month, today.day);
    return AnalyticsRange(
      to: to,
      from: to.subtract(Duration(days: days - 1)),
    );
  }

  /// Number of days covered, both ends inclusive.
  int get dayCount => to.difference(from).inDays + 1;
}

/// Bucket size of the sales trend chart.
enum TrendGranularity { daily, weekly }

/// GET /api/v1/analytics/summary.
@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required AnalyticsRange range,
    required int totalRevenue,
    required int totalOrders,
    required int totalItemsSold,

    /// Revenue / orders, already rounded by the backend.
    required int averageOrderValue,
  }) = _DashboardSummary;
}

/// One bucket of GET /api/v1/analytics/sales-trend. Periods without sales are
/// present with zeros (the backend gap-fills via generate_series).
@freezed
abstract class SalesTrendPoint with _$SalesTrendPoint {
  const factory SalesTrendPoint({
    required DateTime periodStart,
    required DateTime periodEnd,
    required int revenue,
    required int orders,
  }) = _SalesTrendPoint;
}

@freezed
abstract class SalesTrend with _$SalesTrend {
  const SalesTrend._();

  const factory SalesTrend({
    required AnalyticsRange range,
    required TrendGranularity granularity,
    required List<SalesTrendPoint> points,
  }) = _SalesTrend;

  /// Highest revenue in the window; 0 when every bucket is empty.
  int get maxRevenue => points.fold(0, (m, p) => p.revenue > m ? p.revenue : m);

  bool get hasSales => maxRevenue > 0;
}

/// One row of GET /api/v1/analytics/top-products.
@freezed
abstract class TopProduct with _$TopProduct {
  const factory TopProduct({
    required int productId,
    required String sku,
    required String name,
    required int quantitySold,
    required int revenue,
  }) = _TopProduct;
}

/// One row of GET /api/v1/analytics/category-breakdown. [categoryId] is null
/// for products without a category; the backend names that bucket
/// "Tanpa Kategori".
@freezed
abstract class CategoryBreakdown with _$CategoryBreakdown {
  const CategoryBreakdown._();

  const factory CategoryBreakdown({
    int? categoryId,
    required String categoryName,
    required int quantitySold,
    required int revenue,
  }) = _CategoryBreakdown;

  bool get isUncategorized => categoryId == null;
}
