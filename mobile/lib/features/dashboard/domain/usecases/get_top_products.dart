import '../../../../core/constants/api_constants.dart';
import '../entities/dashboard.dart';
import '../repositories/dashboard_repository.dart';

class GetTopProducts {
  const GetTopProducts(this._repository);

  final DashboardRepository _repository;

  Future<List<TopProduct>> call(AnalyticsRange range, {int limit = ApiConstants.topProductsLimit}) =>
      _repository.getTopProducts(range, limit: limit.clamp(1, 50));
}
