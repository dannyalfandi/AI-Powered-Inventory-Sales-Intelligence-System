import '../entities/managed_user.dart';
import '../repositories/user_repository.dart';

class GetUser {
  const GetUser(this._repository);

  final UserRepository _repository;

  Future<ManagedUser> call(int id) => _repository.getUser(id);
}
