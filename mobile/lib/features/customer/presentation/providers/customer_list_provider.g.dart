// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current search text (name, email or phone). [CustomerList] watches it.

@ProviderFor(CustomerSearchQuery)
final customerSearchQueryProvider = CustomerSearchQueryProvider._();

/// Current search text (name, email or phone). [CustomerList] watches it.
final class CustomerSearchQueryProvider
    extends $NotifierProvider<CustomerSearchQuery, String> {
  /// Current search text (name, email or phone). [CustomerList] watches it.
  CustomerSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerSearchQueryHash();

  @$internal
  @override
  CustomerSearchQuery create() => CustomerSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$customerSearchQueryHash() =>
    r'57fa0239c5c71f440755200e126210b5fff577cd';

/// Current search text (name, email or phone). [CustomerList] watches it.

abstract class _$CustomerSearchQuery extends $Notifier<String> {
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

@ProviderFor(CustomerList)
final customerListProvider = CustomerListProvider._();

final class CustomerListProvider
    extends $AsyncNotifierProvider<CustomerList, PagedState<Customer>> {
  CustomerListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerListHash();

  @$internal
  @override
  CustomerList create() => CustomerList();
}

String _$customerListHash() => r'ec8ca356c37dbd578fd689817d6c5a20ff4e026a';

abstract class _$CustomerList extends $AsyncNotifier<PagedState<Customer>> {
  FutureOr<PagedState<Customer>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PagedState<Customer>>, PagedState<Customer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<Customer>>,
                PagedState<Customer>
              >,
              AsyncValue<PagedState<Customer>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// First page of customers matching [query] (name, email or phone), for
/// pickers such as the order form. Refine the query to find others.

@ProviderFor(customerSearch)
final customerSearchProvider = CustomerSearchFamily._();

/// First page of customers matching [query] (name, email or phone), for
/// pickers such as the order form. Refine the query to find others.

final class CustomerSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Customer>>,
          List<Customer>,
          FutureOr<List<Customer>>
        >
    with $FutureModifier<List<Customer>>, $FutureProvider<List<Customer>> {
  /// First page of customers matching [query] (name, email or phone), for
  /// pickers such as the order form. Refine the query to find others.
  CustomerSearchProvider._({
    required CustomerSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerSearchHash();

  @override
  String toString() {
    return r'customerSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Customer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Customer>> create(Ref ref) {
    final argument = this.argument as String;
    return customerSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerSearchHash() => r'4102835578d77483a0b175b47a8058829db5ef55';

/// First page of customers matching [query] (name, email or phone), for
/// pickers such as the order form. Refine the query to find others.

final class CustomerSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Customer>>, String> {
  CustomerSearchFamily._()
    : super(
        retry: null,
        name: r'customerSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// First page of customers matching [query] (name, email or phone), for
  /// pickers such as the order form. Refine the query to find others.

  CustomerSearchProvider call(String query) =>
      CustomerSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'customerSearchProvider';
}
