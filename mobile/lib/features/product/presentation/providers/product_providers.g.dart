// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRemoteDataSource)
final productRemoteDataSourceProvider = ProductRemoteDataSourceProvider._();

final class ProductRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ProductRemoteDataSource,
          ProductRemoteDataSource,
          ProductRemoteDataSource
        >
    with $Provider<ProductRemoteDataSource> {
  ProductRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProductRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRemoteDataSource create(Ref ref) {
    return productRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRemoteDataSource>(value),
    );
  }
}

String _$productRemoteDataSourceHash() =>
    r'215ac6dc4cdf2da5138f15e4a36b6d1fcdb5cb75';

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'7f8b8e37cbe10ff84a788d91011d5185b9da29c0';

@ProviderFor(getProductsUseCase)
final getProductsUseCaseProvider = GetProductsUseCaseProvider._();

final class GetProductsUseCaseProvider
    extends $FunctionalProvider<GetProducts, GetProducts, GetProducts>
    with $Provider<GetProducts> {
  GetProductsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getProductsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getProductsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetProducts> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetProducts create(Ref ref) {
    return getProductsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetProducts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetProducts>(value),
    );
  }
}

String _$getProductsUseCaseHash() =>
    r'4d7431c7450136ad9ab2e69f7937d58b0d80231d';

@ProviderFor(getProductByIdUseCase)
final getProductByIdUseCaseProvider = GetProductByIdUseCaseProvider._();

final class GetProductByIdUseCaseProvider
    extends $FunctionalProvider<GetProductById, GetProductById, GetProductById>
    with $Provider<GetProductById> {
  GetProductByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getProductByIdUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getProductByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetProductById> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetProductById create(Ref ref) {
    return getProductByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetProductById value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetProductById>(value),
    );
  }
}

String _$getProductByIdUseCaseHash() =>
    r'6a24dd4d260658cce0191c27f9fc6cb843db24f4';

@ProviderFor(createProductUseCase)
final createProductUseCaseProvider = CreateProductUseCaseProvider._();

final class CreateProductUseCaseProvider
    extends $FunctionalProvider<CreateProduct, CreateProduct, CreateProduct>
    with $Provider<CreateProduct> {
  CreateProductUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createProductUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateProduct> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateProduct create(Ref ref) {
    return createProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateProduct value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateProduct>(value),
    );
  }
}

String _$createProductUseCaseHash() =>
    r'29c9a77d3e512e686271c9a35cf3f104a7db9419';

@ProviderFor(updateProductUseCase)
final updateProductUseCaseProvider = UpdateProductUseCaseProvider._();

final class UpdateProductUseCaseProvider
    extends $FunctionalProvider<UpdateProduct, UpdateProduct, UpdateProduct>
    with $Provider<UpdateProduct> {
  UpdateProductUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProductUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateProduct> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateProduct create(Ref ref) {
    return updateProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProduct value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProduct>(value),
    );
  }
}

String _$updateProductUseCaseHash() =>
    r'1f850aaaa62c97c59162d3154ef5e24719909de6';

@ProviderFor(deleteProductUseCase)
final deleteProductUseCaseProvider = DeleteProductUseCaseProvider._();

final class DeleteProductUseCaseProvider
    extends $FunctionalProvider<DeleteProduct, DeleteProduct, DeleteProduct>
    with $Provider<DeleteProduct> {
  DeleteProductUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteProductUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteProduct> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteProduct create(Ref ref) {
    return deleteProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteProduct value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteProduct>(value),
    );
  }
}

String _$deleteProductUseCaseHash() =>
    r'2ab1c426b7a3ef99f341596d1f803843e380808b';
