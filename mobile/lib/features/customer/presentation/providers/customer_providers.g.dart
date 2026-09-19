// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerRemoteDataSource)
final customerRemoteDataSourceProvider = CustomerRemoteDataSourceProvider._();

final class CustomerRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CustomerRemoteDataSource,
          CustomerRemoteDataSource,
          CustomerRemoteDataSource
        >
    with $Provider<CustomerRemoteDataSource> {
  CustomerRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CustomerRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRemoteDataSource create(Ref ref) {
    return customerRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRemoteDataSource>(value),
    );
  }
}

String _$customerRemoteDataSourceHash() =>
    r'fce8909cfd262a531bd67beb085e37e4e3c11b47';

@ProviderFor(customerRepository)
final customerRepositoryProvider = CustomerRepositoryProvider._();

final class CustomerRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerRepository,
          CustomerRepository,
          CustomerRepository
        >
    with $Provider<CustomerRepository> {
  CustomerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'ae294f007e64a9f6fb89a3f827577aed534fdc73';

@ProviderFor(getCustomersUseCase)
final getCustomersUseCaseProvider = GetCustomersUseCaseProvider._();

final class GetCustomersUseCaseProvider
    extends $FunctionalProvider<GetCustomers, GetCustomers, GetCustomers>
    with $Provider<GetCustomers> {
  GetCustomersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCustomersUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCustomersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCustomers> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCustomers create(Ref ref) {
    return getCustomersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCustomers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCustomers>(value),
    );
  }
}

String _$getCustomersUseCaseHash() =>
    r'049bdcb8537ccf9cffdce4b241fe29970d6bc04c';

@ProviderFor(getCustomerByIdUseCase)
final getCustomerByIdUseCaseProvider = GetCustomerByIdUseCaseProvider._();

final class GetCustomerByIdUseCaseProvider
    extends
        $FunctionalProvider<GetCustomerById, GetCustomerById, GetCustomerById>
    with $Provider<GetCustomerById> {
  GetCustomerByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCustomerByIdUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCustomerByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCustomerById> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCustomerById create(Ref ref) {
    return getCustomerByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCustomerById value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCustomerById>(value),
    );
  }
}

String _$getCustomerByIdUseCaseHash() =>
    r'be2ae5c511fe90f111b959bf3a61e602e4a3411b';

@ProviderFor(createCustomerUseCase)
final createCustomerUseCaseProvider = CreateCustomerUseCaseProvider._();

final class CreateCustomerUseCaseProvider
    extends $FunctionalProvider<CreateCustomer, CreateCustomer, CreateCustomer>
    with $Provider<CreateCustomer> {
  CreateCustomerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCustomerUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCustomerUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateCustomer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateCustomer create(Ref ref) {
    return createCustomerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCustomer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCustomer>(value),
    );
  }
}

String _$createCustomerUseCaseHash() =>
    r'd0dd24f88c405cf5adcca718d36df630bd5054de';

@ProviderFor(updateCustomerUseCase)
final updateCustomerUseCaseProvider = UpdateCustomerUseCaseProvider._();

final class UpdateCustomerUseCaseProvider
    extends $FunctionalProvider<UpdateCustomer, UpdateCustomer, UpdateCustomer>
    with $Provider<UpdateCustomer> {
  UpdateCustomerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCustomerUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCustomerUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateCustomer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateCustomer create(Ref ref) {
    return updateCustomerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateCustomer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateCustomer>(value),
    );
  }
}

String _$updateCustomerUseCaseHash() =>
    r'49f50129fa6491cad564f64ebbd969d410ba9c44';

@ProviderFor(deleteCustomerUseCase)
final deleteCustomerUseCaseProvider = DeleteCustomerUseCaseProvider._();

final class DeleteCustomerUseCaseProvider
    extends $FunctionalProvider<DeleteCustomer, DeleteCustomer, DeleteCustomer>
    with $Provider<DeleteCustomer> {
  DeleteCustomerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteCustomerUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteCustomerUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteCustomer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteCustomer create(Ref ref) {
    return deleteCustomerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteCustomer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteCustomer>(value),
    );
  }
}

String _$deleteCustomerUseCaseHash() =>
    r'7d7f900f237ee13f781d3c97cb2b1f7992eac4c2';
