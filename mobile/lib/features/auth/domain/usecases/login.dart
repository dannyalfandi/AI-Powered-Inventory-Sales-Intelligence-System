import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  /// The email is trimmed and lowercased, as the backend stores it.
  Future<AuthUser> call({required String email, required String password}) =>
      _repository.login(email: email.trim().toLowerCase(), password: password);
}
