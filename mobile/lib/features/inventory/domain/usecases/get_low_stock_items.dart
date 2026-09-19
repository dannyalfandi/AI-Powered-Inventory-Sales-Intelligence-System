import '../../../../core/constants/api_constants.dart';
import '../../../../core/pagination/paged.dart';
import '../entities/inventory.dart';
import '../repositories/inventory_repository.dart';

class GetLowStockItems {
  const GetLowStockItems(this._repository);

  final InventoryRepository _repository;

  /// Products with quantity <= threshold, lowest stock first.
  Future<PageResult<LowStockItem>> call({
    int page = 1,
    int pageSize = ApiConstants.defaultPageSize,
  }) {
    return _repository.getLowStock(
      page: page < 1 ? 1 : page,
      pageSize: pageSize.clamp(1, ApiConstants.maxPageSize),
    );
  }
}
