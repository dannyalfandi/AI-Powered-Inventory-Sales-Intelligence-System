import 'package:freezed_annotation/freezed_annotation.dart';

import 'dashboard.dart';

part 'forecast.freezed.dart';

/// Demand forecasting and trend insight, from the Go API endpoints backed by
/// the Python ML service (backend/internal/model/forecast.go).
///
/// That service is a separate process, so three outcomes are all normal and
/// all mean different things to the user:
///
///  * [ForecastReport.available] false — the ML service is down. Not an error
///    on our side and not "no data": the rest of the dashboard is still fine.
///  * a product carrying an [ProductForecast.error] while the report is
///    available — only that product failed; the others are trustworthy.
///  * an empty product list — nothing was sold in the range, so there is
///    nothing to predict.

/// One predicted day. The quantity is fractional: it is an average, not stock.
@freezed
abstract class ForecastPoint with _$ForecastPoint {
  const factory ForecastPoint({required DateTime date, required double predictedQuantity}) = _ForecastPoint;
}

@freezed
abstract class ProductForecast with _$ProductForecast {
  const ProductForecast._();

  const factory ProductForecast({
    required int productId,
    required String productName,
    required String sku,
    @Default(<ForecastPoint>[]) List<ForecastPoint> forecast,

    /// Which model produced it, e.g. "moving_average"; null when it failed.
    String? method,

    /// Why this product has no forecast. Null when it worked.
    String? error,
  }) = _ProductForecast;

  bool get hasError => error != null;

  /// Sum over the horizon — the "how many should I stock" number.
  double get totalPredicted => forecast.fold(0, (sum, point) => sum + point.predictedQuantity);

  /// Highest predicted day, used to scale the sparkline.
  double get peakPredicted => forecast.fold(0, (m, p) => p.predictedQuantity > m ? p.predictedQuantity : m);
}

@freezed
abstract class ForecastReport with _$ForecastReport {
  const ForecastReport._();

  const factory ForecastReport({
    required AnalyticsRange range,
    required int horizonDays,

    /// False when every product failed: the ML service is unreachable.
    required bool available,
    @Default(<ProductForecast>[]) List<ProductForecast> products,
  }) = _ForecastReport;

  int get failedCount => products.where((p) => p.hasError).length;

  /// True when some products worked and some did not.
  bool get isPartial => available && failedCount > 0;
}

/// Direction of the trend the ML service computed.
enum TrendDirection { increasing, decreasing, stable }

@freezed
abstract class ProductInsight with _$ProductInsight {
  const ProductInsight._();

  const factory ProductInsight({
    required int productId,
    required String productName,
    required String sku,
    TrendDirection? trend,

    /// Percentage change between the two compared periods; 0 is a real value,
    /// null means there is no result for this product.
    double? changePercent,

    /// Ready-to-display Indonesian sentence from the ML service.
    String? summary,
    String? error,
  }) = _ProductInsight;

  bool get hasError => error != null;
}

@freezed
abstract class InsightReport with _$InsightReport {
  const InsightReport._();

  const factory InsightReport({
    required AnalyticsRange range,
    required bool available,
    @Default(<ProductInsight>[]) List<ProductInsight> products,
  }) = _InsightReport;

  int get failedCount => products.where((p) => p.hasError).length;

  bool get isPartial => available && failedCount > 0;
}
