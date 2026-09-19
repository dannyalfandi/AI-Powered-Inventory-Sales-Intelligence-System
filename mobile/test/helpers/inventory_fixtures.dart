import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:inventory_intel/features/inventory/domain/entities/inventory.dart';
import 'package:inventory_intel/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

Inventory inventory(int productId, {int quantity = 20, int threshold = 10}) => Inventory(
      productId: productId,
      quantity: quantity,
      lowStockThreshold: threshold,
      isLowStock: quantity <= threshold,
    );

StockMovement movement(
  int id, {
  int productId = 1,
  MovementType type = MovementType.stockIn,
  int quantity = 5,
  int before = 0,
  int? after,
  String reason = '',
}) =>
    StockMovement(
      id: id,
      productId: productId,
      type: type,
      quantity: quantity,
      quantityBefore: before,
      quantityAfter: after ?? before + quantity,
      reason: reason,
      createdAt: DateTime.utc(2026, 9, 1, 10, id),
    );

LowStockItem lowStockItem(int productId, {int quantity = 2, int threshold = 10, String? name}) => LowStockItem(
      productId: productId,
      sku: 'SKU-$productId',
      name: name ?? 'Produk $productId',
      quantity: quantity,
      lowStockThreshold: threshold,
    );

PageResult<T> pageOf<T>(List<T> items, {int page = 1, int pageSize = 20, int? total}) =>
    PageResult(items: items, page: page, pageSize: pageSize, total: total ?? items.length);

/// The 422 the backend returns for an OUT larger than the stock
/// (message format from backend applyMovement).
const insufficientStockFailure = ValidationFailure(
  'request validation failed',
  messages: {'quantity': 'insufficient stock: 20 available, 21 requested'},
);

/// Call once in `setUpAll` so `any()` works for these argument types.
void registerInventoryFallbacks() {
  registerFallbackValue(const MovementInput(type: MovementType.stockIn, quantity: 1));
}
