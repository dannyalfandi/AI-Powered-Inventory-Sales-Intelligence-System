import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/inventory.dart';
import 'inventory_providers.dart';
import 'low_stock_list_provider.dart';
import 'stock_movement_list_provider.dart';

part 'inventory_provider.g.dart';

/// Current stock of one product (GET /api/v1/inventory/:product_id).
@riverpod
class ProductInventory extends _$ProductInventory {
  @override
  Future<Inventory> build(int productId) => ref.watch(getInventoryUseCaseProvider)(productId);

  /// Records a movement, then shows the stock returned by the backend (same
  /// transaction as the movement) and reloads the history and low-stock list.
  /// Throws `Failure` — e.g. `ValidationFailure` with a `quantity` message
  /// when an OUT exceeds the stock — so the form can show it.
  Future<MovementResult> recordMovement(MovementInput input) async {
    // Stay alive until the follow-up invalidations ran, even if no widget
    // watches this provider while the request is in flight.
    final link = ref.keepAlive();
    try {
      final result = await ref.read(recordStockMovementUseCaseProvider)(productId, input);
      ref.invalidate(stockMovementListProvider(productId));
      ref.invalidate(lowStockListProvider);
      state = AsyncData(result.inventory);
      return result;
    } finally {
      link.close();
    }
  }
}
