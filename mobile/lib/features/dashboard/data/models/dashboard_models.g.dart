// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsRangeModel _$AnalyticsRangeModelFromJson(Map<String, dynamic> json) =>
    _AnalyticsRangeModel(
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
    );

Map<String, dynamic> _$AnalyticsRangeModelToJson(
  _AnalyticsRangeModel instance,
) => <String, dynamic>{
  'from': instance.from.toIso8601String(),
  'to': instance.to.toIso8601String(),
};

_DashboardSummaryModel _$DashboardSummaryModelFromJson(
  Map<String, dynamic> json,
) => _DashboardSummaryModel(
  range: AnalyticsRangeModel.fromJson(json['range'] as Map<String, dynamic>),
  totalRevenue: (json['total_revenue'] as num).toInt(),
  totalOrders: (json['total_orders'] as num).toInt(),
  totalItemsSold: (json['total_items_sold'] as num).toInt(),
  averageOrderValue: (json['average_order_value'] as num).toInt(),
);

Map<String, dynamic> _$DashboardSummaryModelToJson(
  _DashboardSummaryModel instance,
) => <String, dynamic>{
  'range': instance.range.toJson(),
  'total_revenue': instance.totalRevenue,
  'total_orders': instance.totalOrders,
  'total_items_sold': instance.totalItemsSold,
  'average_order_value': instance.averageOrderValue,
};

_SalesTrendPointModel _$SalesTrendPointModelFromJson(
  Map<String, dynamic> json,
) => _SalesTrendPointModel(
  periodStart: DateTime.parse(json['period_start'] as String),
  periodEnd: DateTime.parse(json['period_end'] as String),
  revenue: (json['revenue'] as num).toInt(),
  orders: (json['orders'] as num).toInt(),
);

Map<String, dynamic> _$SalesTrendPointModelToJson(
  _SalesTrendPointModel instance,
) => <String, dynamic>{
  'period_start': instance.periodStart.toIso8601String(),
  'period_end': instance.periodEnd.toIso8601String(),
  'revenue': instance.revenue,
  'orders': instance.orders,
};

_SalesTrendModel _$SalesTrendModelFromJson(
  Map<String, dynamic> json,
) => _SalesTrendModel(
  range: AnalyticsRangeModel.fromJson(json['range'] as Map<String, dynamic>),
  granularity: json['granularity'] as String,
  points:
      (json['points'] as List<dynamic>?)
          ?.map((e) => SalesTrendPointModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SalesTrendPointModel>[],
);

Map<String, dynamic> _$SalesTrendModelToJson(_SalesTrendModel instance) =>
    <String, dynamic>{
      'range': instance.range.toJson(),
      'granularity': instance.granularity,
      'points': instance.points.map((e) => e.toJson()).toList(),
    };

_TopProductModel _$TopProductModelFromJson(Map<String, dynamic> json) =>
    _TopProductModel(
      productId: (json['product_id'] as num).toInt(),
      sku: json['sku'] as String,
      name: json['name'] as String,
      quantitySold: (json['quantity_sold'] as num).toInt(),
      revenue: (json['revenue'] as num).toInt(),
    );

Map<String, dynamic> _$TopProductModelToJson(_TopProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'sku': instance.sku,
      'name': instance.name,
      'quantity_sold': instance.quantitySold,
      'revenue': instance.revenue,
    };

_TopProductsResponse _$TopProductsResponseFromJson(Map<String, dynamic> json) =>
    _TopProductsResponse(
      range: AnalyticsRangeModel.fromJson(
        json['range'] as Map<String, dynamic>,
      ),
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => TopProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TopProductModel>[],
    );

Map<String, dynamic> _$TopProductsResponseToJson(
  _TopProductsResponse instance,
) => <String, dynamic>{
  'range': instance.range.toJson(),
  'products': instance.products.map((e) => e.toJson()).toList(),
};

_CategoryBreakdownModel _$CategoryBreakdownModelFromJson(
  Map<String, dynamic> json,
) => _CategoryBreakdownModel(
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String,
  quantitySold: (json['quantity_sold'] as num).toInt(),
  revenue: (json['revenue'] as num).toInt(),
);

Map<String, dynamic> _$CategoryBreakdownModelToJson(
  _CategoryBreakdownModel instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'quantity_sold': instance.quantitySold,
  'revenue': instance.revenue,
};

_CategoryBreakdownResponse _$CategoryBreakdownResponseFromJson(
  Map<String, dynamic> json,
) => _CategoryBreakdownResponse(
  range: AnalyticsRangeModel.fromJson(json['range'] as Map<String, dynamic>),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map(
            (e) => CategoryBreakdownModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CategoryBreakdownModel>[],
);

Map<String, dynamic> _$CategoryBreakdownResponseToJson(
  _CategoryBreakdownResponse instance,
) => <String, dynamic>{
  'range': instance.range.toJson(),
  'categories': instance.categories.map((e) => e.toJson()).toList(),
};

_LowStockAlertCountResponse _$LowStockAlertCountResponseFromJson(
  Map<String, dynamic> json,
) => _LowStockAlertCountResponse(count: (json['count'] as num).toInt());

Map<String, dynamic> _$LowStockAlertCountResponseToJson(
  _LowStockAlertCountResponse instance,
) => <String, dynamic>{'count': instance.count};
