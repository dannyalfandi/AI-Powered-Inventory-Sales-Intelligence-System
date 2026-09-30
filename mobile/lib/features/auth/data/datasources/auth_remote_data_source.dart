import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../models/auth_models.dart';

/// Talks to `/api/v1/auth`. Throws [DioException] or parsing errors; the
/// repository converts both into `Failure`.
abstract interface class AuthRemoteDataSource {
  Future<TokenPairModel> login(LoginRequest body);

  Future<MeModel> me();

  Future<void> logout(RefreshTokenRequest body);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Login and logout are public endpoints. Marking them skipAuth keeps a
  /// stale access token off them, and keeps their 401s (wrong password,
  /// forged token) from being mistaken for an expired session.
  static final _public = Options(extra: {AuthInterceptor.skipAuth: true});

  @override
  Future<TokenPairModel> login(LoginRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(ApiConstants.authLoginPath, data: body.toJson(), options: _public);
    return TokenPairModel.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<MeModel> me() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiConstants.authMePath);
    return MeModel.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> logout(RefreshTokenRequest body) async {
    await _dio.post<void>(ApiConstants.authLogoutPath, data: body.toJson(), options: _public); // 204
  }
}
