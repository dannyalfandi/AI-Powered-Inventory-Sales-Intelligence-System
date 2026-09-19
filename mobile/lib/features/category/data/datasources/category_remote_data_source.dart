import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/page_meta_model.dart';
import '../models/category_model.dart';

/// Talks to the Go backend `/api/v1/categories` endpoints. Throws
/// [DioException] or parsing errors; the repository converts both into `Failure`.
abstract interface class CategoryRemoteDataSource {
  Future<(List<CategoryModel>, PageMetaModel)> fetchCategories({
    required int page,
    required int pageSize,
    String search = '',
  });

  Future<CategoryModel> fetchCategory(int id);

  Future<CategoryModel> createCategory(CreateCategoryRequest body);

  Future<CategoryModel> updateCategory(int id, UpdateCategoryRequest body);

  Future<void> deleteCategory(int id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  const CategoryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _path = ApiConstants.categoriesPath;

  @override
  Future<(List<CategoryModel>, PageMetaModel)> fetchCategories({
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
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = PageMetaModel.fromJson(body['meta'] as Map<String, dynamic>);
    return (items, meta);
  }

  @override
  Future<CategoryModel> fetchCategory(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('$_path/$id');
    return _unwrap(res);
  }

  @override
  Future<CategoryModel> createCategory(CreateCategoryRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(_path, data: body.toJson());
    return _unwrap(res);
  }

  @override
  Future<CategoryModel> updateCategory(int id, UpdateCategoryRequest body) async {
    final res = await _dio.patch<Map<String, dynamic>>('$_path/$id', data: body.toJson());
    return _unwrap(res);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _dio.delete<void>('$_path/$id'); // 204 No Content, 409 while in use
  }

  /// Unwraps the `{"data": {...}}` envelope.
  CategoryModel _unwrap(Response<Map<String, dynamic>> res) =>
      CategoryModel.fromJson(res.data!['data'] as Map<String, dynamic>);
}
