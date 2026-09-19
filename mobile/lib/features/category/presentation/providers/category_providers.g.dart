// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryRemoteDataSource)
final categoryRemoteDataSourceProvider = CategoryRemoteDataSourceProvider._();

final class CategoryRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CategoryRemoteDataSource,
          CategoryRemoteDataSource,
          CategoryRemoteDataSource
        >
    with $Provider<CategoryRemoteDataSource> {
  CategoryRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CategoryRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRemoteDataSource create(Ref ref) {
    return categoryRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRemoteDataSource>(value),
    );
  }
}

String _$categoryRemoteDataSourceHash() =>
    r'9fa78b0396cb69924abd7cd9e536d810c83bea65';

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'd3c42540c59137389e147c6ca99e4cd213557aa0';

@ProviderFor(getCategoriesUseCase)
final getCategoriesUseCaseProvider = GetCategoriesUseCaseProvider._();

final class GetCategoriesUseCaseProvider
    extends $FunctionalProvider<GetCategories, GetCategories, GetCategories>
    with $Provider<GetCategories> {
  GetCategoriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCategoriesUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCategoriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCategories> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCategories create(Ref ref) {
    return getCategoriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCategories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCategories>(value),
    );
  }
}

String _$getCategoriesUseCaseHash() =>
    r'034687641219ca80880517b85d4762b796944184';

@ProviderFor(getCategoryByIdUseCase)
final getCategoryByIdUseCaseProvider = GetCategoryByIdUseCaseProvider._();

final class GetCategoryByIdUseCaseProvider
    extends
        $FunctionalProvider<GetCategoryById, GetCategoryById, GetCategoryById>
    with $Provider<GetCategoryById> {
  GetCategoryByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCategoryByIdUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCategoryByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCategoryById> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCategoryById create(Ref ref) {
    return getCategoryByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCategoryById value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCategoryById>(value),
    );
  }
}

String _$getCategoryByIdUseCaseHash() =>
    r'26573aba313b5dd828d592e0cf3eaaa61d21cf7f';

@ProviderFor(createCategoryUseCase)
final createCategoryUseCaseProvider = CreateCategoryUseCaseProvider._();

final class CreateCategoryUseCaseProvider
    extends $FunctionalProvider<CreateCategory, CreateCategory, CreateCategory>
    with $Provider<CreateCategory> {
  CreateCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCategoryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateCategory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateCategory create(Ref ref) {
    return createCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCategory>(value),
    );
  }
}

String _$createCategoryUseCaseHash() =>
    r'59d943b60014f274b82c1258bc0138c53aa445b8';

@ProviderFor(updateCategoryUseCase)
final updateCategoryUseCaseProvider = UpdateCategoryUseCaseProvider._();

final class UpdateCategoryUseCaseProvider
    extends $FunctionalProvider<UpdateCategory, UpdateCategory, UpdateCategory>
    with $Provider<UpdateCategory> {
  UpdateCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCategoryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateCategory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateCategory create(Ref ref) {
    return updateCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateCategory>(value),
    );
  }
}

String _$updateCategoryUseCaseHash() =>
    r'0a005f9e11f73ce766cf245eee49f5c0740cca0a';

@ProviderFor(deleteCategoryUseCase)
final deleteCategoryUseCaseProvider = DeleteCategoryUseCaseProvider._();

final class DeleteCategoryUseCaseProvider
    extends $FunctionalProvider<DeleteCategory, DeleteCategory, DeleteCategory>
    with $Provider<DeleteCategory> {
  DeleteCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteCategoryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteCategory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteCategory create(Ref ref) {
    return deleteCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteCategory>(value),
    );
  }
}

String _$deleteCategoryUseCaseHash() =>
    r'9d06b9618a9335a19faf11caee4cc348b020a059';
