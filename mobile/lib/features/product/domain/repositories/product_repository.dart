import '../entities/product.dart';
import '../entities/product_input.dart';

/// Product data access contract. Implementations throw only `Failure`
/// subclasses (see core/error/failure.dart), never raw transport exceptions.
abstract interface class ProductRepository {
  Future<ProductPage> getProducts({
    required int page,
    required int pageSize,
    String search = '',
  });

  Future<Product> getProductById(int id);

  Future<Product> createProduct(ProductInput input);

  Future<Product> updateProduct(int id, ProductPatch patch);

  Future<void> deleteProduct(int id);
}
