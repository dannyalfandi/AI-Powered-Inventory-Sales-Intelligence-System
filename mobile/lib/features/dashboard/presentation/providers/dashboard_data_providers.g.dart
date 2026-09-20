// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardSummary)
final dashboardSummaryProvider = DashboardSummaryProvider._();

final class DashboardSummaryProvider
    extends $FunctionalProvider<AsyncValue<DashboardSummary>, DashboardSummary, FutureOr<DashboardSummary>>
    with $FutureModifier<DashboardSummary>, $FutureProvider<DashboardSummary> {
  DashboardSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSummaryHash();

  @$internal
  @override
  $FutureProviderElement<DashboardSummary> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardSummary> create(Ref ref) {
    return dashboardSummary(ref);
  }
}

String _$dashboardSummaryHash() => r'ba9984a17d977dc5a53939cde60c18d2bc759794';

@ProviderFor(dashboardSalesTrend)
final dashboardSalesTrendProvider = DashboardSalesTrendProvider._();

final class DashboardSalesTrendProvider
    extends $FunctionalProvider<AsyncValue<SalesTrend>, SalesTrend, FutureOr<SalesTrend>>
    with $FutureModifier<SalesTrend>, $FutureProvider<SalesTrend> {
  DashboardSalesTrendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSalesTrendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSalesTrendHash();

  @$internal
  @override
  $FutureProviderElement<SalesTrend> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<SalesTrend> create(Ref ref) {
    return dashboardSalesTrend(ref);
  }
}

String _$dashboardSalesTrendHash() => r'1885e63f6208c6a839137c2fa857e6a9e047c847';

@ProviderFor(dashboardTopProducts)
final dashboardTopProductsProvider = DashboardTopProductsProvider._();

final class DashboardTopProductsProvider
    extends $FunctionalProvider<AsyncValue<List<TopProduct>>, List<TopProduct>, FutureOr<List<TopProduct>>>
    with $FutureModifier<List<TopProduct>>, $FutureProvider<List<TopProduct>> {
  DashboardTopProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardTopProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardTopProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<TopProduct>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TopProduct>> create(Ref ref) {
    return dashboardTopProducts(ref);
  }
}

String _$dashboardTopProductsHash() => r'6907cb6fc83022dc156eaaf3963f7b77eb4bb1a4';

@ProviderFor(dashboardCategoryBreakdown)
final dashboardCategoryBreakdownProvider = DashboardCategoryBreakdownProvider._();

final class DashboardCategoryBreakdownProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryBreakdown>>,
          List<CategoryBreakdown>,
          FutureOr<List<CategoryBreakdown>>
        >
    with $FutureModifier<List<CategoryBreakdown>>, $FutureProvider<List<CategoryBreakdown>> {
  DashboardCategoryBreakdownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardCategoryBreakdownProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardCategoryBreakdownHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryBreakdown>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryBreakdown>> create(Ref ref) {
    return dashboardCategoryBreakdown(ref);
  }
}

String _$dashboardCategoryBreakdownHash() => r'f212160f9b47087e41dbf8acbaceee7b7c93263c';

/// Products at or below their low-stock threshold. Not range-bound: it is
/// "right now" state, so it deliberately does not watch the date range.

@ProviderFor(dashboardLowStockCount)
final dashboardLowStockCountProvider = DashboardLowStockCountProvider._();

/// Products at or below their low-stock threshold. Not range-bound: it is
/// "right now" state, so it deliberately does not watch the date range.

final class DashboardLowStockCountProvider extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Products at or below their low-stock threshold. Not range-bound: it is
  /// "right now" state, so it deliberately does not watch the date range.
  DashboardLowStockCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardLowStockCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardLowStockCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return dashboardLowStockCount(ref);
  }
}

String _$dashboardLowStockCountHash() => r'1ebb2f1f66f9e1562a4c88b9cdf0cc8b14128dff';
