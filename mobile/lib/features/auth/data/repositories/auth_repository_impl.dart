import '../../../../core/auth/token_store.dart';
import '../../../../core/error/guard.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._tokens);

  final AuthRemoteDataSource _remote;
  final TokenStore _tokens;

  @override
  bool get hasSession => _tokens.current != null;

  @override
  Future<AuthUser> login({required String email, required String password}) => guardApiCall(() async {
    final pair = await _remote.login(LoginRequest(email: email, password: password));
    await _tokens.save(AuthTokens(accessToken: pair.accessToken, refreshToken: pair.refreshToken));
    try {
      // The login response carries the role but not the permissions.
      return (await _remote.me()).toEntity();
    } catch (_) {
      // Half a login (tokens but no user) is worse than none.
      await _tokens.clear();
      rethrow;
    }
  });

  @override
  Future<AuthUser> currentUser() => guardApiCall(() async => (await _remote.me()).toEntity());

  @override
  Future<void> logout() async {
    final tokens = _tokens.current;
    // Forget locally first: whatever the server says, this device is out.
    await _tokens.clear();
    if (tokens == null) return;
    try {
      await _remote.logout(RefreshTokenRequest(refreshToken: tokens.refreshToken));
    } on Object {
      // Offline or already revoked: the refresh token expires on its own
      // (at most JWT_REFRESH_TTL), and it is no longer on this device.
    }
  }
}
