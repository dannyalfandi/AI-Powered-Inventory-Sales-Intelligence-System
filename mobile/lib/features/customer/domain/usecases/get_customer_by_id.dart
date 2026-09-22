import '../../../../core/error/failure.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomerById {
  const GetCustomerById(this._repository);

  final CustomerRepository _repository;

  Future<Customer> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('id must be a positive integer', issue: FailureIssue.localValidation);
    }
    return _repository.getCustomerById(id);
  }
}
