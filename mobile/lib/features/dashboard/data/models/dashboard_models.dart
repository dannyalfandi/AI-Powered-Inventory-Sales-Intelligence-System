import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/dashboard.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

/// `"daily"` / `"weekly"` on the wire (backend model.Granularity).
abstract final class TrendGranularityCodec {
  static String encode(TrendGranularity g) => switch (g) {
    TrendGranularity.daily => 'daily',
    TrendGranularity.weekly => 'weekly',
  };

  /// Throws [FormatException] on an unknown value so `guardApiCall` turns
  /// contract drift into a ServerFailure instead of a silent wrong chart.
  static TrendGranularity decode(String value) => switch (value) {
    'daily' => TrendGranularity.daily,
    'weekly' => TrendGranularity.weekly,
    _ => throw FormatException('unknown granularity: $value'),
  };
}

/// `{"from":"2026-09-18","to":"2026-09-20"}` — dates only, no time zone.
@freezed
abstract class AnalyticsRangeModel with _$AnalyticsRangeModel {
  const AnalyticsRangeModel._();

  const factory AnalyticsRangeModel({required DateTime from, required DateTime to}) = _AnalyticsRangeModel;

  factory AnalyticsRangeModel.fromJson(Map<String, dynamic> json) => _$AnalyticsRangeModelFromJson(json);

  AnalyticsRange toEntity() => AnalyticsRange(from: from, to: to);
}

/// GET /api/v1/analytics/summary → `{"range",...,"total_revenue",
/// "total_orders","total_items_sold","average_order_value"}`.
@freezed
abstract class DashboardSummaryModel with _$DashboardSummaryModel {
  const DashboardSummaryModel._();

  const factory DashboardSummaryModel({
    required AnalyticsRangeModel range,
    required int totalRevenue,
    required int totalOrders,
    required int totalItemsSold,
    required int averageOrderValue,
  }) = _DashboardSummaryModel;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);

  DashboardSummary toEntity() => DashboardSummary(
    range: range.toEntity(),
    totalRevenue: totalRevenue,
    totalOrders: totalOrders,
    totalItemsSold: totalItemsSold,
    averageOrderValue: averageOrderValue,
  );
}

@freezed
abstract class SalesTrendPointModel with _$SalesTrendPointModel {
  const SalesTrendPointModel._();

  const factory SalesTrendPointModel({
    required DateTime periodStart,
    required DateTime periodEnd,
    required int revenue,
    required int orders,
  }) = _SalesTrendPointModel;

  factory SalesTrendPointModel.fromJson(Map<String, dynamic> json) => _$SalesTrendPointModelFromJson(json);

  SalesTrendPoint toEntity() =>
      SalesTrendPoint(periodStart: periodStart, periodEnd: periodEnd, revenue: revenue, orders: orders);
}

/// GET /api/v1/analytics/sales-trend → `{"range","granularity","points":[...]}`.
@freezed
abstract class SalesTrendModel with _$SalesTrendModel {
  const SalesTrendModel._();

  const factory SalesTrendModel({
    required AnalyticsRangeModel range,
    required String granularity,
    @Default(<SalesTrendPointModel>[]) List<SalesTrendPointModel> points,
  }) = _SalesTrendModel;

  factory SalesTrendModel.fromJson(Map<String, dynamic> json) => _$SalesTrendModelFromJson(json);

  SalesTrend toEntity() => SalesTrend(
    range: range.toEntity(),
    granularity: TrendGranularityCodec.decode(granularity),
    points: points.map((p) => p.toEntity()).toList(),
  );
}

@freezed
abstract class TopProductModel with _$TopProductModel {
  const TopProductModel._();

  const factory TopProductModel({
    required int productId,
    required String sku,
    required String name,
    required int quantitySold,
    required int revenue,
  }) = _TopProductModel;

  factory TopProductModel.fromJson(Map<String, dynamic> json) => _$TopProductModelFromJson(json);

  TopProduct toEntity() =>
      TopProduct(productId: productId, sku: sku, name: name, quantitySold: quantitySold, revenue: revenue);
}

/// GET /api/v1/analytics/top-products → `{"products":[...]|null,"range":{...}}`.
/// An empty window sends `"products": null` (Go marshals a nil slice), so the
/// default keeps it an empty list.
@freezed
abstract class TopProductsResponse with _$TopProductsResponse {
  const TopProductsResponse._();

  const factory TopProductsResponse({
    required AnalyticsRangeModel range,
    @Default(<TopProductModel>[]) List<TopProductModel> products,
  }) = _TopProductsResponse;

  factory TopProductsResponse.fromJson(Map<String, dynamic> json) => _$TopProductsResponseFromJson(json);

  List<TopProduct> toEntities() => products.map((p) => p.toEntity()).toList();
}

@freezed
abstract class CategoryBreakdownModel with _$CategoryBreakdownModel {
  const CategoryBreakdownModel._();

  const factory CategoryBreakdownModel({
    int? categoryId,
    required String categoryName,
    required int quantitySold,
    required int revenue,
  }) = _CategoryBreakdownModel;

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownModelFromJson(json);

  CategoryBreakdown toEntity() => CategoryBreakdown(
    categoryId: categoryId,
    categoryName: categoryName,
    quantitySold: quantitySold,
    revenue: revenue,
  );
}

/// GET /api/v1/analytics/category-breakdown → `{"categories":[...]|null,"range"}`.
@freezed
abstract class CategoryBreakdownResponse with _$CategoryBreakdownResponse {
  const CategoryBreakdownResponse._();

  const factory CategoryBreakdownResponse({
    required AnalyticsRangeModel range,
    @Default(<CategoryBreakdownModel>[]) List<CategoryBreakdownModel> categories,
  }) = _CategoryBreakdownResponse;

  factory CategoryBreakdownResponse.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownResponseFromJson(json);

  List<CategoryBreakdown> toEntities() => categories.map((c) => c.toEntity()).toList();
}

/// GET /api/v1/analytics/low-stock-alert-count → `{"count": 11}`.
@freezed
abstract class LowStockAlertCountResponse with _$LowStockAlertCountResponse {
  const factory LowStockAlertCountResponse({required int count}) = _LowStockAlertCountResponse;

  factory LowStockAlertCountResponse.fromJson(Map<String, dynamic> json) => _$LowStockAlertCountResponseFromJson(json);
}
