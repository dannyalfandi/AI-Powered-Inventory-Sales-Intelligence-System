// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardRemoteDataSource)
final dashboardRemoteDataSourceProvider = DashboardRemoteDataSourceProvider._();

final class DashboardRemoteDataSourceProvider
    extends $FunctionalProvider<DashboardRemoteDataSource, DashboardRemoteDataSource, DashboardRemoteDataSource>
    with $Provider<DashboardRemoteDataSource> {
  DashboardRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DashboardRemoteDataSource> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DashboardRemoteDataSource create(Ref ref) {
    return dashboardRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRemoteDataSource value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DashboardRemoteDataSource>(value));
  }
}

String _$dashboardRemoteDataSourceHash() => r'9376eddb9c30a2cfd69863db7805546b7ab10d95';

@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider = DashboardRepositoryProvider._();

final class DashboardRepositoryProvider
    extends $FunctionalProvider<DashboardRepository, DashboardRepository, DashboardRepository>
    with $Provider<DashboardRepository> {
  DashboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DashboardRepository>(value));
  }
}

String _$dashboardRepositoryHash() => r'1c5a70ec6bd419ebf1ce3d66158b8f2227ee07aa';

@ProviderFor(getDashboardSummaryUseCase)
final getDashboardSummaryUseCaseProvider = GetDashboardSummaryUseCaseProvider._();

final class GetDashboardSummaryUseCaseProvider
    extends $FunctionalProvider<GetDashboardSummary, GetDashboardSummary, GetDashboardSummary>
    with $Provider<GetDashboardSummary> {
  GetDashboardSummaryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDashboardSummaryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDashboardSummaryUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetDashboardSummary> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GetDashboardSummary create(Ref ref) {
    return getDashboardSummaryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDashboardSummary value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GetDashboardSummary>(value));
  }
}

String _$getDashboardSummaryUseCaseHash() => r'659309de99b80795abb8b48149b5229b5842daff';

@ProviderFor(getSalesTrendUseCase)
final getSalesTrendUseCaseProvider = GetSalesTrendUseCaseProvider._();

final class GetSalesTrendUseCaseProvider extends $FunctionalProvider<GetSalesTrend, GetSalesTrend, GetSalesTrend>
    with $Provider<GetSalesTrend> {
  GetSalesTrendUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSalesTrendUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSalesTrendUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSalesTrend> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GetSalesTrend create(Ref ref) {
    return getSalesTrendUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSalesTrend value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GetSalesTrend>(value));
  }
}

String _$getSalesTrendUseCaseHash() => r'd4aa5332b1bb3c76872ea8114e429cdf95fbd254';

@ProviderFor(getTopProductsUseCase)
final getTopProductsUseCaseProvider = GetTopProductsUseCaseProvider._();

final class GetTopProductsUseCaseProvider extends $FunctionalProvider<GetTopProducts, GetTopProducts, GetTopProducts>
    with $Provider<GetTopProducts> {
  GetTopProductsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTopProductsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTopProductsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTopProducts> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GetTopProducts create(Ref ref) {
    return getTopProductsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTopProducts value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GetTopProducts>(value));
  }
}

String _$getTopProductsUseCaseHash() => r'253c3f618f918596bd5589e6128961cd6a17ce97';

@ProviderFor(getCategoryBreakdownUseCase)
final getCategoryBreakdownUseCaseProvider = GetCategoryBreakdownUseCaseProvider._();

final class GetCategoryBreakdownUseCaseProvider
    extends $FunctionalProvider<GetCategoryBreakdown, GetCategoryBreakdown, GetCategoryBreakdown>
    with $Provider<GetCategoryBreakdown> {
  GetCategoryBreakdownUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCategoryBreakdownUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCategoryBreakdownUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCategoryBreakdown> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GetCategoryBreakdown create(Ref ref) {
    return getCategoryBreakdownUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCategoryBreakdown value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GetCategoryBreakdown>(value));
  }
}

String _$getCategoryBreakdownUseCaseHash() => r'da8e4c9727efbef4f2726b1396c41befe10f9214';

@ProviderFor(getLowStockAlertCountUseCase)
final getLowStockAlertCountUseCaseProvider = GetLowStockAlertCountUseCaseProvider._();

final class GetLowStockAlertCountUseCaseProvider
    extends $FunctionalProvider<GetLowStockAlertCount, GetLowStockAlertCount, GetLowStockAlertCount>
    with $Provider<GetLowStockAlertCount> {
  GetLowStockAlertCountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getLowStockAlertCountUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getLowStockAlertCountUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetLowStockAlertCount> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GetLowStockAlertCount create(Ref ref) {
    return getLowStockAlertCountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetLowStockAlertCount value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GetLowStockAlertCount>(value));
  }
}

String _$getLowStockAlertCountUseCaseHash() => r'eeba0de957589f8cbbdd26187519b0d1bc66ee7a';

@ProviderFor(getDemandForecastUseCase)
final getDemandForecastUseCaseProvider = GetDemandForecastUseCaseProvider._();

final class GetDemandForecastUseCaseProvider
    extends $FunctionalProvider<GetDemandForecast, GetDemandForecast, GetDemandForecast>
    with $Provider<GetDemandForecast> {
  GetDemandForecastUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDemandForecastUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDemandForecastUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetDemandForecast> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GetDemandForecast create(Ref ref) {
    return getDemandForecastUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDemandForecast value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GetDemandForecast>(value));
  }
}

String _$getDemandForecastUseCaseHash() => r'16eac457fc6b885f6ca94f168817695f0380650e';

@ProviderFor(getBusinessInsightsUseCase)
final getBusinessInsightsUseCaseProvider = GetBusinessInsightsUseCaseProvider._();

final class GetBusinessInsightsUseCaseProvider
    extends $FunctionalProvider<GetBusinessInsights, GetBusinessInsights, GetBusinessInsights>
    with $Provider<GetBusinessInsights> {
  GetBusinessInsightsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBusinessInsightsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBusinessInsightsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetBusinessInsights> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GetBusinessInsights create(Ref ref) {
    return getBusinessInsightsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBusinessInsights value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GetBusinessInsights>(value));
  }
}

String _$getBusinessInsightsUseCaseHash() => r'05d26d6b0348e6d7a7011710f67e714b30713841';
