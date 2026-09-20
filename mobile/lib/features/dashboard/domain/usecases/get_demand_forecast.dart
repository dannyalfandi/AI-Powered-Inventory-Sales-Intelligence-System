import '../../../../core/constants/api_constants.dart';
import '../entities/dashboard.dart';
import '../entities/forecast.dart';
import '../repositories/dashboard_repository.dart';

class GetDemandForecast {
  const GetDemandForecast(this._repository);

  final DashboardRepository _repository;

  Future<ForecastReport> call(
    AnalyticsRange range, {
    int limit = ApiConstants.forecastProductsLimit,
    int horizonDays = ApiConstants.forecastHorizonDays,
  }) => _repository.getForecast(
    range,
    limit: limit.clamp(1, 50),
    // The backend caps the horizon at 90 days.
    horizonDays: horizonDays.clamp(1, 90),
  );
}
