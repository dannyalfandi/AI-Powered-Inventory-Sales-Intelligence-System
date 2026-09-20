import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/dashboard.dart';
import '../models/dashboard_models.dart';
import '../models/forecast_models.dart';

/// The backend reads ?from=&to= as plain dates in APP_TIMEZONE.
final _apiDate = DateFormat('yyyy-MM-dd');

/// Talks to the read-only `/api/v1/analytics` endpoints. Throws
/// [DioException] or parsing errors; the repository converts both into `Failure`.
abstract interface class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> fetchSummary(AnalyticsRange range);

  Future<SalesTrendModel> fetchSalesTrend(AnalyticsRange range, TrendGranularity granularity);

  Future<TopProductsResponse> fetchTopProducts(AnalyticsRange range, int limit);

  Future<CategoryBreakdownResponse> fetchCategoryBreakdown(AnalyticsRange range);

  Future<int> fetchLowStockAlertCount();

  /// Demand forecast per product. The response is a *report*: it can say the
  /// ML service is unavailable while still being a valid 200.
  Future<ForecastReportModel> fetchForecast(AnalyticsRange range, int limit, int horizonDays);

  /// Trend sentence per product, same report semantics.
  Future<InsightReportModel> fetchInsights(AnalyticsRange range, int limit);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  const DashboardRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _path = ApiConstants.analyticsPath;

  @override
  Future<DashboardSummaryModel> fetchSummary(AnalyticsRange range) async =>
      DashboardSummaryModel.fromJson(await _get('$_path/summary', _rangeQuery(range)));

  @override
  Future<SalesTrendModel> fetchSalesTrend(AnalyticsRange range, TrendGranularity granularity) async =>
      SalesTrendModel.fromJson(
        await _get('$_path/sales-trend', {
          ..._rangeQuery(range),
          'granularity': TrendGranularityCodec.encode(granularity),
        }),
      );

  @override
  Future<TopProductsResponse> fetchTopProducts(AnalyticsRange range, int limit) async =>
      TopProductsResponse.fromJson(await _get('$_path/top-products', {..._rangeQuery(range), 'limit': limit}));

  @override
  Future<CategoryBreakdownResponse> fetchCategoryBreakdown(AnalyticsRange range) async =>
      CategoryBreakdownResponse.fromJson(await _get('$_path/category-breakdown', _rangeQuery(range)));

  @override
  Future<int> fetchLowStockAlertCount() async =>
      LowStockAlertCountResponse.fromJson(await _get('$_path/low-stock-alert-count', const {})).count;

  @override
  Future<ForecastReportModel> fetchForecast(AnalyticsRange range, int limit, int horizonDays) async =>
      ForecastReportModel.fromJson(
        await _get('$_path/forecast', {..._rangeQuery(range), 'limit': limit, 'horizon_days': horizonDays}),
      );

  @override
  Future<InsightReportModel> fetchInsights(AnalyticsRange range, int limit) async =>
      InsightReportModel.fromJson(await _get('$_path/insights', {..._rangeQuery(range), 'limit': limit}));

  Map<String, dynamic> _rangeQuery(AnalyticsRange range) => {
    'from': _apiDate.format(range.from),
    'to': _apiDate.format(range.to),
  };

  /// Unwraps the `{"data": {...}}` envelope.
  Future<Map<String, dynamic>> _get(String path, Map<String, dynamic> query) async {
    final res = await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
    return res.data!['data'] as Map<String, dynamic>;
  }
}
