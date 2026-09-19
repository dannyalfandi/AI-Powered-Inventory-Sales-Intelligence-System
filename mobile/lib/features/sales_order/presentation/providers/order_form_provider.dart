import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../customer/domain/entities/customer.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/entities/sales_order.dart';
import 'sales_order_list_provider.dart';
import 'sales_order_providers.dart';

part 'order_form_provider.freezed.dart';
part 'order_form_provider.g.dart';

/// One line of the order being built: the picked product (for name, SKU and
/// the current price used by the running total) and the typed quantity.
@freezed
abstract class OrderFormLine with _$OrderFormLine {
  const OrderFormLine._();

  const factory OrderFormLine({
    required Product product,

    /// Null while the quantity field is empty.
    int? quantity,
  }) = _OrderFormLine;

  int get subtotal => product.price * (quantity ?? 0);
}

@freezed
abstract class OrderFormState with _$OrderFormState {
  const OrderFormState._();

  const factory OrderFormState({
    Customer? customer,
    @Default([]) List<OrderFormLine> lines,
    @Default('') String notes,
  }) = _OrderFormState;

  /// Estimate from current product prices. The backend snapshots prices
  /// when the order is created, so the saved total can differ if a price
  /// changed meanwhile.
  int get total => lines.fold(0, (sum, l) => sum + l.subtotal);

  bool containsProduct(int productId) => lines.any((l) => l.product.id == productId);

  SalesOrderInput toInput() => SalesOrderInput(
        customerId: customer?.id,
        items: [for (final l in lines) OrderLineInput(productId: l.product.id, quantity: l.quantity)],
        notes: notes,
      );
}

/// State of the "create order" form. Auto-disposed: leaving the screen
/// discards the draft.
@riverpod
class OrderForm extends _$OrderForm {
  @override
  OrderFormState build() => const OrderFormState();

  void setCustomer(Customer customer) => state = state.copyWith(customer: customer);

  /// Adds [product] with quantity 1. Returns false (and changes nothing) if
  /// the product is already in the order: the backend rejects duplicates,
  /// the quantity of the existing line should be raised instead.
  bool addProduct(Product product) {
    if (state.containsProduct(product.id)) return false;
    state = state.copyWith(lines: [...state.lines, OrderFormLine(product: product, quantity: 1)]);
    return true;
  }

  void setQuantity(int index, int? quantity) {
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(quantity: quantity);
    state = state.copyWith(lines: lines);
  }

  void removeLine(int index) => state = state.copyWith(lines: [...state.lines]..removeAt(index));

  void setNotes(String notes) => state = state.copyWith(notes: notes);

  /// Creates the order (PENDING). Throws `Failure`; `ValidationFailure` keys
  /// (`customer_id`, `items`, `items[i].quantity`, ...) match the line order.
  Future<SalesOrder> submit() async {
    final order = await ref.read(createSalesOrderUseCaseProvider)(state.toInput());
    ref.invalidate(salesOrderListProvider);
    return order;
  }
}
