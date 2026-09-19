import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/pagination/paged.dart';
import '../entities/inventory.dart';
import '../repositories/inventory_repository.dart';

class GetStockMovements {
  const GetStockMovements(this._repository);

  final InventoryRepository _repository;

  /// Newest first.
  Future<PageResult<StockMovement>> call(
    int productId, {
    int page = 1,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    if (productId <= 0) {
      throw const ValidationFailure('ID produk tidak valid', messages: {'product_id': 'harus bilangan positif'});
    }
    return _repository.getMovements(
      productId,
      page: page < 1 ? 1 : page,
      pageSize: pageSize.clamp(1, ApiConstants.maxPageSize),
    );
  }
}
