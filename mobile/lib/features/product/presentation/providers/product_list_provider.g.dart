// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current search text. [ProductList] watches it, so changing the query
/// rebuilds the list from page 1 and Riverpod discards stale in-flight results.

@ProviderFor(ProductSearchQuery)
final productSearchQueryProvider = ProductSearchQueryProvider._();

/// Current search text. [ProductList] watches it, so changing the query
/// rebuilds the list from page 1 and Riverpod discards stale in-flight results.
final class ProductSearchQueryProvider
    extends $NotifierProvider<ProductSearchQuery, String> {
  /// Current search text. [ProductList] watches it, so changing the query
  /// rebuilds the list from page 1 and Riverpod discards stale in-flight results.
  ProductSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productSearchQueryHash();

  @$internal
  @override
  ProductSearchQuery create() => ProductSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$productSearchQueryHash() =>
    r'67543378f0c583a99d011bbc2a4bdfc56ab2433f';

/// Current search text. [ProductList] watches it, so changing the query
/// rebuilds the list from page 1 and Riverpod discards stale in-flight results.

abstract class _$ProductSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ProductList)
final productListProvider = ProductListProvider._();

final class ProductListProvider
    extends $AsyncNotifierProvider<ProductList, ProductListState> {
  ProductListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productListHash();

  @$internal
  @override
  ProductList create() => ProductList();
}

String _$productListHash() => r'ca140b98c168c4b22c82be3f2fba7996494d1e8f';

abstract class _$ProductList extends $AsyncNotifier<ProductListState> {
  FutureOr<ProductListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProductListState>, ProductListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProductListState>, ProductListState>,
              AsyncValue<ProductListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
