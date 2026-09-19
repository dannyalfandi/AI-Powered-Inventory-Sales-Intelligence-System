import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_input.freezed.dart';

/// Data needed to create a product (POST /api/v1/products).
@freezed
abstract class ProductInput with _$ProductInput {
  const ProductInput._();

  const factory ProductInput({
    required String sku,
    required String name,
    @Default('') String description,
    required int price,

    /// Null: no category.
    int? categoryId,
  }) = _ProductInput;

  ProductInput trimmed() => copyWith(
        sku: sku.trim(),
        name: name.trim(),
        description: description.trim(),
      );
}

/// Partial update (PATCH /api/v1/products/:id): null fields stay unchanged.
@freezed
abstract class ProductPatch with _$ProductPatch {
  const ProductPatch._();

  const factory ProductPatch({
    String? sku,
    String? name,
    String? description,
    int? price,

    /// Null keeps the current category; [noCategory] removes it.
    int? categoryId,
  }) = _ProductPatch;

  /// `category_id: 0` tells the backend to remove the product's category.
  static const noCategory = 0;

  bool get isEmpty =>
      sku == null && name == null && description == null && price == null && categoryId == null;

  ProductPatch trimmed() => copyWith(
        sku: sku?.trim(),
        name: name?.trim(),
        description: description?.trim(),
      );
}

/// Product rules, mirroring backend `validateProduct` in
/// backend/internal/service/product_service.go. Used by usecases and the form.
/// SKU uniqueness can only be checked by the backend (HTTP 409).
abstract final class ProductRules {
  static const skuMaxLength = 64;
  static const nameMaxLength = 255;

  static String? validateSku(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'SKU wajib diisi';
    if (v.length > skuMaxLength) return 'SKU maksimal $skuMaxLength karakter';
    return null;
  }

  static String? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Nama wajib diisi';
    if (v.length > nameMaxLength) return 'Nama maksimal $nameMaxLength karakter';
    return null;
  }

  static String? validatePrice(int? value) {
    if (value == null) return 'Harga wajib diisi';
    if (value < 0) return 'Harga tidak boleh negatif';
    return null;
  }

  /// Null (no category) is valid; whether the id exists is checked by the
  /// backend (422 on `category_id`).
  static String? validateCategoryId(int? value) {
    if (value != null && value <= 0) return 'Kategori tidak valid';
    return null;
  }
}
