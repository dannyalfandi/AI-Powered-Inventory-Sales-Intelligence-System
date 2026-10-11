import '../entities/auth_user.dart';

/// Authentication against the Go backend. Every method throws `Failure`.
abstract interface class AuthRepository {
  /// Logs in, stores the token pair, and returns the user with their
  /// permissions. Throws `ServerFailure` 401 (`invalid_credentials`) for a
  /// wrong email or password; nothing is stored then.
  Future<AuthUser> login({required String email, required String password});

  /// The user behind the stored tokens (GET /auth/me). Throws when there is
  /// no valid session.
  Future<AuthUser> currentUser();

  /// Whether tokens are stored (says nothing about whether they still work).
  bool get hasSession;

  /// Revokes the refresh token on the server (best effort) and forgets the
  /// tokens locally. Never throws: logging out must work offline too.
  Future<void> logout();
}
