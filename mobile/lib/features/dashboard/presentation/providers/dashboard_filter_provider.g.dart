// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single source of truth for the dashboard date range: every data
/// provider watches it, so one change refreshes the whole page at once.
///
/// Only the range lives here. The chart granularity is a separate provider
/// ([TrendGranularityFilter]) so switching daily/weekly refetches the trend
/// alone instead of all four range-based endpoints.

@ProviderFor(DashboardDateRange)
final dashboardDateRangeProvider = DashboardDateRangeProvider._();

/// The single source of truth for the dashboard date range: every data
/// provider watches it, so one change refreshes the whole page at once.
///
/// Only the range lives here. The chart granularity is a separate provider
/// ([TrendGranularityFilter]) so switching daily/weekly refetches the trend
/// alone instead of all four range-based endpoints.
final class DashboardDateRangeProvider extends $NotifierProvider<DashboardDateRange, AnalyticsRange> {
  /// The single source of truth for the dashboard date range: every data
  /// provider watches it, so one change refreshes the whole page at once.
  ///
  /// Only the range lives here. The chart granularity is a separate provider
  /// ([TrendGranularityFilter]) so switching daily/weekly refetches the trend
  /// alone instead of all four range-based endpoints.
  DashboardDateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardDateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardDateRangeHash();

  @$internal
  @override
  DashboardDateRange create() => DashboardDateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsRange value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AnalyticsRange>(value));
  }
}

String _$dashboardDateRangeHash() => r'a917a8e4d250a7633b2be6f05982642cd9cb60bf';

/// The single source of truth for the dashboard date range: every data
/// provider watches it, so one change refreshes the whole page at once.
///
/// Only the range lives here. The chart granularity is a separate provider
/// ([TrendGranularityFilter]) so switching daily/weekly refetches the trend
/// alone instead of all four range-based endpoints.

abstract class _$DashboardDateRange extends $Notifier<AnalyticsRange> {
  AnalyticsRange build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AnalyticsRange, AnalyticsRange>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<AnalyticsRange, AnalyticsRange>, AnalyticsRange, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Bucket size of the sales trend chart only.

@ProviderFor(TrendGranularityFilter)
final trendGranularityFilterProvider = TrendGranularityFilterProvider._();

/// Bucket size of the sales trend chart only.
final class TrendGranularityFilterProvider extends $NotifierProvider<TrendGranularityFilter, TrendGranularity> {
  /// Bucket size of the sales trend chart only.
  TrendGranularityFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendGranularityFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendGranularityFilterHash();

  @$internal
  @override
  TrendGranularityFilter create() => TrendGranularityFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrendGranularity value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<TrendGranularity>(value));
  }
}

String _$trendGranularityFilterHash() => r'25437b8d31e13e56382d5042f995f92582147423';

/// Bucket size of the sales trend chart only.

abstract class _$TrendGranularityFilter extends $Notifier<TrendGranularity> {
  TrendGranularity build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TrendGranularity, TrendGranularity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrendGranularity, TrendGranularity>,
              TrendGranularity,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
