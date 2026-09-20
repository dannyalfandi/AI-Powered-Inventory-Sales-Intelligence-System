import '../entities/dashboard.dart';
import '../repositories/dashboard_repository.dart';

class GetSalesTrend {
  const GetSalesTrend(this._repository);

  final DashboardRepository _repository;

  Future<SalesTrend> call(AnalyticsRange range, TrendGranularity granularity) =>
      _repository.getSalesTrend(range, granularity);
}
