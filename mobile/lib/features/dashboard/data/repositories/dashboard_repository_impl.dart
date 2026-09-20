import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/guard.dart';
import '../../domain/entities/dashboard.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<DashboardSummary> getSummary(AnalyticsRange range) =>
      guardApiCall(() async => (await _remote.fetchSummary(range)).toEntity());

  @override
  Future<SalesTrend> getSalesTrend(AnalyticsRange range, TrendGranularity granularity) =>
      guardApiCall(() async => (await _remote.fetchSalesTrend(range, granularity)).toEntity());

  @override
  Future<List<TopProduct>> getTopProducts(AnalyticsRange range, {int limit = ApiConstants.topProductsLimit}) =>
      guardApiCall(() async => (await _remote.fetchTopProducts(range, limit)).toEntities());

  @override
  Future<List<CategoryBreakdown>> getCategoryBreakdown(AnalyticsRange range) =>
      guardApiCall(() async => (await _remote.fetchCategoryBreakdown(range)).toEntities());

  @override
  Future<int> getLowStockAlertCount() => guardApiCall(_remote.fetchLowStockAlertCount);
}
