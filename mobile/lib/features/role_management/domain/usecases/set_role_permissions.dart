import '../entities/role.dart';
import '../repositories/role_repository.dart';

class SetRolePermissions {
  const SetRolePermissions(this._repository);

  final RoleRepository _repository;

  /// Sends the full desired list, de-duplicated, in the order given.
  Future<Role> call(int id, Iterable<String> keys) => _repository.setPermissions(id, keys.toSet().toList());
}
