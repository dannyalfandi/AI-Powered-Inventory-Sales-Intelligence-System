// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Backs the create/edit form. `customerId == null` → create mode (state is
/// `null`); otherwise loads the customer.

@ProviderFor(CustomerForm)
final customerFormProvider = CustomerFormFamily._();

/// Backs the create/edit form. `customerId == null` → create mode (state is
/// `null`); otherwise loads the customer.
final class CustomerFormProvider
    extends $AsyncNotifierProvider<CustomerForm, Customer?> {
  /// Backs the create/edit form. `customerId == null` → create mode (state is
  /// `null`); otherwise loads the customer.
  CustomerFormProvider._({
    required CustomerFormFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'customerFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerFormHash();

  @override
  String toString() {
    return r'customerFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerForm create() => CustomerForm();

  @override
  bool operator ==(Object other) {
    return other is CustomerFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerFormHash() => r'4e662359801b7002a17b2c8d0668cfb19936184f';

/// Backs the create/edit form. `customerId == null` → create mode (state is
/// `null`); otherwise loads the customer.

final class CustomerFormFamily extends $Family
    with
        $ClassFamilyOverride<
          CustomerForm,
          AsyncValue<Customer?>,
          Customer?,
          FutureOr<Customer?>,
          int?
        > {
  CustomerFormFamily._()
    : super(
        retry: null,
        name: r'customerFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Backs the create/edit form. `customerId == null` → create mode (state is
  /// `null`); otherwise loads the customer.

  CustomerFormProvider call(int? customerId) =>
      CustomerFormProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerFormProvider';
}

/// Backs the create/edit form. `customerId == null` → create mode (state is
/// `null`); otherwise loads the customer.

abstract class _$CustomerForm extends $AsyncNotifier<Customer?> {
  late final _$args = ref.$arg as int?;
  int? get customerId => _$args;

  FutureOr<Customer?> build(int? customerId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Customer?>, Customer?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Customer?>, Customer?>,
              AsyncValue<Customer?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
