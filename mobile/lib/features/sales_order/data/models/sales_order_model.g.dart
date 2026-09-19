// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesOrderModel _$SalesOrderModelFromJson(
  Map<String, dynamic> json,
) => _SalesOrderModel(
  id: (json['id'] as num).toInt(),
  orderNumber: json['order_number'] as String,
  customerId: (json['customer_id'] as num).toInt(),
  status: json['status'] as String,
  totalAmount: (json['total_amount'] as num).toInt(),
  notes: json['notes'] as String? ?? '',
  confirmedAt: json['confirmed_at'] == null
      ? null
      : DateTime.parse(json['confirmed_at'] as String),
  shippedAt: json['shipped_at'] == null
      ? null
      : DateTime.parse(json['shipped_at'] as String),
  cancelledAt: json['cancelled_at'] == null
      ? null
      : DateTime.parse(json['cancelled_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  customer: json['customer'] == null
      ? null
      : OrderCustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => SalesOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SalesOrderModelToJson(_SalesOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'customer_id': instance.customerId,
      'status': instance.status,
      'total_amount': instance.totalAmount,
      'notes': instance.notes,
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'shipped_at': instance.shippedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'customer': instance.customer?.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_OrderCustomerModel _$OrderCustomerModelFromJson(Map<String, dynamic> json) =>
    _OrderCustomerModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );

Map<String, dynamic> _$OrderCustomerModelToJson(_OrderCustomerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
    };

_SalesOrderItemModel _$SalesOrderItemModelFromJson(Map<String, dynamic> json) =>
    _SalesOrderItemModel(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      productSku: json['product_sku'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
    );

Map<String, dynamic> _$SalesOrderItemModelToJson(
  _SalesOrderItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'product_sku': instance.productSku,
  'product_name': instance.productName,
  'quantity': instance.quantity,
  'unit_price': instance.unitPrice,
  'subtotal': instance.subtotal,
};

_CreateSalesOrderRequest _$CreateSalesOrderRequestFromJson(
  Map<String, dynamic> json,
) => _CreateSalesOrderRequest(
  customerId: (json['customer_id'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => CreateOrderItemRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  notes: json['notes'] as String,
);

Map<String, dynamic> _$CreateSalesOrderRequestToJson(
  _CreateSalesOrderRequest instance,
) => <String, dynamic>{
  'customer_id': instance.customerId,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'notes': instance.notes,
};

_CreateOrderItemRequest _$CreateOrderItemRequestFromJson(
  Map<String, dynamic> json,
) => _CreateOrderItemRequest(
  productId: (json['product_id'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CreateOrderItemRequestToJson(
  _CreateOrderItemRequest instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'quantity': instance.quantity,
};

_UpdateOrderStatusRequest _$UpdateOrderStatusRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateOrderStatusRequest(status: json['status'] as String);

Map<String, dynamic> _$UpdateOrderStatusRequestToJson(
  _UpdateOrderStatusRequest instance,
) => <String, dynamic>{'status': instance.status};
