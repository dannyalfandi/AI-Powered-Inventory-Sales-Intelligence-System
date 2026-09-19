import '../../../../core/error/failure.dart';
import '../entities/sales_order.dart';
import '../repositories/sales_order_repository.dart';

class GetSalesOrderById {
  const GetSalesOrderById(this._repository);

  final SalesOrderRepository _repository;

  Future<SalesOrder> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('ID pesanan tidak valid', messages: {'id': 'harus bilangan positif'});
    }
    return _repository.getOrderById(id);
  }
}
