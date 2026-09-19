import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repository);

  final ProductRepository _repository;

  /// Backend clamps page size to 1..100; mirror that so callers can't ask for more.
  static const maxPageSize = 100;

  Future<ProductPage> call({
    int page = 1,
    int pageSize = 20,
    String search = '',
  }) async {
    return _repository.getProducts(
      page: page < 1 ? 1 : page,
      pageSize: pageSize.clamp(1, maxPageSize),
      search: search.trim(),
    );
  }
}
