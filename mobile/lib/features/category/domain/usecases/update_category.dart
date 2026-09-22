import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategory {
  const UpdateCategory(this._repository);

  final CategoryRepository _repository;

  /// Validates only the fields present in [patch]; null fields are untouched.
  Future<Category> call(int id, CategoryPatch patch) async {
    final data = patch.trimmed();
    final issues = <String, FieldIssue>{
      if (id <= 0) 'id': const FieldIssue(FieldIssueKind.quantityInvalid),
      if (data.name case final name?) 'name': ?CategoryRules.validateName(name),
    };
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.updateCategory(id, data);
  }
}
