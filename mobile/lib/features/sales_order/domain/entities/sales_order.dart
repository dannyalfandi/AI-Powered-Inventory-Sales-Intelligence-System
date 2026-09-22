import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/validation/field_issue.dart';

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

  static Map<String, FieldIssue> validate(SalesOrderInput input) {
    final issues = <String, FieldIssue>{};
    if (input.customerId == null || input.customerId! <= 0) {
      issues['customer_id'] = const FieldIssue(FieldIssueKind.customerRequired);
    }
    if (input.items.isEmpty) {
      issues['items'] = const FieldIssue(FieldIssueKind.itemsRequired);
    } else if (input.items.length > maxItems) {
      issues['items'] = const FieldIssue(FieldIssueKind.itemsTooMany, max: maxItems);
    }
    final seen = <int, int>{};
    for (final (i, line) in input.items.indexed) {
      if (seen[line.productId] case final first?) {
        // The form disables products already added, so a duplicate here means
        // the same product twice: report it on the line that repeats it, and
        // point back at the line that already has it.
        issues['items[$i].product_id'] =
            FieldIssue(FieldIssueKind.itemsDuplicateProduct, line: first + 1);
      } else {
        seen[line.productId] = i;
      }
      if (validateQuantity(line.quantity) case final issue?) {
        issues['items[$i].quantity'] = issue;
      }
    }
    if (input.notes.trim().length > notesMaxLength) {
      issues['notes'] = const FieldIssue(FieldIssueKind.descriptionTooLong, max: notesMaxLength);
    }
    return issues;
  }

  static FieldIssue? validateQuantity(int? quantity) {
    if (quantity == null) return const FieldIssue(FieldIssueKind.quantityRequired);
    if (quantity <= 0) return const FieldIssue(FieldIssueKind.quantityPositive);
    if (quantity > maxQuantity) return const FieldIssue(FieldIssueKind.quantityTooLarge, max: maxQuantity);
    return null;
  }
}
