import '../../../../core/error/failure.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class CreateCustomer {
  const CreateCustomer(this._repository);

  final CustomerRepository _repository;

  /// Trims and validates locally; throws [ValidationFailure] without a
  /// network round trip when input is invalid.
  Future<Customer> call(CustomerInput input) async {
    final data = input.trimmed();
    final messages = <String, String>{
      'name': ?CustomerRules.validateName(data.name),
      'email': ?CustomerRules.validateEmail(data.email),
      'phone': ?CustomerRules.validatePhone(data.phone),
      'address': ?CustomerRules.validateAddress(data.address),
    };
    if (messages.isNotEmpty) {
      throw ValidationFailure('Input pelanggan tidak valid', messages: messages);
    }
    return _repository.createCustomer(data);
  }
}
