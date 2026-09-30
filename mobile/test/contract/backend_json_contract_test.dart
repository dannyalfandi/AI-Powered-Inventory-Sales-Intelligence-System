import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/error/failure_mapper.dart';
import 'package:inventory_intel/features/auth/data/models/auth_models.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/category/data/models/category_model.dart';
import 'package:inventory_intel/features/customer/data/models/customer_model.dart';
import 'package:inventory_intel/features/dashboard/data/models/dashboard_models.dart';
import 'package:inventory_intel/features/dashboard/data/models/forecast_models.dart';
import 'package:inventory_intel/features/dashboard/domain/entities/forecast.dart';
import 'package:inventory_intel/features/dashboard/domain/entities/dashboard.dart';
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

  // --- analytics / dashboard (captured from the live API) -------------------

  group('analytics summary', () {
    test('totals with the echoed range', () {
      final s = DashboardSummaryModel.fromJson({
        'range': {'from': '2026-09-18', 'to': '2026-09-20'},
        'total_revenue': 928000,
        'total_orders': 13,
        'total_items_sold': 42,
        'average_order_value': 71385,
      }).toEntity();

      expect(s.totalRevenue, 928000);
      expect(s.totalOrders, 13);
      expect(s.totalItemsSold, 42);
      expect(s.averageOrderValue, 71385);
      expect(s.range.from, DateTime(2026, 9, 18));
      expect(s.range.to, DateTime(2026, 9, 20));
    });

    test('an empty range returns zeros, not nulls', () {
      final s = DashboardSummaryModel.fromJson({
        'range': {'from': '2025-01-01', 'to': '2025-01-02'},
        'total_revenue': 0,
        'total_orders': 0,
        'total_items_sold': 0,
        'average_order_value': 0,
      }).toEntity();

      expect(s.totalRevenue, 0);
      expect(s.averageOrderValue, 0);
    });
  });

  group('analytics sales trend', () {
    test('daily points, including periods with no sales', () {
      final t = SalesTrendModel.fromJson({
        'range': {'from': '2026-09-18', 'to': '2026-09-20'},
        'granularity': 'daily',
        'points': [
          {'period_start': '2026-09-18', 'period_end': '2026-09-18', 'revenue': 0, 'orders': 0},
          {'period_start': '2026-09-19', 'period_end': '2026-09-19', 'revenue': 0, 'orders': 0},
          {'period_start': '2026-09-20', 'period_end': '2026-09-20', 'revenue': 928000, 'orders': 13},
        ],
      }).toEntity();

      expect(t.granularity, TrendGranularity.daily);
      expect(t.points, hasLength(3));
      expect(t.points.first.revenue, 0);
      expect(t.points.last.revenue, 928000);
      expect(t.points.last.orders, 13);
      expect(t.points.last.periodStart, DateTime(2026, 9, 20));
    });

    test('weekly points span Monday to Sunday', () {
      final t = SalesTrendModel.fromJson({
        'range': {'from': '2026-08-31', 'to': '2026-09-20'},
        'granularity': 'weekly',
        'points': [
          {'period_start': '2026-09-14', 'period_end': '2026-09-20', 'revenue': 928000, 'orders': 13},
        ],
      }).toEntity();

      expect(t.granularity, TrendGranularity.weekly);
      expect(t.points.single.periodStart, DateTime(2026, 9, 14));
      expect(t.points.single.periodEnd, DateTime(2026, 9, 20));
    });

    test('granularity maps both ways; unknown is a FormatException', () {
      expect(TrendGranularityCodec.encode(TrendGranularity.daily), 'daily');
      expect(TrendGranularityCodec.encode(TrendGranularity.weekly), 'weekly');
      expect(TrendGranularityCodec.decode('weekly'), TrendGranularity.weekly);
      expect(() => TrendGranularityCodec.decode('hourly'), throwsFormatException);
    });
  });

  group('analytics top products', () {
    test('rows carry the order item snapshot', () {
      final rows = TopProductsResponse.fromJson({
        'products': [
          {'product_id': 17, 'sku': 'KOPI-001', 'name': 'Kopi Arabica', 'quantity_sold': 3, 'revenue': 135000},
        ],
        'range': {'from': '2026-09-18', 'to': '2026-09-20'},
      }).toEntities();

      expect(rows.single.productId, 17);
      expect(rows.single.sku, 'KOPI-001');
      expect(rows.single.quantitySold, 3);
      expect(rows.single.revenue, 135000);
    });

    test('an empty range sends "products": null, which reads as an empty list', () {
      final rows = TopProductsResponse.fromJson({
        'products': null,
        'range': {'from': '2025-01-01', 'to': '2025-01-02'},
      }).toEntities();

      expect(rows, isEmpty);
    });
  });

  group('analytics category breakdown', () {
    test('null category_id is the "no category" bucket', () {
      final rows = CategoryBreakdownResponse.fromJson({
        'categories': [
          {'category_id': null, 'category_name': 'Tanpa Kategori', 'quantity_sold': 34, 'revenue': 778000},
          {'category_id': 8, 'category_name': 'Minuman', 'quantity_sold': 2, 'revenue': 90000},
        ],
        'range': {'from': '2026-09-18', 'to': '2026-09-20'},
      }).toEntities();

      expect(rows, hasLength(2));
      expect(rows.first.categoryId, isNull);
      expect(rows.first.categoryName, 'Tanpa Kategori');
      expect(rows.first.revenue, 778000);
      expect(rows.last.categoryId, 8);
    });

    test('an empty range sends "categories": null', () {
      final rows = CategoryBreakdownResponse.fromJson({
        'categories': null,
        'range': {'from': '2025-01-01', 'to': '2025-01-02'},
      }).toEntities();

      expect(rows, isEmpty);
    });
  });

  test('analytics low-stock alert count', () {
    expect(LowStockAlertCountResponse.fromJson({'count': 11}).count, 11);
  });

  // --- forecast / insights (Go API + Python ML service) --------------------

  group('analytics forecast', () {
    test('a product with a forecast: points, method, no error', () {
      final report = ForecastReportModel.fromJson({
        'range': {'from': '2026-08-22', 'to': '2026-09-20'},
        'horizon_days': 2,
        'forecast_available': true,
        'products': [
          {
            'product_id': 17,
            'product_name': 'Kopi Arabica',
            'sku': 'KOPI-001',
            'forecast': [
              {'date': '2026-09-21', 'predicted_quantity': 0.43},
              {'date': '2026-09-22', 'predicted_quantity': 1.5},
            ],
            'method': 'moving_average',
          },
        ],
      }).toEntity();

      expect(report.available, isTrue);
      expect(report.horizonDays, 2);
      final product = report.products.single;
      expect(product.productId, 17);
      expect(product.productName, 'Kopi Arabica');
      expect(product.sku, 'KOPI-001');
      expect(product.method, 'moving_average');
      expect(product.error, isNull);
      expect(product.hasError, isFalse);
      expect(product.forecast.first.date, DateTime(2026, 9, 21));
      expect(product.forecast.first.predictedQuantity, 0.43);
      expect(product.totalPredicted, closeTo(1.93, 0.001));
    });

    test('ML service down: available=false and every product carries an error', () {
      final report = ForecastReportModel.fromJson({
        'range': {'from': '2026-08-22', 'to': '2026-09-20'},
        'horizon_days': 2,
        'forecast_available': false,
        'products': [
          {
            'product_id': 17,
            'product_name': 'Kopi Arabica',
            'sku': 'KOPI-001',
            'error': 'layanan forecasting sedang tidak tersedia',
          },
        ],
      }).toEntity();

      expect(report.available, isFalse);
      final product = report.products.single;
      expect(product.hasError, isTrue);
      expect(product.error, 'layanan forecasting sedang tidak tersedia');
      expect(product.forecast, isEmpty, reason: 'a failed product has no points at all');
      expect(product.method, isNull);
    });

    test('partial failure: available stays true and only one product carries an error', () {
      final report = ForecastReportModel.fromJson({
        'range': {'from': '2026-08-22', 'to': '2026-09-20'},
        'horizon_days': 1,
        'forecast_available': true,
        'products': [
          {
            'product_id': 17,
            'product_name': 'Kopi Arabica',
            'sku': 'KOPI-001',
            'forecast': [
              {'date': '2026-09-21', 'predicted_quantity': 2.0},
            ],
            'method': 'moving_average',
          },
          {
            'product_id': 22,
            'product_name': 'Teh Melati',
            'sku': 'TEH-001',
            'error': 'forecast gagal dihitung untuk produk ini',
          },
        ],
      }).toEntity();

      expect(report.available, isTrue);
      expect(report.products.first.hasError, isFalse);
      expect(report.products.last.hasError, isTrue);
      expect(report.failedCount, 1);
    });

    test('no sales in the range: an empty product list, still available', () {
      final report = ForecastReportModel.fromJson({
        'range': {'from': '2025-01-01', 'to': '2025-01-10'},
        'horizon_days': 7,
        'forecast_available': true,
        'products': <dynamic>[],
      }).toEntity();

      expect(report.available, isTrue);
      expect(report.products, isEmpty);
    });
  });

  group('analytics insights', () {
    test('a product with a trend sentence', () {
      final report = InsightReportModel.fromJson({
        'range': {'from': '2026-08-22', 'to': '2026-09-20'},
        'insights_available': true,
        'products': [
          {
            'product_id': 17,
            'product_name': 'Kopi Arabica',
            'sku': 'KOPI-001',
            'trend': 'increasing',
            'change_percent': 32.0,
            'summary': 'Penjualan naik 32,0% dalam 4 minggu terakhir (1848 unit vs 1400 unit periode sebelumnya).',
          },
        ],
      }).toEntity();

      expect(report.available, isTrue);
      final product = report.products.single;
      expect(product.trend, TrendDirection.increasing);
      expect(product.changePercent, 32.0);
      expect(product.summary, startsWith('Penjualan naik 32,0%'));
      expect(product.error, isNull);
    });

    test('a real 0% change is kept, not treated as missing', () {
      final report = InsightReportModel.fromJson({
        'range': {'from': '2026-08-22', 'to': '2026-09-20'},
        'insights_available': true,
        'products': [
          {
            'product_id': 8,
            'product_name': 'Roti Tawar',
            'sku': 'ROTI-001',
            'trend': 'stable',
            'change_percent': 0,
            'summary': 'Penjualan relatif stabil dalam 4 minggu terakhir (perubahan 0,0%).',
          },
        ],
      }).toEntity();

      expect(report.products.single.trend, TrendDirection.stable);
      expect(report.products.single.changePercent, 0);
    });

    test('ML service down: available=false, per-product error, no trend', () {
      final report = InsightReportModel.fromJson({
        'range': {'from': '2026-08-22', 'to': '2026-09-20'},
        'insights_available': false,
        'products': [
          {
            'product_id': 17,
            'product_name': 'Kopi Arabica',
            'sku': 'KOPI-001',
            'error': 'layanan forecasting sedang tidak tersedia',
          },
        ],
      }).toEntity();

      expect(report.available, isFalse);
      final product = report.products.single;
      expect(product.hasError, isTrue);
      expect(product.trend, isNull);
      expect(product.changePercent, isNull);
      expect(product.summary, isNull);
    });

    test('an empty range returns no products but stays available', () {
      final report = InsightReportModel.fromJson({
        'range': {'from': '2025-01-01', 'to': '2025-01-10'},
        'insights_available': true,
        'products': <dynamic>[],
      }).toEntity();

      expect(report.available, isTrue);
      expect(report.products, isEmpty);
    });

    test('trend direction maps both ways; unknown is a FormatException', () {
      expect(TrendDirectionCodec.decode('increasing'), TrendDirection.increasing);
      expect(TrendDirectionCodec.decode('decreasing'), TrendDirection.decreasing);
      expect(TrendDirectionCodec.decode('stable'), TrendDirection.stable);
      expect(TrendDirectionCodec.encode(TrendDirection.decreasing), 'decreasing');
      expect(() => TrendDirectionCodec.decode('sideways'), throwsFormatException);
    });
  });

  // Captured from the running API (staff@example.com and admin@example.com
  // from `go run ./cmd/seed`); only the JWTs are shortened.
  group('auth', () {
    test('POST /auth/login: token pair + a user without permissions', () {
      final body = {
        'data': {
          'access_token': 'eyJ.access',
          'refresh_token': 'eyJ.refresh',
          'token_type': 'Bearer',
          'expires_in': 900,
          'user': {
            'id': 2,
            'email': 'staff@example.com',
            'name': 'Staf Demo',
            'role': {'id': 2, 'name': 'Staff', 'is_system': false},
          },
        },
      };
      final pair = TokenPairModel.fromJson(body['data']!);

      expect(pair.accessToken, 'eyJ.access');
      expect(pair.refreshToken, 'eyJ.refresh');
      expect(pair.tokenType, 'Bearer');
      expect(pair.expiresIn, 900);
      // The login `user` carries no `permissions` key: the app must call
      // /auth/me after logging in to know what to show.
      expect(((body['data']!)['user']! as Map).containsKey('permissions'), isFalse);
    });

    test('GET /auth/me (Staff): role + the permission keys it grants', () {
      final user = MeModel.fromJson({
        'id': 2,
        'email': 'staff@example.com',
        'name': 'Staf Demo',
        'is_active': true,
        'role': {'id': 2, 'name': 'Staff', 'is_system': false},
        'permissions': [
          'products.view',
          'categories.view',
          'inventory.view',
          'customers.view',
          'sales_orders.view',
          'sales_orders.create',
          'sales_orders.confirm',
          'sales_orders.ship',
          'sales_orders.cancel',
          'analytics.view',
          'analytics.forecast',
          'analytics.insights',
        ],
      }).toEntity();

      expect(user.name, 'Staf Demo');
      expect(user.role, const AuthRole(id: 2, name: 'Staff', isSystem: false));
      expect(user.permissions, hasLength(12));
      expect(user.can('sales_orders.confirm'), isTrue);
      expect(user.can('products.delete'), isFalse);
    });

    test('GET /auth/me (Super Admin): is_system, every catalog key', () {
      final user = MeModel.fromJson({
        'id': 1,
        'email': 'admin@example.com',
        'name': 'Super Admin',
        'is_active': true,
        'role': {'id': 1, 'name': 'Super Admin', 'is_system': true},
        'permissions': ['products.view', 'products.delete', 'users.delete', 'roles.assign_permissions'],
      }).toEntity();

      expect(user.role.isSystem, isTrue);
      expect(user.can('users.delete'), isTrue);
      expect(user.can('a.key.the.app.does.not.know'), isTrue, reason: 'a system role passes every check');
    });

    Failure map(int status, Map<String, dynamic> body) {
      final req = RequestOptions(path: '/api/v1/auth/login');
      return mapDioException(
        DioException.badResponse(
          statusCode: status,
          requestOptions: req,
          response: Response(requestOptions: req, statusCode: status, data: body),
        ),
      );
    }

    test('wrong email or password: 401 invalid_credentials', () {
      final f = map(401, {
        'error': {'code': 'invalid_credentials', 'message': 'invalid email or password'},
      });
      expect(f, isA<ServerFailure>());
      expect((f as ServerFailure).statusCode, 401);
      expect(f.code, 'invalid_credentials');
    });

    test('empty login form: 422 on email and password', () {
      final f = map(422, {
        'error': {
          'code': 'validation_failed',
          'message': 'request validation failed',
          'details': [
            {'field': 'email', 'message': 'is required'},
            {'field': 'password', 'message': 'is required'},
          ],
        },
      });
      expect((f as ValidationFailure).messages, {'email': 'is required', 'password': 'is required'});
    });

    test('POST /auth/logout: 204, no body; request is {"refresh_token"}', () {
      expect(const RefreshTokenRequest(refreshToken: 'r').toJson(), {'refresh_token': 'r'});
      expect(const LoginRequest(email: 'a@b.c', password: 'p').toJson(), {'email': 'a@b.c', 'password': 'p'});
    });
  });
}
