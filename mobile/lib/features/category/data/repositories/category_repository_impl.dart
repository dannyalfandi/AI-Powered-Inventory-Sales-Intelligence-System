import '../../../../core/error/guard.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remote);

  final CategoryRemoteDataSource _remote;

  @override
  Future<PageResult<Category>> getCategories({
    required int page,
    required int pageSize,
    String search = '',
  }) =>
      guardApiCall(() async {
        final (items, meta) = await _remote.fetchCategories(
          page: page,
          pageSize: pageSize,
          search: search,
        );
        return PageResult(
          items: items.map((m) => m.toEntity()).toList(),
          page: meta.page,
          pageSize: meta.pageSize,
          total: meta.total,
        );
      });

  @override
  Future<Category> getCategoryById(int id) =>
      guardApiCall(() async => (await _remote.fetchCategory(id)).toEntity());

  @override
  Future<Category> createCategory(CategoryInput input) => guardApiCall(
        () async => (await _remote.createCategory(CreateCategoryRequest.fromEntity(input))).toEntity(),
      );

  @override
  Future<Category> updateCategory(int id, CategoryPatch patch) => guardApiCall(
        () async => (await _remote.updateCategory(id, UpdateCategoryRequest.fromEntity(patch))).toEntity(),
      );

  @override
  Future<void> deleteCategory(int id) => guardApiCall(() => _remote.deleteCategory(id));
}
