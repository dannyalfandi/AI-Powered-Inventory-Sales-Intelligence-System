import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/product.dart';
import '../entities/product_input.dart';
import '../repositories/product_repository.dart';

class CreateProduct {
  const CreateProduct(this._repository);

  final ProductRepository _repository;

  /// Trims and validates locally before calling the API; throws
  /// [ValidationFailure] without a network round trip when input is invalid.
  Future<Product> call(ProductInput input) async {
    final data = input.trimmed();
    final issues = <String, FieldIssue>{
      'sku': ?ProductRules.validateSku(data.sku),
      'name': ?ProductRules.validateName(data.name),
      'price': ?ProductRules.validatePrice(data.price),
      'category_id': ?ProductRules.validateCategoryId(data.categoryId),
    };
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.createProduct(data);
  }
}
