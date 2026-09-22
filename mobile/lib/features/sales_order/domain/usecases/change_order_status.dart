import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
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
      throw const ValidationFailure(
        'invalid status transition',
        issues: {'status': FieldIssue(FieldIssueKind.orderTransitionInvalid)},
        issue: FailureIssue.localValidation,
      );
    }
    return _repository.changeStatus(order.id, target);
  }
}
