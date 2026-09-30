import '../repositories/role_repository.dart';

class DeleteRole {
  const DeleteRole(this._repository);

  final RoleRepository _repository;

  Future<void> call(int id) => _repository.deleteRole(id);
}
