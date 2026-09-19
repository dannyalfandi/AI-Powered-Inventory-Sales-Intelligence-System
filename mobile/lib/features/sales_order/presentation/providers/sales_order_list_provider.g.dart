// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalesOrderFilters)
final salesOrderFiltersProvider = SalesOrderFiltersProvider._();

final class SalesOrderFiltersProvider
    extends $NotifierProvider<SalesOrderFilters, SalesOrderFilter> {
  SalesOrderFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesOrderFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesOrderFiltersHash();

  @$internal
  @override
  SalesOrderFilters create() => SalesOrderFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesOrderFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesOrderFilter>(value),
    );
  }
}

String _$salesOrderFiltersHash() => r'18cd05e707cc3f72a14ea8cdb1a308fe75959816';

abstract class _$SalesOrderFilters extends $Notifier<SalesOrderFilter> {
  SalesOrderFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SalesOrderFilter, SalesOrderFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SalesOrderFilter, SalesOrderFilter>,
              SalesOrderFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Orders matching [salesOrderFiltersProvider], newest first, page by page.

@ProviderFor(SalesOrderList)
final salesOrderListProvider = SalesOrderListProvider._();

/// Orders matching [salesOrderFiltersProvider], newest first, page by page.
final class SalesOrderListProvider
    extends $AsyncNotifierProvider<SalesOrderList, PagedState<SalesOrder>> {
  /// Orders matching [salesOrderFiltersProvider], newest first, page by page.
  SalesOrderListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesOrderListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesOrderListHash();

  @$internal
  @override
  SalesOrderList create() => SalesOrderList();
}

String _$salesOrderListHash() => r'3a17503d63b0650b3b008635f27bdadb7571c8f3';

/// Orders matching [salesOrderFiltersProvider], newest first, page by page.

abstract class _$SalesOrderList extends $AsyncNotifier<PagedState<SalesOrder>> {
  FutureOr<PagedState<SalesOrder>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PagedState<SalesOrder>>, PagedState<SalesOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<SalesOrder>>,
                PagedState<SalesOrder>
              >,
              AsyncValue<PagedState<SalesOrder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
