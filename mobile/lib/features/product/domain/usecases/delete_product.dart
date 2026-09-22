import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';

class DeleteProduct {
  const DeleteProduct(this._repository);

  final ProductRepository _repository;

  Future<void> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('id must be a positive integer', issue: FailureIssue.localValidation);
    }
    return _repository.deleteProduct(id);
  }
}
