import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
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
/// naming the order item it is about. Backend 422 keys look like
/// `items[1].quantity` ("insufficient stock for product 7 (TEH-1): 3
/// available, 10 requested") or `items[0].product_id` (product deleted).
List<String> statusChangeErrorLines(Failure failure, SalesOrder order) {
  if (failure is! ValidationFailure || failure.messages.isEmpty) return [failure.message];

  final itemKey = RegExp(r'^items\[(\d+)\]\.(quantity|product_id)$');
  final stock = RegExp(r'(\d+) available, (\d+) requested');
  return [
    for (final MapEntry(key: field, value: message) in failure.messages.entries)
      switch (itemKey.firstMatch(field)) {
        final m? when int.parse(m.group(1)!) < order.items.length => () {
            final item = order.items[int.parse(m.group(1)!)];
            final label = '${item.productName} (${item.productSku})';
            if (m.group(2) == 'product_id') return '$label: produk sudah dihapus, tidak bisa dikonfirmasi.';
            final s = stock.firstMatch(message);
            return s == null
                ? '$label: $message'
                : '$label: stok tersedia ${s.group(1)}, dibutuhkan ${s.group(2)}.';
          }(),
        _ when field == 'status' => 'Status pesanan sudah berubah ($message). Data pesanan dimuat ulang.',
        _ => message,
      },
  ];
}
