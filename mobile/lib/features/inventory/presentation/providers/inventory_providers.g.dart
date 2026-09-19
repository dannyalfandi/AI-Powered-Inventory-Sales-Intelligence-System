// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventoryRemoteDataSource)
final inventoryRemoteDataSourceProvider = InventoryRemoteDataSourceProvider._();

final class InventoryRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          InventoryRemoteDataSource,
          InventoryRemoteDataSource,
          InventoryRemoteDataSource
        >
    with $Provider<InventoryRemoteDataSource> {
  InventoryRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<InventoryRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRemoteDataSource create(Ref ref) {
    return inventoryRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRemoteDataSource>(value),
    );
  }
}

String _$inventoryRemoteDataSourceHash() =>
    r'16d04285a6368aa35d1390541141edf9d2a1634d';

@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider = InventoryRepositoryProvider._();

final class InventoryRepositoryProvider
    extends
        $FunctionalProvider<
          InventoryRepository,
          InventoryRepository,
          InventoryRepository
        >
    with $Provider<InventoryRepository> {
  InventoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRepository create(Ref ref) {
    return inventoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRepository>(value),
    );
  }
}

String _$inventoryRepositoryHash() =>
    r'2807febfee1bfb6b0a76713618436188a398b057';

@ProviderFor(getInventoryUseCase)
final getInventoryUseCaseProvider = GetInventoryUseCaseProvider._();

final class GetInventoryUseCaseProvider
    extends $FunctionalProvider<GetInventory, GetInventory, GetInventory>
    with $Provider<GetInventory> {
  GetInventoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getInventoryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getInventoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetInventory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetInventory create(Ref ref) {
    return getInventoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetInventory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetInventory>(value),
    );
  }
}

String _$getInventoryUseCaseHash() =>
    r'f6ea4b4c7e7ababdb64c843a22cb44e215546c0c';

@ProviderFor(recordStockMovementUseCase)
final recordStockMovementUseCaseProvider =
    RecordStockMovementUseCaseProvider._();

final class RecordStockMovementUseCaseProvider
    extends
        $FunctionalProvider<
          RecordStockMovement,
          RecordStockMovement,
          RecordStockMovement
        >
    with $Provider<RecordStockMovement> {
  RecordStockMovementUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordStockMovementUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordStockMovementUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecordStockMovement> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordStockMovement create(Ref ref) {
    return recordStockMovementUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordStockMovement value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordStockMovement>(value),
    );
  }
}

String _$recordStockMovementUseCaseHash() =>
    r'6b2b7d51db92987d8a5869a062daabd5d7ebd27e';

@ProviderFor(getStockMovementsUseCase)
final getStockMovementsUseCaseProvider = GetStockMovementsUseCaseProvider._();

final class GetStockMovementsUseCaseProvider
    extends
        $FunctionalProvider<
          GetStockMovements,
          GetStockMovements,
          GetStockMovements
        >
    with $Provider<GetStockMovements> {
  GetStockMovementsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getStockMovementsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getStockMovementsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetStockMovements> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetStockMovements create(Ref ref) {
    return getStockMovementsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetStockMovements value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetStockMovements>(value),
    );
  }
}

String _$getStockMovementsUseCaseHash() =>
    r'7ae90c9ea810b09afad03722a0964604ff860ec8';

@ProviderFor(getLowStockItemsUseCase)
final getLowStockItemsUseCaseProvider = GetLowStockItemsUseCaseProvider._();

final class GetLowStockItemsUseCaseProvider
    extends
        $FunctionalProvider<
          GetLowStockItems,
          GetLowStockItems,
          GetLowStockItems
        >
    with $Provider<GetLowStockItems> {
  GetLowStockItemsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getLowStockItemsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getLowStockItemsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetLowStockItems> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetLowStockItems create(Ref ref) {
    return getLowStockItemsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetLowStockItems value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetLowStockItems>(value),
    );
  }
}

String _$getLowStockItemsUseCaseHash() =>
    r'80c1b19fb99aa070a77a22d0e5cd7fd6a88ed797';
