import '../repositories/role_repository.dart';

class CountRoleUsers {
  const CountRoleUsers(this._repository);

  final RoleRepository _repository;

  Future<int> call(int roleId) => _repository.countUsers(roleId);
}
