import '../../../../core/error/failure.dart';
import '../entities/sales_order.dart';
import '../repositories/sales_order_repository.dart';

class ChangeOrderStatus {
  const ChangeOrderStatus(this._repository);

  final SalesOrderRepository _repository;

  /// Moves [order] to [target]. Transitions the state machine forbids are
  /// rejected locally (same `status` key as the backend's 422), so the API
  /// is never asked for them. The backend still re-checks: the order may
  /// have changed on another device.
  Future<SalesOrder> call(SalesOrder order, OrderStatus target) async {
    if (!order.status.canMoveTo(target)) {
      throw ValidationFailure(
        'Transisi status tidak valid',
        messages: {'status': 'Pesanan ${order.status.name} tidak bisa diubah ke ${target.name}'},
      );
    }
    return _repository.changeStatus(order.id, target);
  }
}
