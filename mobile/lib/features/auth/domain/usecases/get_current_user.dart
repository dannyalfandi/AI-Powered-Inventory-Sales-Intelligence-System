import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  /// Null when no tokens are stored — no request is made then.
  Future<AuthUser?> call() async => _repository.hasSession ? _repository.currentUser() : null;
}
