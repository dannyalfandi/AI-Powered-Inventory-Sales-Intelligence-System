import '../../../../core/constants/api_constants.dart';
import '../entities/dashboard.dart';
import '../entities/forecast.dart';
import '../repositories/dashboard_repository.dart';

class GetBusinessInsights {
  const GetBusinessInsights(this._repository);

  final DashboardRepository _repository;

  Future<InsightReport> call(AnalyticsRange range, {int limit = ApiConstants.forecastProductsLimit}) =>
      _repository.getInsights(range, limit: limit.clamp(1, 50));
}
