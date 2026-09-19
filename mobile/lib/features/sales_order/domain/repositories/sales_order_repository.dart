import '../../../../core/pagination/paged.dart';
import '../entities/sales_order.dart';

/// Sales order data access contract. Implementations throw only `Failure`
/// subclasses (see core/error/failure.dart), never raw transport exceptions.
abstract interface class SalesOrderRepository {
  /// Newest first. Items are not included (see [getOrderById]).
  Future<PageResult<SalesOrder>> getOrders({
    required int page,
    required int pageSize,
    OrderStatus? status,
    int? customerId,
  });

  /// With customer and items.
  Future<SalesOrder> getOrderById(int id);

  /// Creates a PENDING order; the backend snapshots product prices.
  Future<SalesOrder> createOrder(SalesOrderInput input);

  /// Runs one state machine transition. Throws `ValidationFailure` (422) for
  /// an invalid transition (`status`) or short stock on confirm
  /// (`items[i].quantity`, one entry per short item).
  Future<SalesOrder> changeStatus(int id, OrderStatus status);
}
