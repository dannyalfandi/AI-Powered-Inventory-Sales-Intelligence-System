import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductById {
  const GetProductById(this._repository);

  final ProductRepository _repository;

  Future<Product> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('ID produk tidak valid', messages: {'id': 'harus bilangan positif'});
    }
    return _repository.getProductById(id);
  }
}
