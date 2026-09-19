import '../../../../core/error/guard.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/sales_order.dart';
import '../../domain/repositories/sales_order_repository.dart';
import '../datasources/sales_order_remote_data_source.dart';
import '../models/sales_order_model.dart';

class SalesOrderRepositoryImpl implements SalesOrderRepository {
  const SalesOrderRepositoryImpl(this._remote);

  final SalesOrderRemoteDataSource _remote;

  @override
  Future<PageResult<SalesOrder>> getOrders({
    required int page,
    required int pageSize,
    OrderStatus? status,
    int? customerId,
  }) =>
      guardApiCall(() async {
        final (items, meta) = await _remote.fetchOrders(
          page: page,
          pageSize: pageSize,
          status: status == null ? null : OrderStatusCodec.encode(status),
          customerId: customerId,
        );
        return PageResult(
          items: items.map((m) => m.toEntity()).toList(),
          page: meta.page,
          pageSize: meta.pageSize,
          total: meta.total,
        );
      });

  @override
  Future<SalesOrder> getOrderById(int id) => guardApiCall(() async => (await _remote.fetchOrder(id)).toEntity());

  @override
  Future<SalesOrder> createOrder(SalesOrderInput input) => guardApiCall(
        () async => (await _remote.createOrder(CreateSalesOrderRequest.fromEntity(input))).toEntity(),
      );

  @override
  Future<SalesOrder> changeStatus(int id, OrderStatus status) => guardApiCall(
        () async => (await _remote.updateStatus(
          id,
          UpdateOrderStatusRequest(status: OrderStatusCodec.encode(status)),
        ))
            .toEntity(),
      );
}
