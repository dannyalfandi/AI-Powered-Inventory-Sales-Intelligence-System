import '../../../../core/error/guard.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._remote);

  final CustomerRemoteDataSource _remote;

  @override
  Future<PageResult<Customer>> getCustomers({
    required int page,
    required int pageSize,
    String search = '',
  }) =>
      guardApiCall(() async {
        final (items, meta) = await _remote.fetchCustomers(page: page, pageSize: pageSize, search: search);
        return PageResult(
          items: items.map((m) => m.toEntity()).toList(),
          page: meta.page,
          pageSize: meta.pageSize,
          total: meta.total,
        );
      });

  @override
  Future<Customer> getCustomerById(int id) =>
      guardApiCall(() async => (await _remote.fetchCustomer(id)).toEntity());

  @override
  Future<Customer> createCustomer(CustomerInput input) => guardApiCall(
        () async => (await _remote.createCustomer(CreateCustomerRequest.fromEntity(input))).toEntity(),
      );

  @override
  Future<Customer> updateCustomer(int id, CustomerPatch patch) => guardApiCall(
        () async => (await _remote.updateCustomer(id, UpdateCustomerRequest.fromEntity(patch))).toEntity(),
      );

  @override
  Future<void> deleteCustomer(int id) => guardApiCall(() => _remote.deleteCustomer(id));
}
