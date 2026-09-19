// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current stock of one product (GET /api/v1/inventory/:product_id).

@ProviderFor(ProductInventory)
final productInventoryProvider = ProductInventoryFamily._();

/// Current stock of one product (GET /api/v1/inventory/:product_id).
final class ProductInventoryProvider
    extends $AsyncNotifierProvider<ProductInventory, Inventory> {
  /// Current stock of one product (GET /api/v1/inventory/:product_id).
  ProductInventoryProvider._({
    required ProductInventoryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productInventoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productInventoryHash();

  @override
  String toString() {
    return r'productInventoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductInventory create() => ProductInventory();

  @override
  bool operator ==(Object other) {
    return other is ProductInventoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productInventoryHash() => r'03aeca526cb83a83ae1eb69291c92450fe49afaf';

/// Current stock of one product (GET /api/v1/inventory/:product_id).

final class ProductInventoryFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductInventory,
          AsyncValue<Inventory>,
          Inventory,
          FutureOr<Inventory>,
          int
        > {
  ProductInventoryFamily._()
    : super(
        retry: null,
        name: r'productInventoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Current stock of one product (GET /api/v1/inventory/:product_id).

  ProductInventoryProvider call(int productId) =>
      ProductInventoryProvider._(argument: productId, from: this);

  @override
  String toString() => r'productInventoryProvider';
}

/// Current stock of one product (GET /api/v1/inventory/:product_id).

abstract class _$ProductInventory extends $AsyncNotifier<Inventory> {
  late final _$args = ref.$arg as int;
  int get productId => _$args;

  FutureOr<Inventory> build(int productId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Inventory>, Inventory>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Inventory>, Inventory>,
              AsyncValue<Inventory>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
