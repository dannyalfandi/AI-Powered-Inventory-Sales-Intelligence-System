import '../../../../core/error/failure.dart';
import '../entities/inventory.dart';
import '../repositories/inventory_repository.dart';

class GetInventory {
  const GetInventory(this._repository);

  final InventoryRepository _repository;

  Future<Inventory> call(int productId) async {
    if (productId <= 0) {
      throw const ValidationFailure('ID produk tidak valid', messages: {'product_id': 'harus bilangan positif'});
    }
    return _repository.getInventory(productId);
  }
}
