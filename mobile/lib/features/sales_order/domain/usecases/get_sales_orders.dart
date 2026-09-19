import '../../../../core/constants/api_constants.dart';
import '../../../../core/pagination/paged.dart';
import '../entities/sales_order.dart';
import '../repositories/sales_order_repository.dart';

class GetSalesOrders {
  const GetSalesOrders(this._repository);

  final SalesOrderRepository _repository;

  Future<PageResult<SalesOrder>> call({
    int page = 1,
    int pageSize = ApiConstants.defaultPageSize,
    OrderStatus? status,
    int? customerId,
  }) {
    return _repository.getOrders(
      page: page < 1 ? 1 : page,
      pageSize: pageSize.clamp(1, ApiConstants.maxPageSize),
      status: status,
      customerId: customerId != null && customerId > 0 ? customerId : null,
    );
  }
}
