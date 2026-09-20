import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/dashboard.dart';

part 'dashboard_filter_provider.g.dart';

/// Preset windows offered as chips, in days (today included).
const dashboardPresetDays = [7, 30, 90];

/// The single source of truth for the dashboard date range: every data
/// provider watches it, so one change refreshes the whole page at once.
///
/// Only the range lives here. The chart granularity is a separate provider
/// ([TrendGranularityFilter]) so switching daily/weekly refetches the trend
/// alone instead of all four range-based endpoints.
@riverpod
class DashboardDateRange extends _$DashboardDateRange {
  /// The backend default too: the last 30 days.
  @override
  AnalyticsRange build() => AnalyticsRange.last30Days(DateTime.now());

  void setPresetDays(int days) => state = AnalyticsRange.lastDays(DateTime.now(), days);

  /// [from]/[to] come from the date range picker; both ends are inclusive.
  void setCustomRange(DateTime from, DateTime to) => state = AnalyticsRange(from: _dateOnly(from), to: _dateOnly(to));

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

/// Bucket size of the sales trend chart only.
@riverpod
class TrendGranularityFilter extends _$TrendGranularityFilter {
  @override
  TrendGranularity build() => TrendGranularity.daily;

  void set(TrendGranularity granularity) => state = granularity;
}
