// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State of the "create order" form. Auto-disposed: leaving the screen
/// discards the draft.

@ProviderFor(OrderForm)
final orderFormProvider = OrderFormProvider._();

/// State of the "create order" form. Auto-disposed: leaving the screen
/// discards the draft.
final class OrderFormProvider
    extends $NotifierProvider<OrderForm, OrderFormState> {
  /// State of the "create order" form. Auto-disposed: leaving the screen
  /// discards the draft.
  OrderFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderFormHash();

  @$internal
  @override
  OrderForm create() => OrderForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderFormState>(value),
    );
  }
}

String _$orderFormHash() => r'1d766c9d1b7fb4c42bcee4970fdcd436a0dae2bf';

/// State of the "create order" form. Auto-disposed: leaving the screen
/// discards the draft.

abstract class _$OrderForm extends $Notifier<OrderFormState> {
  OrderFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OrderFormState, OrderFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OrderFormState, OrderFormState>,
              OrderFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
