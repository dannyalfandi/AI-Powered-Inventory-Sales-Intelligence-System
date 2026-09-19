import '../../../../core/error/failure.dart';
import '../repositories/category_repository.dart';

class DeleteCategory {
  const DeleteCategory(this._repository);

  final CategoryRepository _repository;

  /// Throws `ServerFailure` (409) while products still use the category.
  Future<void> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('ID kategori tidak valid', messages: {'id': 'harus bilangan positif'});
    }
    return _repository.deleteCategory(id);
  }
}
