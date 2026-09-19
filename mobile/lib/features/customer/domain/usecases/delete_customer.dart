import '../../../../core/error/failure.dart';
import '../repositories/customer_repository.dart';

class DeleteCustomer {
  const DeleteCustomer(this._repository);

  final CustomerRepository _repository;

  /// Throws `ServerFailure` 409 while the customer has orders that are not cancelled.
  Future<void> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('ID pelanggan tidak valid', messages: {'id': 'harus bilangan positif'});
    }
    return _repository.deleteCustomer(id);
  }
}
