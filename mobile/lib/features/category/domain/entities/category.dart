import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// Product category (backend model.Category).
@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;
}

/// Data needed to create a category (POST /api/v1/categories).
@freezed
abstract class CategoryInput with _$CategoryInput {
  const CategoryInput._();

  const factory CategoryInput({
    required String name,
    @Default('') String description,
  }) = _CategoryInput;

  CategoryInput trimmed() => CategoryInput(name: name.trim(), description: description.trim());
}

/// Partial update (PATCH /api/v1/categories/:id): null fields stay unchanged.
@freezed
abstract class CategoryPatch with _$CategoryPatch {
  const CategoryPatch._();

  const factory CategoryPatch({
    String? name,
    String? description,
  }) = _CategoryPatch;

  bool get isEmpty => name == null && description == null;

  CategoryPatch trimmed() => CategoryPatch(name: name?.trim(), description: description?.trim());
}

/// Category rules, mirroring backend `validateCategory` in
/// backend/internal/service/category_service.go. Name uniqueness can only be
/// checked by the backend (HTTP 409).
abstract final class CategoryRules {
  static const nameMaxLength = 100;

  static String? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Nama kategori wajib diisi';
    if (v.length > nameMaxLength) return 'Nama kategori maksimal $nameMaxLength karakter';
    return null;
  }
}
