import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:inventory_intel/features/category/domain/entities/category.dart';
import 'package:inventory_intel/features/category/domain/repositories/category_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

final _ts = DateTime.utc(2026, 9, 1);

Category category(int id, {String? name, String description = ''}) => Category(
      id: id,
      name: name ?? 'Kategori $id',
      description: description,
      createdAt: _ts,
      updatedAt: _ts,
    );

PageResult<Category> categoryPage(List<Category> items, {int page = 1, int pageSize = 20, int? total}) =>
    PageResult(items: items, page: page, pageSize: pageSize, total: total ?? items.length);

/// Stubs every `getCategories` call (any page/search) with [items] — for
/// screens that only need the category picker filled.
void stubCategoryOptions(MockCategoryRepository repo, List<Category> items) {
  when(
    () => repo.getCategories(
      page: any(named: 'page'),
      pageSize: any(named: 'pageSize'),
      search: any(named: 'search'),
    ),
  ).thenAnswer((_) async => categoryPage(items, pageSize: 100));
}

/// The 409 the backend returns when deleting a category that is still used
/// (message format from backend categoryService.Delete).
const categoryInUseFailure = ServerFailure(
  'conflict: category 9 is still used by 3 product(s)',
  statusCode: 409,
  code: 'conflict',
);

/// Call once in `setUpAll` so `any()` works for these argument types.
void registerCategoryFallbacks() {
  registerFallbackValue(const CategoryInput(name: 'x'));
  registerFallbackValue(const CategoryPatch());
}
