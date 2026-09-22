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
      throw const ValidationFailure('product_id must be a positive integer', issue: FailureIssue.localValidation);
    }
    return _repository.getMovements(
      productId,
      page: page < 1 ? 1 : page,
      pageSize: pageSize.clamp(1, ApiConstants.maxPageSize),
    );
  }
}
