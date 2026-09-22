import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/product.dart';
import '../entities/product_input.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  const UpdateProduct(this._repository);

  final ProductRepository _repository;

  /// Validates only the fields present in [patch]; null fields are untouched.
  Future<Product> call(int id, ProductPatch patch) async {
    final data = patch.trimmed();
    final issues = <String, FieldIssue>{
      if (id <= 0) 'id': const FieldIssue(FieldIssueKind.quantityInvalid),
      if (data.sku case final sku?) 'sku': ?ProductRules.validateSku(sku),
      if (data.name case final name?) 'name': ?ProductRules.validateName(name),
      if (data.price case final price?) 'price': ?ProductRules.validatePrice(price),
      // 0 (ProductPatch.noCategory) is valid here: it removes the category.
      if (data.categoryId case final c? when c < 0) 'category_id': const FieldIssue(FieldIssueKind.categoryInvalid),
    };
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.updateProduct(id, data);
  }
}
