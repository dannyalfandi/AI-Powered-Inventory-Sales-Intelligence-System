import '../entities/dashboard.dart';
import '../repositories/dashboard_repository.dart';

class GetCategoryBreakdown {
  const GetCategoryBreakdown(this._repository);

  final DashboardRepository _repository;

  Future<List<CategoryBreakdown>> call(AnalyticsRange range) => _repository.getCategoryBreakdown(range);
}
