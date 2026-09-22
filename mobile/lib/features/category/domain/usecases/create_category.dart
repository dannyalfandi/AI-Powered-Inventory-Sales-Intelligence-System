import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategory {
  const CreateCategory(this._repository);

  final CategoryRepository _repository;

  /// Trims and validates locally; throws [ValidationFailure] without a network
  /// round trip when input is invalid.
  Future<Category> call(CategoryInput input) async {
    final data = input.trimmed();
    final issues = <String, FieldIssue>{
      'name': ?CategoryRules.validateName(data.name),
    };
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.createCategory(data);
  }
}
