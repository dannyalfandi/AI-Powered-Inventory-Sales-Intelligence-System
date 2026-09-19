// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salesOrderRemoteDataSource)
final salesOrderRemoteDataSourceProvider =
    SalesOrderRemoteDataSourceProvider._();

final class SalesOrderRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SalesOrderRemoteDataSource,
          SalesOrderRemoteDataSource,
          SalesOrderRemoteDataSource
        >
    with $Provider<SalesOrderRemoteDataSource> {
  SalesOrderRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesOrderRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesOrderRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SalesOrderRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalesOrderRemoteDataSource create(Ref ref) {
    return salesOrderRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesOrderRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesOrderRemoteDataSource>(value),
    );
  }
}

String _$salesOrderRemoteDataSourceHash() =>
    r'10418420d18103efc303342c53569fe65f366b55';

@ProviderFor(salesOrderRepository)
final salesOrderRepositoryProvider = SalesOrderRepositoryProvider._();

final class SalesOrderRepositoryProvider
    extends
        $FunctionalProvider<
          SalesOrderRepository,
          SalesOrderRepository,
          SalesOrderRepository
        >
    with $Provider<SalesOrderRepository> {
  SalesOrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesOrderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesOrderRepositoryHash();

  @$internal
  @override
  $ProviderElement<SalesOrderRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalesOrderRepository create(Ref ref) {
    return salesOrderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesOrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesOrderRepository>(value),
    );
  }
}

String _$salesOrderRepositoryHash() =>
    r'427cedea2501a3a01d1a13f26966ec800090b39c';

@ProviderFor(getSalesOrdersUseCase)
final getSalesOrdersUseCaseProvider = GetSalesOrdersUseCaseProvider._();

final class GetSalesOrdersUseCaseProvider
    extends $FunctionalProvider<GetSalesOrders, GetSalesOrders, GetSalesOrders>
    with $Provider<GetSalesOrders> {
  GetSalesOrdersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSalesOrdersUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSalesOrdersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSalesOrders> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetSalesOrders create(Ref ref) {
    return getSalesOrdersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSalesOrders value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSalesOrders>(value),
    );
  }
}

String _$getSalesOrdersUseCaseHash() =>
    r'4696911a67b04c3e607dd30bbb76eca8d51bdd0c';

@ProviderFor(getSalesOrderByIdUseCase)
final getSalesOrderByIdUseCaseProvider = GetSalesOrderByIdUseCaseProvider._();

final class GetSalesOrderByIdUseCaseProvider
    extends
        $FunctionalProvider<
          GetSalesOrderById,
          GetSalesOrderById,
          GetSalesOrderById
        >
    with $Provider<GetSalesOrderById> {
  GetSalesOrderByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSalesOrderByIdUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSalesOrderByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSalesOrderById> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetSalesOrderById create(Ref ref) {
    return getSalesOrderByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSalesOrderById value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSalesOrderById>(value),
    );
  }
}

String _$getSalesOrderByIdUseCaseHash() =>
    r'ec86701bf85b3494c0d9178355e51c04bfa36018';

@ProviderFor(createSalesOrderUseCase)
final createSalesOrderUseCaseProvider = CreateSalesOrderUseCaseProvider._();

final class CreateSalesOrderUseCaseProvider
    extends
        $FunctionalProvider<
          CreateSalesOrder,
          CreateSalesOrder,
          CreateSalesOrder
        >
    with $Provider<CreateSalesOrder> {
  CreateSalesOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createSalesOrderUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createSalesOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateSalesOrder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateSalesOrder create(Ref ref) {
    return createSalesOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateSalesOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateSalesOrder>(value),
    );
  }
}

String _$createSalesOrderUseCaseHash() =>
    r'7306cf0b936b97dc796ba2e4dbd9514c9671bae7';

@ProviderFor(changeOrderStatusUseCase)
final changeOrderStatusUseCaseProvider = ChangeOrderStatusUseCaseProvider._();

final class ChangeOrderStatusUseCaseProvider
    extends
        $FunctionalProvider<
          ChangeOrderStatus,
          ChangeOrderStatus,
          ChangeOrderStatus
        >
    with $Provider<ChangeOrderStatus> {
  ChangeOrderStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeOrderStatusUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeOrderStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<ChangeOrderStatus> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChangeOrderStatus create(Ref ref) {
    return changeOrderStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangeOrderStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangeOrderStatus>(value),
    );
  }
}

String _$changeOrderStatusUseCaseHash() =>
    r'714742c99842f4049bfb654d6dbe03cc3787ab98';
