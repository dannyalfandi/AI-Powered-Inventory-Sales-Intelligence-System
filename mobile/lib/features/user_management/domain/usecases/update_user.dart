import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/managed_user.dart';
import '../repositories/user_repository.dart';

class UpdateUser {
  const UpdateUser(this._repository);

  final UserRepository _repository;

  /// Validates only the fields being changed.
  Future<ManagedUser> call(int id, UserPatch patch) async {
    final p = patch.copyWith(email: patch.email?.trim().toLowerCase(), name: patch.name?.trim());
    final issues = <String, FieldIssue>{
      if (p.email case final email?) 'email': ?UserRules.validateEmail(email),
      if (p.name case final name?) 'name': ?UserRules.validateName(name),
      if (p.password case final password?) 'password': ?UserRules.validatePassword(password, required: true),
      if (p.roleId != null) 'role_id': ?UserRules.validateRole(p.roleId),
    };
    if (issues.isNotEmpty) throw ValidationFailure('invalid user', issues: issues);
    return _repository.updateUser(id, p);
  }
}
