import '../../../../core/pagination/paged.dart';
import '../entities/inventory.dart';

/// Inventory data access contract. Implementations throw only `Failure`
/// subclasses (see core/error/failure.dart), never raw transport exceptions.
abstract interface class InventoryRepository {
  Future<Inventory> getInventory(int productId);

  /// Throws `ValidationFailure` (422) with a `quantity` message such as
  /// "insufficient stock: 20 available, 21 requested" when an OUT exceeds
  /// the stock.
  Future<MovementResult> recordMovement(int productId, MovementInput input);

  /// Newest first.
  Future<PageResult<StockMovement>> getMovements(
    int productId, {
    required int page,
    required int pageSize,
  });

  Future<PageResult<LowStockItem>> getLowStock({required int page, required int pageSize});
}
