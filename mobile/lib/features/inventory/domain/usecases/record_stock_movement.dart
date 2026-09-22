import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/inventory.dart';
import '../repositories/inventory_repository.dart';

class RecordStockMovement {
  const RecordStockMovement(this._repository);

  final InventoryRepository _repository;

  /// Validates the request shape locally (keys match the backend's 422
  /// fields). Stock sufficiency for OUT is left to the backend.
  Future<MovementResult> call(int productId, MovementInput input) async {
    final data = input.trimmed();
    final issues = <String, FieldIssue>{
      if (productId <= 0) 'product_id': const FieldIssue(FieldIssueKind.quantityInvalid),
      'quantity': ?MovementRules.validateQuantity(data.type, data.quantity),
      'reason': ?MovementRules.validateReason(data.reason),
    };
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.recordMovement(productId, data);
  }
}
