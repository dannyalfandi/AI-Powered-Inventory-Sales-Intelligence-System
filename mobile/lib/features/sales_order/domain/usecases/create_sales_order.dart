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
    final messages = OrderRules.validate(data);
    if (messages.isNotEmpty) {
      throw ValidationFailure('Pesanan belum lengkap', messages: messages);
    }
    return _repository.createOrder(data);
  }
}
