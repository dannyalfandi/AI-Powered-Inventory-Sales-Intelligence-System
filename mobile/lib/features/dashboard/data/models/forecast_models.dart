import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/forecast.dart';
import 'dashboard_models.dart';

part 'forecast_models.freezed.dart';
part 'forecast_models.g.dart';

/// `"increasing"` / `"decreasing"` / `"stable"` on the wire.
abstract final class TrendDirectionCodec {
  static String encode(TrendDirection direction) => switch (direction) {
    TrendDirection.increasing => 'increasing',
    TrendDirection.decreasing => 'decreasing',
    TrendDirection.stable => 'stable',
  };

  /// Throws [FormatException] on an unknown value, so contract drift becomes
  /// a ServerFailure instead of a silently missing badge.
  static TrendDirection decode(String value) => switch (value) {
    'increasing' => TrendDirection.increasing,
    'decreasing' => TrendDirection.decreasing,
    'stable' => TrendDirection.stable,
    _ => throw FormatException('unknown trend direction: $value'),
  };
}

@freezed
abstract class ForecastPointModel with _$ForecastPointModel {
  const ForecastPointModel._();

  const factory ForecastPointModel({required DateTime date, required double predictedQuantity}) = _ForecastPointModel;

  factory ForecastPointModel.fromJson(Map<String, dynamic> json) => _$ForecastPointModelFromJson(json);

  ForecastPoint toEntity() => ForecastPoint(date: date, predictedQuantity: predictedQuantity);
}

/// One product of GET /api/v1/analytics/forecast. `forecast`/`method` are
/// omitted when that product failed, `error` when it worked — never both.
@freezed
abstract class ProductForecastModel with _$ProductForecastModel {
  const ProductForecastModel._();

  const factory ProductForecastModel({
    required int productId,
    required String productName,
    required String sku,
    @Default(<ForecastPointModel>[]) List<ForecastPointModel> forecast,
    String? method,
    String? error,
  }) = _ProductForecastModel;

  factory ProductForecastModel.fromJson(Map<String, dynamic> json) => _$ProductForecastModelFromJson(json);

  ProductForecast toEntity() => ProductForecast(
    productId: productId,
    productName: productName,
    sku: sku,
    forecast: forecast.map((p) => p.toEntity()).toList(),
    method: method,
    error: error,
  );
}

/// GET /api/v1/analytics/forecast.
@freezed
abstract class ForecastReportModel with _$ForecastReportModel {
  const ForecastReportModel._();

  const factory ForecastReportModel({
    required AnalyticsRangeModel range,
    required int horizonDays,
    @JsonKey(name: 'forecast_available') required bool available,
    @Default(<ProductForecastModel>[]) List<ProductForecastModel> products,
  }) = _ForecastReportModel;

  factory ForecastReportModel.fromJson(Map<String, dynamic> json) => _$ForecastReportModelFromJson(json);

  ForecastReport toEntity() => ForecastReport(
    range: range.toEntity(),
    horizonDays: horizonDays,
    available: available,
    products: products.map((p) => p.toEntity()).toList(),
  );
}

/// One product of GET /api/v1/analytics/insights.
@freezed
abstract class ProductInsightModel with _$ProductInsightModel {
  const ProductInsightModel._();

  const factory ProductInsightModel({
    required int productId,
    required String productName,
    required String sku,
    String? trend,
    double? changePercent,
    String? summary,
    String? error,
  }) = _ProductInsightModel;

  factory ProductInsightModel.fromJson(Map<String, dynamic> json) => _$ProductInsightModelFromJson(json);

  ProductInsight toEntity() => ProductInsight(
    productId: productId,
    productName: productName,
    sku: sku,
    trend: trend == null ? null : TrendDirectionCodec.decode(trend!),
    changePercent: changePercent,
    summary: summary,
    error: error,
  );
}

/// GET /api/v1/analytics/insights.
@freezed
abstract class InsightReportModel with _$InsightReportModel {
  const InsightReportModel._();

  const factory InsightReportModel({
    required AnalyticsRangeModel range,
    @JsonKey(name: 'insights_available') required bool available,
    @Default(<ProductInsightModel>[]) List<ProductInsightModel> products,
  }) = _InsightReportModel;

  factory InsightReportModel.fromJson(Map<String, dynamic> json) => _$InsightReportModelFromJson(json);

  InsightReport toEntity() => InsightReport(
    range: range.toEntity(),
    available: available,
    products: products.map((p) => p.toEntity()).toList(),
  );
}
