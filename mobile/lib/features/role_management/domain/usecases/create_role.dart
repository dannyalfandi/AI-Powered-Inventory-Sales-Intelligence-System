import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/role.dart';
import '../repositories/role_repository.dart';

class CreateRole {
  const CreateRole(this._repository);

  final RoleRepository _repository;

  /// Validates locally first, so an obviously bad form costs no request.
  Future<Role> call(RoleInput input) async {
    final data = input.trimmed();
    _check(RoleRules.validateName(data.name));
    return _repository.createRole(data);
  }
}

void _check(FieldIssue? nameIssue) {
  if (nameIssue != null) {
    throw ValidationFailure('invalid role', issues: {'name': nameIssue});
  }
}
