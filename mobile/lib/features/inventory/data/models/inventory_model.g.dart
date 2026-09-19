// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) =>
    _InventoryModel(
      productId: (json['product_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      lowStockThreshold: (json['low_stock_threshold'] as num).toInt(),
      isLowStock: json['is_low_stock'] as bool,
    );

Map<String, dynamic> _$InventoryModelToJson(_InventoryModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'low_stock_threshold': instance.lowStockThreshold,
      'is_low_stock': instance.isLowStock,
    };

_StockMovementModel _$StockMovementModelFromJson(Map<String, dynamic> json) =>
    _StockMovementModel(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      quantityBefore: (json['quantity_before'] as num).toInt(),
      quantityAfter: (json['quantity_after'] as num).toInt(),
      reason: json['reason'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StockMovementModelToJson(_StockMovementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'type': instance.type,
      'quantity': instance.quantity,
      'quantity_before': instance.quantityBefore,
      'quantity_after': instance.quantityAfter,
      'reason': instance.reason,
      'created_at': instance.createdAt.toIso8601String(),
    };

_MovementResultModel _$MovementResultModelFromJson(Map<String, dynamic> json) =>
    _MovementResultModel(
      movement: StockMovementModel.fromJson(
        json['movement'] as Map<String, dynamic>,
      ),
      inventory: InventoryModel.fromJson(
        json['inventory'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MovementResultModelToJson(
  _MovementResultModel instance,
) => <String, dynamic>{
  'movement': instance.movement.toJson(),
  'inventory': instance.inventory.toJson(),
};

_LowStockItemModel _$LowStockItemModelFromJson(Map<String, dynamic> json) =>
    _LowStockItemModel(
      productId: (json['product_id'] as num).toInt(),
      sku: json['sku'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      lowStockThreshold: (json['low_stock_threshold'] as num).toInt(),
    );

Map<String, dynamic> _$LowStockItemModelToJson(_LowStockItemModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'sku': instance.sku,
      'name': instance.name,
      'quantity': instance.quantity,
      'low_stock_threshold': instance.lowStockThreshold,
    };

_CreateMovementRequest _$CreateMovementRequestFromJson(
  Map<String, dynamic> json,
) => _CreateMovementRequest(
  type: json['type'] as String,
  quantity: (json['quantity'] as num).toInt(),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$CreateMovementRequestToJson(
  _CreateMovementRequest instance,
) => <String, dynamic>{
  'type': instance.type,
  'quantity': instance.quantity,
  'reason': instance.reason,
};
