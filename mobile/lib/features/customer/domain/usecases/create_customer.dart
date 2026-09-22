import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class CreateCustomer {
  const CreateCustomer(this._repository);

  final CustomerRepository _repository;

  /// Trims and validates locally; throws [ValidationFailure] without a
  /// network round trip when input is invalid.
  Future<Customer> call(CustomerInput input) async {
    final data = input.trimmed();
    final issues = <String, FieldIssue>{
      'name': ?CustomerRules.validateName(data.name),
      'email': ?CustomerRules.validateEmail(data.email),
      'phone': ?CustomerRules.validatePhone(data.phone),
      'address': ?CustomerRules.validateAddress(data.address),
    };
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.createCustomer(data);
  }
}
