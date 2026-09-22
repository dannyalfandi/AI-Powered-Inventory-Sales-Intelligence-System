import '../../../../core/error/failure.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoryById {
  const GetCategoryById(this._repository);

  final CategoryRepository _repository;

  Future<Category> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('id must be a positive integer', issue: FailureIssue.localValidation);
    }
    return _repository.getCategoryById(id);
  }
}
