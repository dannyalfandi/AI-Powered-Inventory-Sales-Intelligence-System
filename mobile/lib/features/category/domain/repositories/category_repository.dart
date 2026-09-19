import '../../../../core/pagination/paged.dart';
import '../entities/category.dart';

/// Category data access contract. Implementations throw only `Failure`
/// subclasses (see core/error/failure.dart), never raw transport exceptions.
abstract interface class CategoryRepository {
  Future<PageResult<Category>> getCategories({
    required int page,
    required int pageSize,
    String search = '',
  });

  Future<Category> getCategoryById(int id);

  Future<Category> createCategory(CategoryInput input);

  Future<Category> updateCategory(int id, CategoryPatch patch);

  /// Throws `ServerFailure` with status 409 while products still use the category.
  Future<void> deleteCategory(int id);
}
