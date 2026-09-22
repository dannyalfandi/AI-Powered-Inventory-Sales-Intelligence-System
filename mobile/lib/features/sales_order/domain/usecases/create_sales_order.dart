import '../../../../core/error/failure.dart';
import '../entities/sales_order.dart';
import '../repositories/sales_order_repository.dart';

class CreateSalesOrder {
  const CreateSalesOrder(this._repository);

  final SalesOrderRepository _repository;

  /// Validates locally with [OrderRules] (customer, 1–100 items, no
  /// duplicate products, quantity 1–1,000,000) before calling the API.
  /// Product existence is checked by the backend.
  Future<SalesOrder> call(SalesOrderInput input) async {
    final data = input.copyWith(notes: input.notes.trim());
    final issues = OrderRules.validate(data);
    if (issues.isNotEmpty) {
      throw ValidationFailure('input is not valid', issues: issues, issue: FailureIssue.localValidation);
    }
    return _repository.createOrder(data);
  }
}
