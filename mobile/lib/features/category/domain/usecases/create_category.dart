import '../../../../core/error/failure.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategory {
  const CreateCategory(this._repository);

  final CategoryRepository _repository;

  /// Trims and validates locally; throws [ValidationFailure] without a network
  /// round trip when input is invalid.
  Future<Category> call(CategoryInput input) async {
    final data = input.trimmed();
    final messages = <String, String>{
      'name': ?CategoryRules.validateName(data.name),
    };
    if (messages.isNotEmpty) {
      throw ValidationFailure('Input kategori tidak valid', messages: messages);
    }
    return _repository.createCategory(data);
  }
}
