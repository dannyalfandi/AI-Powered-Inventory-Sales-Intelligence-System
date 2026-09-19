import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:inventory_intel/features/customer/domain/entities/customer.dart';
import 'package:inventory_intel/features/customer/domain/repositories/customer_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

final _ts = DateTime.utc(2026, 9, 1);

Customer customer(int id, {String? name, String? email, String phone = '', String address = ''}) => Customer(
      id: id,
      name: name ?? 'Pelanggan $id',
      email: email,
      phone: phone,
      address: address,
      createdAt: _ts,
      updatedAt: _ts,
    );

PageResult<Customer> customerPage(List<Customer> items, {int page = 1, int pageSize = 20, int? total}) =>
    PageResult(items: items, page: page, pageSize: pageSize, total: total ?? items.length);

/// Stubs every `getCustomers` call with [items] (for lists and pickers).
void stubCustomers(MockCustomerRepository repo, List<Customer> items) {
  when(
    () => repo.getCustomers(
      page: any(named: 'page'),
      pageSize: any(named: 'pageSize'),
      search: any(named: 'search'),
    ),
  ).thenAnswer((_) async => customerPage(items));
}

/// The 409 the backend returns when deleting a customer with orders that
/// are not cancelled (message format from backend customerService.Delete).
const customerHasOrdersFailure = ServerFailure(
  'conflict: customer 9 still has 2 sales order(s) that are not cancelled',
  statusCode: 409,
  code: 'conflict',
);

void registerCustomerFallbacks() {
  registerFallbackValue(const CustomerInput(name: 'x'));
  registerFallbackValue(const CustomerPatch());
}
