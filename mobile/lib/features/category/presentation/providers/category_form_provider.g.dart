// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Backs the create/edit form. `categoryId == null` → create mode (state is
/// `null`); otherwise loads the category via GET /api/v1/categories/:id.

@ProviderFor(CategoryForm)
final categoryFormProvider = CategoryFormFamily._();

/// Backs the create/edit form. `categoryId == null` → create mode (state is
/// `null`); otherwise loads the category via GET /api/v1/categories/:id.
final class CategoryFormProvider
    extends $AsyncNotifierProvider<CategoryForm, Category?> {
  /// Backs the create/edit form. `categoryId == null` → create mode (state is
  /// `null`); otherwise loads the category via GET /api/v1/categories/:id.
  CategoryFormProvider._({
    required CategoryFormFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'categoryFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryFormHash();

  @override
  String toString() {
    return r'categoryFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CategoryForm create() => CategoryForm();

  @override
  bool operator ==(Object other) {
    return other is CategoryFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryFormHash() => r'56cb8daa42c6e2a4c98b3e4a2fa18c8684ea3a94';

/// Backs the create/edit form. `categoryId == null` → create mode (state is
/// `null`); otherwise loads the category via GET /api/v1/categories/:id.

final class CategoryFormFamily extends $Family
    with
        $ClassFamilyOverride<
          CategoryForm,
          AsyncValue<Category?>,
          Category?,
          FutureOr<Category?>,
          int?
        > {
  CategoryFormFamily._()
    : super(
        retry: null,
        name: r'categoryFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Backs the create/edit form. `categoryId == null` → create mode (state is
  /// `null`); otherwise loads the category via GET /api/v1/categories/:id.

  CategoryFormProvider call(int? categoryId) =>
      CategoryFormProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'categoryFormProvider';
}

/// Backs the create/edit form. `categoryId == null` → create mode (state is
/// `null`); otherwise loads the category via GET /api/v1/categories/:id.

abstract class _$CategoryForm extends $AsyncNotifier<Category?> {
  late final _$args = ref.$arg as int?;
  int? get categoryId => _$args;

  FutureOr<Category?> build(int? categoryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Category?>, Category?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Category?>, Category?>,
              AsyncValue<Category?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
