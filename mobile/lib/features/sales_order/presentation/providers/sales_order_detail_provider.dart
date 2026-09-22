import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../inventory/presentation/providers/inventory_provider.dart';
import '../../../inventory/presentation/providers/low_stock_list_provider.dart';
import '../../../inventory/presentation/providers/stock_movement_list_provider.dart';
import '../../domain/entities/sales_order.dart';
import 'sales_order_list_provider.dart';
import 'sales_order_providers.dart';

part 'sales_order_detail_provider.g.dart';

/// One order with customer and items (GET /api/v1/sales-orders/:id).
@riverpod
class SalesOrderDetail extends _$SalesOrderDetail {
  @override
  Future<SalesOrder> build(int orderId) => ref.watch(getSalesOrderByIdUseCaseProvider)(orderId);

  /// Moves the order to [target] and shows the order the backend returns.
  /// Refreshes the order list and, when stock moved (confirm, or cancel of a
  /// confirmed order), the stock screens. Throws `Failure`:
  /// `ValidationFailure` with `items[i].quantity` keys for short stock, or a
  /// `status` key if the transition is no longer allowed — then the order
  /// is reloaded, because it was probably changed elsewhere.
  Future<SalesOrder> changeStatus(OrderStatus target) async {
    final current = state.requireValue;
    final link = ref.keepAlive(); // survive until the follow-up invalidations
    try {
      final updated = await ref.read(changeOrderStatusUseCaseProvider)(current, target);
      state = AsyncData(updated);
      ref.invalidate(salesOrderListProvider);
      final stockMoved = target == OrderStatus.confirmed ||
          (target == OrderStatus.cancelled && current.status == OrderStatus.confirmed);
      if (stockMoved) {
        ref
          ..invalidate(productInventoryProvider)
          ..invalidate(stockMovementListProvider)
          ..invalidate(lowStockListProvider);
      }
      return updated;
    } on ValidationFailure catch (f) {
      if (f.messages.containsKey('status')) {
        ref
          ..invalidateSelf()
          ..invalidate(salesOrderListProvider);
      }
      rethrow;
    } finally {
      link.close();
    }
  }
}

/// Turns a failed status change into one user-facing line per problem,
/// naming the order item it is about.
///
/// Only the 422 *field names* are parsed (`items[1].quantity`,
/// `items[0].product_id`) — those are part of the API contract and are never
/// translated. The sentence next to them already comes back in the language
/// this app asked for, so it is prefixed with the product and shown as it is;
/// the old regex over its English wording ("3 available, 10 requested")
/// silently produced nothing once the server answered in Indonesian.
List<String> statusChangeErrorLines(BuildContext context, Failure failure, SalesOrder order) {
  final l10n = context.l10n;
  if (failure is! ValidationFailure) return [errorMessage(context, failure)];
  // A transition the app rejected before sending anything carries a typed
  // issue instead of a backend sentence.
  if (failure.issues.isNotEmpty) {
    return [for (final issue in failure.issues.values) ?context.messageFor(issue)];
  }
  if (failure.messages.isEmpty) return [errorMessage(context, failure)];

  final itemKey = RegExp(r'^items\[(\d+)\]\.(quantity|product_id)$');
  return [
    for (final MapEntry(key: field, value: message) in failure.messages.entries)
      switch (itemKey.firstMatch(field)) {
        final m? when int.parse(m.group(1)!) < order.items.length => () {
            final item = order.items[int.parse(m.group(1)!)];
            final label = '${item.productName} (${item.productSku})';
            return m.group(2) == 'product_id'
                ? l10n.orderItemDeleted(label)
                : l10n.orderItemProblem(label, message);
          }(),
        _ when field == 'status' => l10n.orderStatusChangedElsewhere(message),
        _ => message,
      },
  ];
}
