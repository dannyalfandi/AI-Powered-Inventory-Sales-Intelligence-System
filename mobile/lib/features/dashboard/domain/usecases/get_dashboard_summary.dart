import '../entities/dashboard.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSummary {
  const GetDashboardSummary(this._repository);

  final DashboardRepository _repository;

  Future<DashboardSummary> call(AnalyticsRange range) => _repository.getSummary(range);
}
