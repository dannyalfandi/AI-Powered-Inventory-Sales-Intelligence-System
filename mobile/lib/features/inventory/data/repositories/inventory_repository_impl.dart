import '../../../../core/error/guard.dart';
import '../../../../core/network/page_meta_model.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/inventory.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_data_source.dart';
import '../models/inventory_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  const InventoryRepositoryImpl(this._remote);

  final InventoryRemoteDataSource _remote;

  @override
  Future<Inventory> getInventory(int productId) =>
      guardApiCall(() async => (await _remote.fetchInventory(productId)).toEntity());

  @override
  Future<MovementResult> recordMovement(int productId, MovementInput input) => guardApiCall(
        () async =>
            (await _remote.createMovement(productId, CreateMovementRequest.fromEntity(input))).toEntity(),
      );

  @override
  Future<PageResult<StockMovement>> getMovements(
    int productId, {
    required int page,
    required int pageSize,
  }) =>
      guardApiCall(() async {
        final (items, meta) = await _remote.fetchMovements(productId, page: page, pageSize: pageSize);
        return _toPage(items.map((m) => m.toEntity()).toList(), meta);
      });

  @override
  Future<PageResult<LowStockItem>> getLowStock({required int page, required int pageSize}) =>
      guardApiCall(() async {
        final (items, meta) = await _remote.fetchLowStock(page: page, pageSize: pageSize);
        return _toPage(items.map((m) => m.toEntity()).toList(), meta);
      });

  static PageResult<T> _toPage<T>(List<T> items, PageMetaModel meta) =>
      PageResult(items: items, page: meta.page, pageSize: meta.pageSize, total: meta.total);
}
