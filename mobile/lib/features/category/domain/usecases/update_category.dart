import '../../../../core/error/failure.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategory {
  const UpdateCategory(this._repository);

  final CategoryRepository _repository;

  /// Validates only the fields present in [patch]; null fields are untouched.
  Future<Category> call(int id, CategoryPatch patch) async {
    final data = patch.trimmed();
    final messages = <String, String>{
      if (id <= 0) 'id': 'harus bilangan positif',
      if (data.name case final name?) 'name': ?CategoryRules.validateName(name),
    };
    if (messages.isNotEmpty) {
      throw ValidationFailure('Input kategori tidak valid', messages: messages);
    }
    return _repository.updateCategory(id, data);
  }
}
