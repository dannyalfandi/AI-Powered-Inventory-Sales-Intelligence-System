// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Backs the create/edit form. `productId == null` → create mode (state is
/// `null`); otherwise loads the product via GET /api/v1/products/:id.

@ProviderFor(ProductForm)
final productFormProvider = ProductFormFamily._();

/// Backs the create/edit form. `productId == null` → create mode (state is
/// `null`); otherwise loads the product via GET /api/v1/products/:id.
final class ProductFormProvider
    extends $AsyncNotifierProvider<ProductForm, Product?> {
  /// Backs the create/edit form. `productId == null` → create mode (state is
  /// `null`); otherwise loads the product via GET /api/v1/products/:id.
  ProductFormProvider._({
    required ProductFormFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'productFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productFormHash();

  @override
  String toString() {
    return r'productFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductForm create() => ProductForm();

  @override
  bool operator ==(Object other) {
    return other is ProductFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productFormHash() => r'b2aef41cc55a7b9fc0c68c5d49686cf7199ecdc0';

/// Backs the create/edit form. `productId == null` → create mode (state is
/// `null`); otherwise loads the product via GET /api/v1/products/:id.

final class ProductFormFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductForm,
          AsyncValue<Product?>,
          Product?,
          FutureOr<Product?>,
          int?
        > {
  ProductFormFamily._()
    : super(
        retry: null,
        name: r'productFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Backs the create/edit form. `productId == null` → create mode (state is
  /// `null`); otherwise loads the product via GET /api/v1/products/:id.

  ProductFormProvider call(int? productId) =>
      ProductFormProvider._(argument: productId, from: this);

  @override
  String toString() => r'productFormProvider';
}

/// Backs the create/edit form. `productId == null` → create mode (state is
/// `null`); otherwise loads the product via GET /api/v1/products/:id.

abstract class _$ProductForm extends $AsyncNotifier<Product?> {
  late final _$args = ref.$arg as int?;
  int? get productId => _$args;

  FutureOr<Product?> build(int? productId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Product?>, Product?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Product?>, Product?>,
              AsyncValue<Product?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// A single product for the product detail (stock) screen. Invalidated by
/// [ProductForm.save] after an edit.

@ProviderFor(productDetail)
final productDetailProvider = ProductDetailFamily._();

/// A single product for the product detail (stock) screen. Invalidated by
/// [ProductForm.save] after an edit.

final class ProductDetailProvider
    extends $FunctionalProvider<AsyncValue<Product>, Product, FutureOr<Product>>
    with $FutureModifier<Product>, $FutureProvider<Product> {
  /// A single product for the product detail (stock) screen. Invalidated by
  /// [ProductForm.save] after an edit.
  ProductDetailProvider._({
    required ProductDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product> create(Ref ref) {
    final argument = this.argument as int;
    return productDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailHash() => r'6dffa1e060a8d1937023351d546fd08cf49e1908';

/// A single product for the product detail (stock) screen. Invalidated by
/// [ProductForm.save] after an edit.

final class ProductDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product>, int> {
  ProductDetailFamily._()
    : super(
        retry: null,
        name: r'productDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A single product for the product detail (stock) screen. Invalidated by
  /// [ProductForm.save] after an edit.

  ProductDetailProvider call(int productId) =>
      ProductDetailProvider._(argument: productId, from: this);

  @override
  String toString() => r'productDetailProvider';
}
