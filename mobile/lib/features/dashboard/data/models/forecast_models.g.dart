// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForecastPointModel _$ForecastPointModelFromJson(Map<String, dynamic> json) =>
    _ForecastPointModel(
      date: DateTime.parse(json['date'] as String),
      predictedQuantity: (json['predicted_quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$ForecastPointModelToJson(_ForecastPointModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'predicted_quantity': instance.predictedQuantity,
    };

_ProductForecastModel _$ProductForecastModelFromJson(
  Map<String, dynamic> json,
) => _ProductForecastModel(
  productId: (json['product_id'] as num).toInt(),
  productName: json['product_name'] as String,
  sku: json['sku'] as String,
  forecast:
      (json['forecast'] as List<dynamic>?)
          ?.map((e) => ForecastPointModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ForecastPointModel>[],
  method: json['method'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$ProductForecastModelToJson(
  _ProductForecastModel instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'product_name': instance.productName,
  'sku': instance.sku,
  'forecast': instance.forecast.map((e) => e.toJson()).toList(),
  'method': instance.method,
  'error': instance.error,
};

_ForecastReportModel _$ForecastReportModelFromJson(
  Map<String, dynamic> json,
) => _ForecastReportModel(
  range: AnalyticsRangeModel.fromJson(json['range'] as Map<String, dynamic>),
  horizonDays: (json['horizon_days'] as num).toInt(),
  available: json['forecast_available'] as bool,
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductForecastModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductForecastModel>[],
);

Map<String, dynamic> _$ForecastReportModelToJson(
  _ForecastReportModel instance,
) => <String, dynamic>{
  'range': instance.range.toJson(),
  'horizon_days': instance.horizonDays,
  'forecast_available': instance.available,
  'products': instance.products.map((e) => e.toJson()).toList(),
};

_ProductInsightModel _$ProductInsightModelFromJson(Map<String, dynamic> json) =>
    _ProductInsightModel(
      productId: (json['product_id'] as num).toInt(),
      productName: json['product_name'] as String,
      sku: json['sku'] as String,
      trend: json['trend'] as String?,
      changePercent: (json['change_percent'] as num?)?.toDouble(),
      summary: json['summary'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ProductInsightModelToJson(
  _ProductInsightModel instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'product_name': instance.productName,
  'sku': instance.sku,
  'trend': instance.trend,
  'change_percent': instance.changePercent,
  'summary': instance.summary,
  'error': instance.error,
};

_InsightReportModel _$InsightReportModelFromJson(
  Map<String, dynamic> json,
) => _InsightReportModel(
  range: AnalyticsRangeModel.fromJson(json['range'] as Map<String, dynamic>),
  available: json['insights_available'] as bool,
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductInsightModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductInsightModel>[],
);

Map<String, dynamic> _$InsightReportModelToJson(_InsightReportModel instance) =>
    <String, dynamic>{
      'range': instance.range.toJson(),
      'insights_available': instance.available,
      'products': instance.products.map((e) => e.toJson()).toList(),
    };
