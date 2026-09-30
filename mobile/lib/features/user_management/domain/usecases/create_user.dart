import '../../../../core/error/failure.dart';
import '../../../../core/validation/field_issue.dart';
import '../entities/managed_user.dart';
import '../repositories/user_repository.dart';

class CreateUser {
  const CreateUser(this._repository);

  final UserRepository _repository;

  /// Validates every field locally first; an invalid form costs no request.
  Future<ManagedUser> call(UserInput input) async {
    final data = input.normalized();
    final issues = <String, FieldIssue>{
      'email': ?UserRules.validateEmail(data.email),
      'name': ?UserRules.validateName(data.name),
      'password': ?UserRules.validatePassword(data.password, required: true),
      'role_id': ?UserRules.validateRole(data.roleId),
    };
    if (issues.isNotEmpty) throw ValidationFailure('invalid user', issues: issues);
    return _repository.createUser(data);
  }
}
