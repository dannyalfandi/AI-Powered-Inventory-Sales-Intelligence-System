import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/sales_order.dart';

part 'sales_order_model.freezed.dart';
part 'sales_order_model.g.dart';

/// Backend status strings (backend model.OrderStatus).
abstract final class OrderStatusCodec {
  static const _codes = {
    OrderStatus.pending: 'PENDING',
    OrderStatus.confirmed: 'CONFIRMED',
    OrderStatus.shipped: 'SHIPPED',
    OrderStatus.cancelled: 'CANCELLED',
  };

  static String encode(OrderStatus status) => _codes[status]!;

  /// Throws [FormatException] for an unknown value (contract drift), which
  /// the repository turns into a `ServerFailure`.
  static OrderStatus decode(String value) => _codes.entries
      .firstWhere(
        (e) => e.value == value,
        orElse: () => throw FormatException('unknown order status "$value"'),
      )
      .key;
}

/// JSON shape of an order (backend/internal/model/sales_order.go). The detail
/// and status responses include `customer` and `items`; list responses
/// include `customer` and omit `items`.
@freezed
abstract class SalesOrderModel with _$SalesOrderModel {
  const SalesOrderModel._();

  const factory SalesOrderModel({
    required int id,
    required String orderNumber,
    required int customerId,
    required String status,
    required int totalAmount,
    @Default('') String notes,
    DateTime? confirmedAt,
    DateTime? shippedAt,
    DateTime? cancelledAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    OrderCustomerModel? customer,
    @Default([]) List<SalesOrderItemModel> items,
  }) = _SalesOrderModel;

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) => _$SalesOrderModelFromJson(json);

  SalesOrder toEntity() => SalesOrder(
        id: id,
        orderNumber: orderNumber,
        customerId: customerId,
        customer: customer?.toEntity(),
        status: OrderStatusCodec.decode(status),
        totalAmount: totalAmount,
        notes: notes,
        confirmedAt: confirmedAt,
        shippedAt: shippedAt,
        cancelledAt: cancelledAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        items: items.map((i) => i.toEntity()).toList(),
      );
}

/// Embedded customer (backend model.Customer); timestamps are ignored.
@freezed
abstract class OrderCustomerModel with _$OrderCustomerModel {
  const OrderCustomerModel._();

  const factory OrderCustomerModel({
    required int id,
    required String name,
    String? email,
    @Default('') String phone,
    @Default('') String address,
  }) = _OrderCustomerModel;

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) => _$OrderCustomerModelFromJson(json);

  OrderCustomer toEntity() => OrderCustomer(id: id, name: name, email: email, phone: phone, address: address);
}

/// `{"id","sales_order_id","product_id","product_sku","product_name","quantity","unit_price","subtotal"}`.
@freezed
abstract class SalesOrderItemModel with _$SalesOrderItemModel {
  const SalesOrderItemModel._();

  const factory SalesOrderItemModel({
    required int id,
    required int productId,
    required String productSku,
    required String productName,
    required int quantity,
    required int unitPrice,
    required int subtotal,
  }) = _SalesOrderItemModel;

  factory SalesOrderItemModel.fromJson(Map<String, dynamic> json) => _$SalesOrderItemModelFromJson(json);

  SalesOrderItem toEntity() => SalesOrderItem(
        id: id,
        productId: productId,
        productSku: productSku,
        productName: productName,
        quantity: quantity,
        unitPrice: unitPrice,
        subtotal: subtotal,
      );
}

/// Request body for POST /api/v1/sales-orders (backend model.CreateSalesOrderInput).
@freezed
abstract class CreateSalesOrderRequest with _$CreateSalesOrderRequest {
  const factory CreateSalesOrderRequest({
    required int customerId,
    required List<CreateOrderItemRequest> items,
    required String notes,
  }) = _CreateSalesOrderRequest;

  factory CreateSalesOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSalesOrderRequestFromJson(json);

  /// [input] must be validated (customer and quantities non-null) first.
  factory CreateSalesOrderRequest.fromEntity(SalesOrderInput input) => CreateSalesOrderRequest(
        customerId: input.customerId!,
        items: [
          for (final line in input.items) CreateOrderItemRequest(productId: line.productId, quantity: line.quantity!),
        ],
        notes: input.notes,
      );
}

@freezed
abstract class CreateOrderItemRequest with _$CreateOrderItemRequest {
  const factory CreateOrderItemRequest({
    required int productId,
    required int quantity,
  }) = _CreateOrderItemRequest;

  factory CreateOrderItemRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderItemRequestFromJson(json);
}

/// Request body for PATCH /api/v1/sales-orders/:id/status.
@freezed
abstract class UpdateOrderStatusRequest with _$UpdateOrderStatusRequest {
  const factory UpdateOrderStatusRequest({required String status}) = _UpdateOrderStatusRequest;

  factory UpdateOrderStatusRequest.fromJson(Map<String, dynamic> json) => _$UpdateOrderStatusRequestFromJson(json);
}
