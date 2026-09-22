import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remote);

  final ProductRemoteDataSource _remote;

  @override
  Future<ProductPage> getProducts({
    required int page,
    required int pageSize,
    String search = '',
  }) =>
      _guard(() async {
        final (items, meta) = await _remote.fetchProducts(
          page: page,
          pageSize: pageSize,
          search: search,
        );
        return ProductPage(
          items: items.map((m) => m.toEntity()).toList(),
          page: meta.page,
          pageSize: meta.pageSize,
          total: meta.total,
        );
      });

  @override
  Future<Product> getProductById(int id) =>
      _guard(() async => (await _remote.fetchProduct(id)).toEntity());

  @override
  Future<Product> createProduct(ProductInput input) => _guard(
        () async => (await _remote.createProduct(CreateProductRequest.fromEntity(input))).toEntity(),
      );

  @override
  Future<Product> updateProduct(int id, ProductPatch patch) => _guard(
        () async => (await _remote.updateProduct(id, UpdateProductRequest.fromEntity(patch))).toEntity(),
      );

  @override
  Future<void> deleteProduct(int id) => _guard(() => _remote.deleteProduct(id));

  /// Converts every exception into a [Failure] so the UI never sees Dio or
  /// parsing errors.
  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on Failure {
      rethrow;
    } on DioException catch (e) {
      throw mapDioException(e);
    } on TypeError catch (_) {
      // Missing/mistyped JSON field — backend contract drift.
      throw const ServerFailure('malformed response', code: 'invalid_response', issue: FailureIssue.malformedResponse);
    } on FormatException catch (_) {
      throw const ServerFailure('malformed response', code: 'invalid_response', issue: FailureIssue.malformedResponse);
    }
  }
}
