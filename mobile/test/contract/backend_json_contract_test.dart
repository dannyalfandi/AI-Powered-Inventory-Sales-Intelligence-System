import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/error/failure_mapper.dart';
import 'package:inventory_intel/features/category/data/models/category_model.dart';
import 'package:inventory_intel/features/customer/data/models/customer_model.dart';
import 'package:inventory_intel/features/inventory/data/models/inventory_model.dart';
import 'package:inventory_intel/features/inventory/domain/entities/inventory.dart';
import 'package:inventory_intel/features/product/data/models/product_model.dart';
import 'package:inventory_intel/features/sales_order/data/models/sales_order_model.dart';
import 'package:inventory_intel/features/sales_order/domain/entities/sales_order.dart';

// JSON below is copied from real responses of the Go backend
// (backend/internal/model + handlers), so these tests catch contract drift.

void main() {
  group('product', () {
    test('with a category: category_id + embedded full category object', () {
      final p = ProductModel.fromJson({
        'id': 8,
        'sku': 'KOPI-001',
        'name': 'Kopi Arabica',
        'description': '',
        'price': 45000,
        'category_id': 1,
        'category': {
          'id': 1,
          'name': 'Minuman',
          'description': 'kopi & teh',
          'created_at': '2026-09-19T14:17:53.123456+07:00',
          'updated_at': '2026-09-19T14:17:53.123456+07:00',
        },
        'created_at': '2026-09-19T14:17:54.5+07:00',
        'updated_at': '2026-09-19T14:17:54.5+07:00',
      }).toEntity();

      expect(p.categoryId, 1);
      expect(p.category?.name, 'Minuman');
    });

    test('without a category: category_id null and category omitted', () {
      final p = ProductModel.fromJson({
        'id': 9,
        'sku': 'ROTI-1',
        'name': 'Roti',
        'description': '',
        'price': 15000,
        'category_id': null,
        'created_at': '2026-09-19T14:17:54Z',
        'updated_at': '2026-09-19T14:17:54Z',
      }).toEntity();

      expect(p.categoryId, isNull);
      expect(p.category, isNull);
    });

    test('create request sends category_id (null = none); patch omits unset fields', () {
      expect(
        const CreateProductRequest(sku: 'A', name: 'B', description: '', price: 1).toJson(),
        containsPair('category_id', null),
      );
      expect(const UpdateProductRequest(categoryId: 0).toJson(), {'category_id': 0});
      expect(const UpdateProductRequest(price: 5).toJson(), {'price': 5});
    });
  });

  test('category', () {
    final c = CategoryModel.fromJson({
      'id': 1,
      'name': 'Minuman',
      'description': 'kopi & teh',
      'created_at': '2026-09-19T14:17:53Z',
      'updated_at': '2026-09-19T14:17:53Z',
    }).toEntity();

    expect(c.name, 'Minuman');
    expect(const UpdateCategoryRequest(description: '').toJson(), {'description': ''});
  });

  group('inventory', () {
    test('product without an inventory row (zero-time timestamps)', () {
      final inv = InventoryModel.fromJson({
        'product_id': 8,
        'quantity': 0,
        'low_stock_threshold': 10,
        'is_low_stock': true,
        'created_at': '0001-01-01T00:00:00Z',
        'updated_at': '0001-01-01T00:00:00Z',
      }).toEntity();

      expect(inv, const Inventory(productId: 8, quantity: 0, lowStockThreshold: 10, isLowStock: true));
    });

    test('POST movement response: {"movement": ..., "inventory": ...}', () {
      final r = MovementResultModel.fromJson({
        'movement': {
          'id': 3,
          'product_id': 8,
          'type': 'OUT',
          'quantity': 5,
          'quantity_before': 25,
          'quantity_after': 20,
          'reason': '',
          'created_at': '2026-09-19T14:17:55.1+07:00',
        },
        'inventory': {
          'product_id': 8,
          'quantity': 20,
          'low_stock_threshold': 10,
          'is_low_stock': false,
          'created_at': '2026-09-19T14:17:54+07:00',
          'updated_at': '2026-09-19T14:17:55+07:00',
        },
      }).toEntity();

      expect(r.movement.type, MovementType.stockOut);
      expect((r.movement.quantityBefore, r.movement.quantityAfter), (25, 20));
      expect(r.inventory.quantity, 20);
    });

    test('movement types map both ways', () {
      for (final (code, type) in [
        ('IN', MovementType.stockIn),
        ('OUT', MovementType.stockOut),
        ('ADJUSTMENT', MovementType.adjustment),
      ]) {
        expect(MovementTypeCodec.decode(code), type);
        expect(MovementTypeCodec.encode(type), code);
      }
    });

    test('an unknown movement type is a FormatException (→ ServerFailure in the repository)', () {
      expect(() => MovementTypeCodec.decode('TRANSFER'), throwsFormatException);
    });

    test('create request body', () {
      final body = CreateMovementRequest.fromEntity(
        const MovementInput(type: MovementType.adjustment, quantity: 7, reason: 'stock opname'),
      ).toJson();

      expect(body, {'type': 'ADJUSTMENT', 'quantity': 7, 'reason': 'stock opname'});
    });

    test('low-stock item (no is_low_stock key)', () {
      final item = LowStockItemModel.fromJson({
        'product_id': 9,
        'sku': 'ROTI-1',
        'name': 'Roti',
        'quantity': 0,
        'low_stock_threshold': 10,
      }).toEntity();

      expect(item.quantity, 0);
      expect(item.lowStockThreshold, 10);
    });
  });

  // --- customers & sales orders (captured from the live API) ----------------

  const customerJson = {
    'id': 9,
    'name': 'Budi Santoso',
    'email': 'budi@example.com',
    'phone': '+62 811',
    'address': 'Jl. A',
    'created_at': '2026-09-20T01:42:44.7882753+07:00',
    'updated_at': '2026-09-20T01:42:44.7882753+07:00',
  };

  group('customer', () {
    test('full customer', () {
      final c = CustomerModel.fromJson(customerJson).toEntity();

      expect(c.id, 9);
      expect(c.email, 'budi@example.com');
      expect(c.phone, '+62 811');
    });

    test('customer without email: email is null, phone/address empty strings', () {
      final c = CustomerModel.fromJson({
        'id': 10,
        'name': 'Siti',
        'email': null,
        'phone': '',
        'address': '',
        'created_at': '2026-09-20T01:42:45.0018655+07:00',
        'updated_at': '2026-09-20T01:42:45.0018655+07:00',
      }).toEntity();

      expect(c.email, isNull);
      expect(c.phone, '');
    });

    test('patch omits unset fields; empty email is sent to remove it', () {
      expect(const UpdateCustomerRequest(address: 'Bandung').toJson(), {'address': 'Bandung'});
      expect(const UpdateCustomerRequest(email: '').toJson(), {'email': ''});
    });
  });

  // POST /sales-orders and PATCH /sales-orders/:id/status return this shape
  // (with customer and items).
  final orderJson = {
    'id': 59,
    'order_number': 'SO-20260920-0059',
    'customer_id': 9,
    'status': 'CONFIRMED',
    'total_amount': 25000,
    'notes': 'n',
    'confirmed_at': '2026-09-20T01:42:45.611442+07:00',
    'shipped_at': null,
    'cancelled_at': null,
    'created_at': '2026-09-20T01:42:45.348362+07:00',
    'updated_at': '2026-09-20T01:42:45.614999+07:00',
    'customer': customerJson,
    'items': [
      {
        'id': 63,
        'sales_order_id': 59,
        'product_id': 25,
        'product_sku': 'SHP-1',
        'product_name': 'Shape Prod',
        'quantity': 2,
        'unit_price': 12500,
        'subtotal': 25000,
      },
    ],
  };

  group('sales order', () {
    test('detail: nested customer and items, status timestamps', () {
      final o = SalesOrderModel.fromJson(orderJson).toEntity();

      expect(o.orderNumber, 'SO-20260920-0059');
      expect(o.status, OrderStatus.confirmed);
      expect(o.totalAmount, 25000);
      expect(o.confirmedAt, isNotNull);
      expect(o.shippedAt, isNull);
      expect(o.customer?.name, 'Budi Santoso');
      expect(o.items.single.productName, 'Shape Prod');
      expect(o.items.single.unitPrice, 12500);
      expect(o.items.single.subtotal, 25000);
    });

    test('list item: customer present, items key omitted', () {
      final json = Map<String, dynamic>.of(orderJson)
        ..remove('items')
        ..['status'] = 'PENDING'
        ..['confirmed_at'] = null;

      final o = SalesOrderModel.fromJson(json).toEntity();

      expect(o.items, isEmpty);
      expect(o.status, OrderStatus.pending);
      expect(o.customer?.id, 9);
    });

    test('all status strings map both ways; unknown is a FormatException', () {
      for (final (code, status) in [
        ('PENDING', OrderStatus.pending),
        ('CONFIRMED', OrderStatus.confirmed),
        ('SHIPPED', OrderStatus.shipped),
        ('CANCELLED', OrderStatus.cancelled),
      ]) {
        expect(OrderStatusCodec.decode(code), status);
        expect(OrderStatusCodec.encode(status), code);
      }
      expect(() => OrderStatusCodec.decode('LOST'), throwsFormatException);
    });

    test('create and status request bodies', () {
      final body = const CreateSalesOrderRequest(
        customerId: 9,
        items: [CreateOrderItemRequest(productId: 25, quantity: 2)],
        notes: 'kirim sore',
      ).toJson();

      expect(body, {
        'customer_id': 9,
        'items': [
          {'product_id': 25, 'quantity': 2},
        ],
        'notes': 'kirim sore',
      });
      expect(const UpdateOrderStatusRequest(status: 'CONFIRMED').toJson(), {'status': 'CONFIRMED'});
    });
  });

  group('errors', () {
    Failure map(int status, Map<String, dynamic> body) {
      final req = RequestOptions(path: '/api/v1/sales-orders');
      return mapDioException(
        DioException.badResponse(
          statusCode: status,
          requestOptions: req,
          response: Response(requestOptions: req, statusCode: status, data: body),
        ),
      );
    }

    test('confirm with short stock: 422 with per-item field keys', () {
      final f = map(422, {
        'error': {
          'code': 'validation_failed',
          'message': 'request validation failed',
          'details': [
            {
              'field': 'items[0].quantity',
              'message': 'insufficient stock for product 25 (SHP-1): 3 available, 4 requested',
            },
          ],
        },
      });

      expect(f, isA<ValidationFailure>());
      expect((f as ValidationFailure).messages, {
        'items[0].quantity': 'insufficient stock for product 25 (SHP-1): 3 available, 4 requested',
      });
    });

    test('invalid transition: 422 on status', () {
      final f = map(422, {
        'error': {
          'code': 'validation_failed',
          'message': 'request validation failed',
          'details': [
            {'field': 'status', 'message': "can't change status from PENDING to SHIPPED; allowed: CONFIRMED, CANCELLED"},
          ],
        },
      }) as ValidationFailure;

      expect(f.messages.keys, ['status']);
    });

    test('customer delete with active orders: 409 with the order count in the message', () {
      final f = map(409, {
        'error': {'code': 'conflict', 'message': 'conflict: customer 9 still has 2 sales order(s) that are not cancelled'},
      });

      expect(f, isA<ServerFailure>().having((f) => f.isConflict, 'isConflict', true));
      expect(f.message, contains('still has 2 sales order(s)'));
    });
  });
}
