import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/features/category/data/models/category_model.dart';
import 'package:inventory_intel/features/inventory/data/models/inventory_model.dart';
import 'package:inventory_intel/features/inventory/domain/entities/inventory.dart';
import 'package:inventory_intel/features/product/data/models/product_model.dart';

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
}
