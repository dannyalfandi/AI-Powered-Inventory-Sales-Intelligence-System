import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/inventory.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

/// Backend movement type strings (backend model.MovementType).
abstract final class MovementTypeCodec {
  static const _codes = {
    MovementType.stockIn: 'IN',
    MovementType.stockOut: 'OUT',
    MovementType.adjustment: 'ADJUSTMENT',
  };

  static String encode(MovementType type) => _codes[type]!;

  /// Throws [FormatException] for an unknown value (contract drift), which
  /// the repository turns into a `ServerFailure`.
  static MovementType decode(String value) => _codes.entries
      .firstWhere(
        (e) => e.value == value,
        orElse: () => throw FormatException('unknown movement type "$value"'),
      )
      .key;
}

/// `GET /api/v1/inventory/:product_id` and the `inventory` part of a movement
/// response: `{"product_id","quantity","low_stock_threshold","is_low_stock",
/// "created_at","updated_at"}`. Timestamps are ignored: they are zero-time
/// when the product has no inventory row yet.
@freezed
abstract class InventoryModel with _$InventoryModel {
  const InventoryModel._();

  const factory InventoryModel({
    required int productId,
    required int quantity,
    required int lowStockThreshold,
    required bool isLowStock,
  }) = _InventoryModel;

  factory InventoryModel.fromJson(Map<String, dynamic> json) => _$InventoryModelFromJson(json);

  Inventory toEntity() => Inventory(
        productId: productId,
        quantity: quantity,
        lowStockThreshold: lowStockThreshold,
        isLowStock: isLowStock,
      );
}

/// `{"id","product_id","type","quantity","quantity_before","quantity_after","reason","created_at"}`.
@freezed
abstract class StockMovementModel with _$StockMovementModel {
  const StockMovementModel._();

  const factory StockMovementModel({
    required int id,
    required int productId,
    required String type,
    required int quantity,
    required int quantityBefore,
    required int quantityAfter,
    @Default('') String reason,
    required DateTime createdAt,
  }) = _StockMovementModel;

  factory StockMovementModel.fromJson(Map<String, dynamic> json) => _$StockMovementModelFromJson(json);

  StockMovement toEntity() => StockMovement(
        id: id,
        productId: productId,
        type: MovementTypeCodec.decode(type),
        quantity: quantity,
        quantityBefore: quantityBefore,
        quantityAfter: quantityAfter,
        reason: reason,
        createdAt: createdAt,
      );
}

/// `data` of `POST /api/v1/inventory/:product_id/movements`:
/// `{"movement": {...}, "inventory": {...}}`.
@freezed
abstract class MovementResultModel with _$MovementResultModel {
  const MovementResultModel._();

  const factory MovementResultModel({
    required StockMovementModel movement,
    required InventoryModel inventory,
  }) = _MovementResultModel;

  factory MovementResultModel.fromJson(Map<String, dynamic> json) => _$MovementResultModelFromJson(json);

  MovementResult toEntity() =>
      MovementResult(movement: movement.toEntity(), inventory: inventory.toEntity());
}

/// `GET /api/v1/inventory/low-stock` item:
/// `{"product_id","sku","name","quantity","low_stock_threshold"}`.
@freezed
abstract class LowStockItemModel with _$LowStockItemModel {
  const LowStockItemModel._();

  const factory LowStockItemModel({
    required int productId,
    required String sku,
    required String name,
    required int quantity,
    required int lowStockThreshold,
  }) = _LowStockItemModel;

  factory LowStockItemModel.fromJson(Map<String, dynamic> json) => _$LowStockItemModelFromJson(json);

  LowStockItem toEntity() => LowStockItem(
        productId: productId,
        sku: sku,
        name: name,
        quantity: quantity,
        lowStockThreshold: lowStockThreshold,
      );
}

/// Request body for POST /api/v1/inventory/:product_id/movements
/// (backend model.CreateStockMovementInput).
@freezed
abstract class CreateMovementRequest with _$CreateMovementRequest {
  const factory CreateMovementRequest({
    required String type,
    required int quantity,
    required String reason,
  }) = _CreateMovementRequest;

  factory CreateMovementRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMovementRequestFromJson(json);

  /// [input] must be validated (quantity non-null) by the usecase first.
  factory CreateMovementRequest.fromEntity(MovementInput input) => CreateMovementRequest(
        type: MovementTypeCodec.encode(input.type),
        quantity: input.quantity!,
        reason: input.reason,
      );
}
