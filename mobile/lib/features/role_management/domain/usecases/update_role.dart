import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/role.dart';
import '../repositories/role_repository.dart';

class UpdateRole {
  const UpdateRole(this._repository);

  final RoleRepository _repository;

  Future<Role> call(int id, RolePatch patch) async {
    final name = patch.name?.trim();
    if (name != null) _check(RoleRules.validateName(name));
    return _repository.updateRole(id, RolePatch(name: name, description: patch.description?.trim()));
  }
}

void _check(FieldIssue? nameIssue) {
  if (nameIssue != null) {
    throw ValidationFailure('invalid role', issues: {'name': nameIssue});
  }
}
