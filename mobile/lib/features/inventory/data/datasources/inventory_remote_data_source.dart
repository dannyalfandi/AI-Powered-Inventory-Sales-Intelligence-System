import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/page_meta_model.dart';
import '../models/inventory_model.dart';

/// Talks to the Go backend `/api/v1/inventory` endpoints. Throws
/// [DioException] or parsing errors; the repository converts both into `Failure`.
abstract interface class InventoryRemoteDataSource {
  Future<InventoryModel> fetchInventory(int productId);

  Future<MovementResultModel> createMovement(int productId, CreateMovementRequest body);

  Future<(List<StockMovementModel>, PageMetaModel)> fetchMovements(
    int productId, {
    required int page,
    required int pageSize,
  });

  Future<(List<LowStockItemModel>, PageMetaModel)> fetchLowStock({
    required int page,
    required int pageSize,
  });
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  const InventoryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _path = ApiConstants.inventoryPath;

  @override
  Future<InventoryModel> fetchInventory(int productId) async {
    final res = await _dio.get<Map<String, dynamic>>('$_path/$productId');
    return InventoryModel.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<MovementResultModel> createMovement(int productId, CreateMovementRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_path/$productId/movements',
      data: body.toJson(),
    );
    return MovementResultModel.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<(List<StockMovementModel>, PageMetaModel)> fetchMovements(
    int productId, {
    required int page,
    required int pageSize,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_path/$productId/movements',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return _page(res, StockMovementModel.fromJson);
  }

  @override
  Future<(List<LowStockItemModel>, PageMetaModel)> fetchLowStock({
    required int page,
    required int pageSize,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_path/low-stock',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return _page(res, LowStockItemModel.fromJson);
  }

  /// Unwraps the paginated `{"data": [...], "meta": {...}}` envelope.
  (List<T>, PageMetaModel) _page<T>(
    Response<Map<String, dynamic>> res,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final body = res.data!;
    final items = (body['data'] as List<dynamic>).map((e) => fromJson(e as Map<String, dynamic>)).toList();
    return (items, PageMetaModel.fromJson(body['meta'] as Map<String, dynamic>));
  }
}
