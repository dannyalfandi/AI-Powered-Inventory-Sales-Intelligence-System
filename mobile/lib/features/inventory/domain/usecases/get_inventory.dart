import '../../../../core/error/failure.dart';
import '../entities/inventory.dart';
import '../repositories/inventory_repository.dart';

class GetInventory {
  const GetInventory(this._repository);

  final InventoryRepository _repository;

  Future<Inventory> call(int productId) async {
    if (productId <= 0) {
      throw const ValidationFailure('product_id must be a positive integer', issue: FailureIssue.localValidation);
    }
    return _repository.getInventory(productId);
  }
}
