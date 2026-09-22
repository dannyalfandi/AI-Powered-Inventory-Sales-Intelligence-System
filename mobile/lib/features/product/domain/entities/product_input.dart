import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/validation/field_issue.dart';

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

  static FieldIssue? validateSku(String value) {
    final v = value.trim();
    if (v.isEmpty) return const FieldIssue(FieldIssueKind.skuRequired);
    if (v.length > skuMaxLength) return const FieldIssue(FieldIssueKind.skuTooLong, max: skuMaxLength);
    return null;
  }

  static FieldIssue? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return const FieldIssue(FieldIssueKind.nameRequired);
    if (v.length > nameMaxLength) return const FieldIssue(FieldIssueKind.nameTooLong, max: nameMaxLength);
    return null;
  }

  static FieldIssue? validatePrice(int? value) {
    if (value == null) return const FieldIssue(FieldIssueKind.priceRequired);
    if (value < 0) return const FieldIssue(FieldIssueKind.priceNegative);
    return null;
  }

  /// Null (no category) is valid; whether the id exists is checked by the
  /// backend (422 on `category_id`).
  static FieldIssue? validateCategoryId(int? value) {
    if (value != null && value <= 0) return const FieldIssue(FieldIssueKind.categoryInvalid);
    return null;
  }
}
