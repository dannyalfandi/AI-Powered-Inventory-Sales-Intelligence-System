// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One order with customer and items (GET /api/v1/sales-orders/:id).

@ProviderFor(SalesOrderDetail)
final salesOrderDetailProvider = SalesOrderDetailFamily._();

/// One order with customer and items (GET /api/v1/sales-orders/:id).
final class SalesOrderDetailProvider
    extends $AsyncNotifierProvider<SalesOrderDetail, SalesOrder> {
  /// One order with customer and items (GET /api/v1/sales-orders/:id).
  SalesOrderDetailProvider._({
    required SalesOrderDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'salesOrderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salesOrderDetailHash();

  @override
  String toString() {
    return r'salesOrderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalesOrderDetail create() => SalesOrderDetail();

  @override
  bool operator ==(Object other) {
    return other is SalesOrderDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salesOrderDetailHash() => r'94dafd8149acfa8a040aad5e3a536e79c539ec42';

/// One order with customer and items (GET /api/v1/sales-orders/:id).

final class SalesOrderDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          SalesOrderDetail,
          AsyncValue<SalesOrder>,
          SalesOrder,
          FutureOr<SalesOrder>,
          int
        > {
  SalesOrderDetailFamily._()
    : super(
        retry: null,
        name: r'salesOrderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One order with customer and items (GET /api/v1/sales-orders/:id).

  SalesOrderDetailProvider call(int orderId) =>
      SalesOrderDetailProvider._(argument: orderId, from: this);

  @override
  String toString() => r'salesOrderDetailProvider';
}

/// One order with customer and items (GET /api/v1/sales-orders/:id).

abstract class _$SalesOrderDetail extends $AsyncNotifier<SalesOrder> {
  late final _$args = ref.$arg as int;
  int get orderId => _$args;

  FutureOr<SalesOrder> build(int orderId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SalesOrder>, SalesOrder>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SalesOrder>, SalesOrder>,
              AsyncValue<SalesOrder>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
