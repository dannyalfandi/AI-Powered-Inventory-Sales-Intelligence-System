import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class UpdateCustomer {
  const UpdateCustomer(this._repository);

  final CustomerRepository _repository;

  /// Validates only the fields present in [patch].
  Future<Customer> call(int id, CustomerPatch patch) async {
    final data = patch.trimmed();
    final issues = <String, FieldIssue>{
      if (id <= 0) 'id': const FieldIssue(FieldIssueKind.quantityInvalid),
      if (data.name case final v?) 'name': ?CustomerRules.validateName(v),
      if (data.email case final v?) 'email': ?CustomerRules.validateEmail(v),
      if (data.phone case final v?) 'phone': ?CustomerRules.validatePhone(v),
      if (data.address case final v?) 'address': ?CustomerRules.validateAddress(v),
    };
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.updateCustomer(id, data);
  }
}
