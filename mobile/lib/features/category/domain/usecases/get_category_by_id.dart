import '../../../../core/error/failure.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoryById {
  const GetCategoryById(this._repository);

  final CategoryRepository _repository;

  Future<Category> call(int id) async {
    if (id <= 0) {
      throw const ValidationFailure('ID kategori tidak valid', messages: {'id': 'harus bilangan positif'});
    }
    return _repository.getCategoryById(id);
  }
}
