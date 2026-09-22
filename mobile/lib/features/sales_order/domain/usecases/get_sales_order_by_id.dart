import '../../../../core/error/failure.dart';
import '../entities/sales_order.dart';
import '../repositories/sales_order_repository.dart';

class GetSalesOrderById {
  const GetSalesOrderById(this._repository);

  final SalesOrderRepository _repository;

  Future<SalesOrder> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('id must be a positive integer', issue: FailureIssue.localValidation);
    }
    return _repository.getOrderById(id);
  }
}
