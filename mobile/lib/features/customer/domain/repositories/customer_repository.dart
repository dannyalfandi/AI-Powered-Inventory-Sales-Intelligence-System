import '../../../../core/pagination/paged.dart';
import '../entities/customer.dart';

/// Customer data access contract. Implementations throw only `Failure`
/// subclasses (see core/error/failure.dart), never raw transport exceptions.
abstract interface class CustomerRepository {
  /// [search] matches name, email or phone.
  Future<PageResult<Customer>> getCustomers({
    required int page,
    required int pageSize,
    String search = '',
  });

  Future<Customer> getCustomerById(int id);

  /// Throws `ServerFailure` 409 when the email is already used.
  Future<Customer> createCustomer(CustomerInput input);

  Future<Customer> updateCustomer(int id, CustomerPatch patch);

  /// Throws `ServerFailure` 409 while the customer has orders that are not cancelled.
  Future<void> deleteCustomer(int id);
}
