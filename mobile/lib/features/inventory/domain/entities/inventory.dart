import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory.freezed.dart';

/// Current stock of one product (backend model.Inventory, 1-1 with product).
/// A product that never had a movement has quantity 0 and the backend's
/// default threshold.
@freezed
abstract class Inventory with _$Inventory {
  const factory Inventory({
    required int productId,
    required int quantity,
    required int lowStockThreshold,

    /// `quantity <= lowStockThreshold`, computed by the backend.
    required bool isLowStock,
  }) = _Inventory;
}

enum MovementType {
  /// Adds `quantity` to the stock.
  stockIn,

  /// Subtracts `quantity`; rejected (422) if it exceeds the stock.
  stockOut,

  /// Sets the stock to `quantity` (e.g. after a stock count).
  adjustment,
}

/// Immutable stock history entry (backend model.StockMovement).
@freezed
abstract class StockMovement with _$StockMovement {
  const factory StockMovement({
    required int id,
    required int productId,
    required MovementType type,

    /// Amount moved (IN/OUT) or the new stock level (ADJUSTMENT).
    required int quantity,
    required int quantityBefore,
    required int quantityAfter,
    required String reason,
    required DateTime createdAt,
  }) = _StockMovement;
}

/// Result of recording a movement: the logged movement and the updated stock.
@freezed
abstract class MovementResult with _$MovementResult {
  const factory MovementResult({
    required StockMovement movement,
    required Inventory inventory,
  }) = _MovementResult;
}

/// Data needed to record a movement (POST /api/v1/inventory/:product_id/movements).
@freezed
abstract class MovementInput with _$MovementInput {
  const MovementInput._();

  const factory MovementInput({
    required MovementType type,
    required int? quantity,
    @Default('') String reason,
  }) = _MovementInput;

  MovementInput trimmed() => copyWith(reason: reason.trim());
}

/// One row of the low-stock report (backend model.LowStockItem).
@freezed
abstract class LowStockItem with _$LowStockItem {
  const factory LowStockItem({
    required int productId,
    required String sku,
    required String name,
    required int quantity,
    required int lowStockThreshold,
  }) = _LowStockItem;
}

/// Movement rules, mirroring backend `newMovement` in
/// backend/internal/service/inventory_service.go. Whether an OUT exceeds the
/// current stock is only checked by the backend (422 on `quantity`), because
/// the stock shown on screen may be stale.
abstract final class MovementRules {
  static const maxQuantity = 1000000000;
  static const reasonMaxLength = 500;

  static String? validateQuantity(MovementType type, int? value) {
    if (value == null) return 'Jumlah wajib diisi';
    if (value < 0) return 'Jumlah tidak boleh negatif';
    if (value == 0 && type != MovementType.adjustment) return 'Jumlah harus lebih dari 0';
    if (value > maxQuantity) return 'Jumlah maksimal $maxQuantity';
    return null;
  }

  static String? validateReason(String value) {
    if (value.trim().length > reasonMaxLength) {
      return 'Keterangan maksimal $reasonMaxLength karakter';
    }
    return null;
  }
}
