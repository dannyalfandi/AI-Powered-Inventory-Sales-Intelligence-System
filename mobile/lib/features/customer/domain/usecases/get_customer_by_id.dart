import '../../../../core/error/failure.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomerById {
  const GetCustomerById(this._repository);

  final CustomerRepository _repository;

  Future<Customer> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('ID pelanggan tidak valid', messages: {'id': 'harus bilangan positif'});
    }
    return _repository.getCustomerById(id);
  }
}
