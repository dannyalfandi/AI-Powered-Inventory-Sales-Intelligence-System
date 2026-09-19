import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';
import 'package:inventory_intel/features/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockSalesOrderRepository extends Mock implements SalesOrderRepository {}

final _ts = DateTime.utc(2026, 9, 20, 3);

const orderCustomer = OrderCustomer(id: 7, name: 'Budi Santoso', email: 'budi@example.com', phone: '0812', address: 'Jl. A');

const kopiItem = SalesOrderItem(
  id: 1,
  productId: 10,
  productSku: 'KOPI-1',
  productName: 'Kopi Arabica',
  quantity: 3,
  unitPrice: 45000,
  subtotal: 135000,
);

const tehItem = SalesOrderItem(
  id: 2,
  productId: 20,
  productSku: 'TEH-1',
  productName: 'Teh Melati',
  quantity: 5,
  unitPrice: 10000,
  subtotal: 50000,
);

/// Order 1: Kopi × 3 + Teh × 5 = Rp 185.000 for customer 7.
SalesOrder salesOrder(
  int id, {
  OrderStatus status = OrderStatus.pending,
  List<SalesOrderItem> items = const [kopiItem, tehItem],
  String? number,
  OrderCustomer? customer = orderCustomer,
}) =>
    SalesOrder(
      id: id,
      orderNumber: number ?? 'SO-20260920-${id.toString().padLeft(4, '0')}',
      customerId: 7,
      customer: customer,
      status: status,
      totalAmount: items.fold(0, (s, i) => s + i.subtotal),
      notes: '',
      confirmedAt: status == OrderStatus.confirmed || status == OrderStatus.shipped ? _ts : null,
      shippedAt: status == OrderStatus.shipped ? _ts : null,
      cancelledAt: status == OrderStatus.cancelled ? _ts : null,
      createdAt: _ts,
      updatedAt: _ts,
      items: items,
    );

PageResult<SalesOrder> orderPage(List<SalesOrder> items, {int page = 1, int pageSize = 20, int? total}) =>
    PageResult(items: items, page: page, pageSize: pageSize, total: total ?? items.length);

/// The 422 the backend returns when confirming with short stock for the
/// second item (message format from backend deductStock).
const tehShortFailure = ValidationFailure(
  'request validation failed',
  messages: {'items[1].quantity': 'insufficient stock for product 20 (TEH-1): 3 available, 5 requested'},
);

void registerSalesOrderFallbacks() {
  registerFallbackValue(const SalesOrderInput(customerId: 1, items: []));
  registerFallbackValue(OrderStatus.pending);
  registerFallbackValue(salesOrder(0));
}
