import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_order.freezed.dart';

/// Sales order status. Mirrors backend `orderTransitions`
/// (backend/internal/service/sales_order_service.go):
///
///     PENDING ──► CONFIRMED ──► SHIPPED
///        │            │
///        └──► CANCELLED ◄──┘
///
/// Confirming deducts stock; cancelling a CONFIRMED order returns it.
enum OrderStatus {
  pending,
  confirmed,
  shipped,
  cancelled;

  /// Statuses this status may move to (empty = final).
  List<OrderStatus> get next => switch (this) {
        OrderStatus.pending => const [OrderStatus.confirmed, OrderStatus.cancelled],
        OrderStatus.confirmed => const [OrderStatus.shipped, OrderStatus.cancelled],
        OrderStatus.shipped || OrderStatus.cancelled => const [],
      };

  bool canMoveTo(OrderStatus to) => next.contains(to);

  bool get isFinal => next.isEmpty;
}

/// A customer order. Items and prices are fixed at creation (price
/// snapshot); only [status] changes.
@freezed
abstract class SalesOrder with _$SalesOrder {
  const factory SalesOrder({
    required int id,
    required String orderNumber,
    required int customerId,

    /// Always sent by the backend (also for customers deleted later).
    OrderCustomer? customer,
    required OrderStatus status,

    /// Whole Rupiah.
    required int totalAmount,
    required String notes,
    DateTime? confirmedAt,
    DateTime? shippedAt,
    DateTime? cancelledAt,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Empty in list responses; filled in the order detail.
    @Default([]) List<SalesOrderItem> items,
  }) = _SalesOrder;
}

/// The customer as embedded in an order.
@freezed
abstract class OrderCustomer with _$OrderCustomer {
  const factory OrderCustomer({
    required int id,
    required String name,
    String? email,
    required String phone,
    required String address,
  }) = _OrderCustomer;
}

/// One order line. SKU, name and unit price are snapshots from order creation.
@freezed
abstract class SalesOrderItem with _$SalesOrderItem {
  const factory SalesOrderItem({
    required int id,
    required int productId,
    required String productSku,
    required String productName,
    required int quantity,
    required int unitPrice,
    required int subtotal,
  }) = _SalesOrderItem;
}

/// Data needed to create an order (POST /api/v1/sales-orders).
@freezed
abstract class SalesOrderInput with _$SalesOrderInput {
  const factory SalesOrderInput({
    required int? customerId,
    required List<OrderLineInput> items,
    @Default('') String notes,
  }) = _SalesOrderInput;
}

@freezed
abstract class OrderLineInput with _$OrderLineInput {
  const factory OrderLineInput({
    required int productId,

    /// Null while the quantity field is empty.
    required int? quantity,
  }) = _OrderLineInput;
}

/// Order rules, mirroring backend `validateOrderInput`. Error keys use the
/// backend's field names (`customer_id`, `items`, `items[1].quantity`, ...)
/// so local and server errors land in the same place in the form.
abstract final class OrderRules {
  static const maxItems = 100;
  static const maxQuantity = 1000000;
  static const notesMaxLength = 2000;

  static Map<String, String> validate(SalesOrderInput input) {
    final messages = <String, String>{};
    if (input.customerId == null || input.customerId! <= 0) {
      messages['customer_id'] = 'Pilih pelanggan';
    }
    if (input.items.isEmpty) {
      messages['items'] = 'Tambahkan minimal satu produk';
    } else if (input.items.length > maxItems) {
      messages['items'] = 'Maksimal $maxItems produk per pesanan';
    }
    final seen = <int, int>{};
    for (final (i, line) in input.items.indexed) {
      if (seen[line.productId] case final first?) {
        messages['items[$i].product_id'] = 'Produk ini sudah ada di baris ${first + 1}; gabungkan jumlahnya';
      } else {
        seen[line.productId] = i;
      }
      if (validateQuantity(line.quantity) case final msg?) {
        messages['items[$i].quantity'] = msg;
      }
    }
    if (input.notes.trim().length > notesMaxLength) {
      messages['notes'] = 'Catatan maksimal $notesMaxLength karakter';
    }
    return messages;
  }

  static String? validateQuantity(int? quantity) {
    if (quantity == null) return 'Jumlah wajib diisi';
    if (quantity <= 0) return 'Jumlah harus lebih dari 0';
    if (quantity > maxQuantity) return 'Jumlah maksimal $maxQuantity';
    return null;
  }
}
