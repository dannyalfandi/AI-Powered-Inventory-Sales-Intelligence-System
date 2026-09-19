import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/page_meta_model.dart';
import '../models/product_model.dart';

/// Talks to the Go backend `/api/v1/products` endpoints. Throws [DioException]
/// (with a `Failure` attached by ApiErrorInterceptor) or parsing errors;
/// the repository converts both into `Failure`.
abstract interface class ProductRemoteDataSource {
  Future<(List<ProductModel>, PageMetaModel)> fetchProducts({
    required int page,
    required int pageSize,
    String search = '',
  });

  Future<ProductModel> fetchProduct(int id);

  Future<ProductModel> createProduct(CreateProductRequest body);

  Future<ProductModel> updateProduct(int id, UpdateProductRequest body);

  Future<void> deleteProduct(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _path = ApiConstants.productsPath;

  @override
  Future<(List<ProductModel>, PageMetaModel)> fetchProducts({
    required int page,
    required int pageSize,
    String search = '',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      _path,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (search.isNotEmpty) 'search': search,
      },
    );
    final body = res.data!;
    final items = (body['data'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = PageMetaModel.fromJson(body['meta'] as Map<String, dynamic>);
    return (items, meta);
  }

  @override
  Future<ProductModel> fetchProduct(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('$_path/$id');
    return _unwrap(res);
  }

  @override
  Future<ProductModel> createProduct(CreateProductRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(_path, data: body.toJson());
    return _unwrap(res);
  }

  @override
  Future<ProductModel> updateProduct(int id, UpdateProductRequest body) async {
    final res = await _dio.patch<Map<String, dynamic>>('$_path/$id', data: body.toJson());
    return _unwrap(res);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await _dio.delete<void>('$_path/$id'); // 204 No Content
  }

  /// Unwraps the `{"data": {...}}` envelope.
  ProductModel _unwrap(Response<Map<String, dynamic>> res) =>
      ProductModel.fromJson(res.data!['data'] as Map<String, dynamic>);
}
