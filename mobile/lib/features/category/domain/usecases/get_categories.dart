import '../../../../core/constants/api_constants.dart';
import '../../../../core/pagination/paged.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final CategoryRepository _repository;

  Future<PageResult<Category>> call({
    int page = 1,
    int pageSize = ApiConstants.defaultPageSize,
    String search = '',
  }) {
    return _repository.getCategories(
      page: page < 1 ? 1 : page,
      pageSize: pageSize.clamp(1, ApiConstants.maxPageSize),
      search: search.trim(),
    );
  }

  /// Every category, for pickers: fetches pages of 100 until the end, capped
  /// at [maxPages] so a runaway backend can't loop forever.
  Future<List<Category>> all({int maxPages = 10}) async {
    final result = <Category>[];
    for (var page = 1; page <= maxPages; page++) {
      final r = await call(page: page, pageSize: ApiConstants.maxPageSize);
      result.addAll(r.items);
      if (!r.hasMore) break;
    }
    return result;
  }
}
