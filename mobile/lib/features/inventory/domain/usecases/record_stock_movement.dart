import '../../../../core/error/failure.dart';
import '../entities/inventory.dart';
import '../repositories/inventory_repository.dart';

class RecordStockMovement {
  const RecordStockMovement(this._repository);

  final InventoryRepository _repository;

  /// Validates the request shape locally (keys match the backend's 422
  /// fields). Stock sufficiency for OUT is left to the backend.
  Future<MovementResult> call(int productId, MovementInput input) async {
    final data = input.trimmed();
    final messages = <String, String>{
      if (productId <= 0) 'product_id': 'harus bilangan positif',
      'quantity': ?MovementRules.validateQuantity(data.type, data.quantity),
      'reason': ?MovementRules.validateReason(data.reason),
    };
    if (messages.isNotEmpty) {
      throw ValidationFailure('Input pergerakan stok tidak valid', messages: messages);
    }
    return _repository.recordMovement(productId, data);
  }
}
