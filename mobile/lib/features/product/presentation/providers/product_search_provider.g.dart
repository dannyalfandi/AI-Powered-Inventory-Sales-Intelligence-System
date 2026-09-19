// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// First page of products matching [query] (name or SKU), for pickers such
/// as the order form. Refine the query to find others.

@ProviderFor(productSearch)
final productSearchProvider = ProductSearchFamily._();

/// First page of products matching [query] (name or SKU), for pickers such
/// as the order form. Refine the query to find others.

final class ProductSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  /// First page of products matching [query] (name or SKU), for pickers such
  /// as the order form. Refine the query to find others.
  ProductSearchProvider._({
    required ProductSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productSearchHash();

  @override
  String toString() {
    return r'productSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productSearchHash() => r'b9ac32d54df5f8efb41890eca0688fa5fa46971f';

/// First page of products matching [query] (name or SKU), for pickers such
/// as the order form. Refine the query to find others.

final class ProductSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  ProductSearchFamily._()
    : super(
        retry: null,
        name: r'productSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// First page of products matching [query] (name or SKU), for pickers such
  /// as the order form. Refine the query to find others.

  ProductSearchProvider call(String query) =>
      ProductSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'productSearchProvider';
}
