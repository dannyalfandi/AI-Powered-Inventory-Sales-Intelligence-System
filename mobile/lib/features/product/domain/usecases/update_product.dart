import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../entities/product_input.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  const UpdateProduct(this._repository);

  final ProductRepository _repository;

  /// Validates only the fields present in [patch]; null fields are untouched.
  Future<Product> call(int id, ProductPatch patch) async {
    final data = patch.trimmed();
    final messages = <String, String>{
      if (id <= 0) 'id': 'harus bilangan positif',
      if (data.sku case final sku?) 'sku': ?ProductRules.validateSku(sku),
      if (data.name case final name?) 'name': ?ProductRules.validateName(name),
      if (data.price case final price?) 'price': ?ProductRules.validatePrice(price),
      // 0 (ProductPatch.noCategory) is valid here: it removes the category.
      if (data.categoryId case final c? when c < 0) 'category_id': 'Kategori tidak valid',
    };
    if (messages.isNotEmpty) {
      throw ValidationFailure('Input produk tidak valid', messages: messages);
    }
    return _repository.updateProduct(id, data);
  }
}
