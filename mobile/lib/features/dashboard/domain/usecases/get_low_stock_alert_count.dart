import '../repositories/dashboard_repository.dart';

class GetLowStockAlertCount {
  const GetLowStockAlertCount(this._repository);

  final DashboardRepository _repository;

  Future<int> call() => _repository.getLowStockAlertCount();
}
