// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current search text. [CategoryList] watches it, so changing the query
/// rebuilds the list from page 1.

@ProviderFor(CategorySearchQuery)
final categorySearchQueryProvider = CategorySearchQueryProvider._();

/// Current search text. [CategoryList] watches it, so changing the query
/// rebuilds the list from page 1.
final class CategorySearchQueryProvider
    extends $NotifierProvider<CategorySearchQuery, String> {
  /// Current search text. [CategoryList] watches it, so changing the query
  /// rebuilds the list from page 1.
  CategorySearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categorySearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categorySearchQueryHash();

  @$internal
  @override
  CategorySearchQuery create() => CategorySearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$categorySearchQueryHash() =>
    r'20abe00e297415cda2b4afc98c4635ff62fac085';

/// Current search text. [CategoryList] watches it, so changing the query
/// rebuilds the list from page 1.

abstract class _$CategorySearchQuery extends $Notifier<String> {
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

@ProviderFor(CategoryList)
final categoryListProvider = CategoryListProvider._();

final class CategoryListProvider
    extends $AsyncNotifierProvider<CategoryList, PagedState<Category>> {
  CategoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListHash();

  @$internal
  @override
  CategoryList create() => CategoryList();
}

String _$categoryListHash() => r'38be10a56a0604289e62fcea986754cf15210310';

abstract class _$CategoryList extends $AsyncNotifier<PagedState<Category>> {
  FutureOr<PagedState<Category>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PagedState<Category>>, PagedState<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<Category>>,
                PagedState<Category>
              >,
              AsyncValue<PagedState<Category>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Every category, for the product form's category picker. Invalidated
/// whenever categories are created, renamed or deleted.

@ProviderFor(categoryOptions)
final categoryOptionsProvider = CategoryOptionsProvider._();

/// Every category, for the product form's category picker. Invalidated
/// whenever categories are created, renamed or deleted.

final class CategoryOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  /// Every category, for the product form's category picker. Invalidated
  /// whenever categories are created, renamed or deleted.
  CategoryOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categoryOptions(ref);
  }
}

String _$categoryOptionsHash() => r'0aee83b3d1b3499a998d257ffdd057dc54993db9';
