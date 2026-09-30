import '../entities/role.dart';
import '../repositories/role_repository.dart';

class GetRole {
  const GetRole(this._repository);

  final RoleRepository _repository;

  Future<Role> call(int id) => _repository.getRole(id);
}
