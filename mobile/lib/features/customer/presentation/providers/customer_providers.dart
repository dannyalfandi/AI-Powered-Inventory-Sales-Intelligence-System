import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/create_customer.dart';
import '../../domain/usecases/delete_customer.dart';
import '../../domain/usecases/get_customer_by_id.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/update_customer.dart';

part 'customer_providers.g.dart';

// Dependency graph for the customer feature. Tests override
// customerRepositoryProvider (or a usecase provider) with a mock.

@Riverpod(keepAlive: true)
CustomerRemoteDataSource customerRemoteDataSource(Ref ref) =>
    CustomerRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) =>
    CustomerRepositoryImpl(ref.watch(customerRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetCustomers getCustomersUseCase(Ref ref) => GetCustomers(ref.watch(customerRepositoryProvider));

@Riverpod(keepAlive: true)
GetCustomerById getCustomerByIdUseCase(Ref ref) => GetCustomerById(ref.watch(customerRepositoryProvider));

@Riverpod(keepAlive: true)
CreateCustomer createCustomerUseCase(Ref ref) => CreateCustomer(ref.watch(customerRepositoryProvider));

@Riverpod(keepAlive: true)
UpdateCustomer updateCustomerUseCase(Ref ref) => UpdateCustomer(ref.watch(customerRepositoryProvider));

@Riverpod(keepAlive: true)
DeleteCustomer deleteCustomerUseCase(Ref ref) => DeleteCustomer(ref.watch(customerRepositoryProvider));
