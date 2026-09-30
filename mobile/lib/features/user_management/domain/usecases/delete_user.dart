import '../repositories/user_repository.dart';

class DeleteUser {
  const DeleteUser(this._repository);

  final UserRepository _repository;

  Future<void> call(int id) => _repository.deleteUser(id);
}
