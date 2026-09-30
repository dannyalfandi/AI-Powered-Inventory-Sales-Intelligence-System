import 'package:dio/dio.dart';

import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../constants/api_constants.dart';

/// Attaches the access token to every request and recovers from an expired
/// one: on 401 `token_expired` it gets a fresh token from [TokenRefresher]
/// (which refreshes at most once, however many requests failed together) and
/// retries the request **once**.
///
/// Other auth outcomes are left to the caller:
/// - 401 with another code (`unauthorized`: deactivated, deleted, revoked)
///   ends the local session; retrying can't help.
/// - 403 `forbidden` is a permission answer, not a session problem.
///
/// Must be added before ApiErrorInterceptor, so a request that succeeds on
/// retry resolves normally instead of being mapped to a failure first.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this._store, required this._refresher, required this._retry});

  final TokenStore _store;
  final TokenRefresher _refresher;

  /// Sends a request again through the full interceptor chain (`dio.fetch`).
  final Future<Response<dynamic>> Function(RequestOptions options) _retry;

  /// Set to true in `Options.extra` for requests that must not carry the
  /// access token (login).
  static const skipAuth = 'auth.skip';

  static const _sentToken = 'auth.sentToken';
  static const _retried = 'auth.retried';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = options.extra[skipAuth] == true ? null : _store.current?.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      // Remembered per request: on 401 the refresher needs to know *which*
      // token failed, to tell a real expiry from a late one.
      options.extra[_sentToken] = token;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final sent = options.extra[_sentToken] as String?;
    if (err.response?.statusCode != 401 || sent == null) {
      return handler.next(err);
    }

    if (_errorCode(err.response?.data) != 'token_expired') {
      // The server ended the session. Only act if it is *this* session: a
      // 401 for a token that was already replaced says nothing about the
      // current one.
      if (_store.current?.accessToken == sent) {
        await _refresher.sessionRejected();
      }
      return handler.next(err);
    }
    if (options.extra[_retried] == true) {
      // Expired again right after a refresh: never loop.
      return handler.next(err);
    }

    final String? token;
    try {
      token = await _refresher.accessTokenAfterExpiry(sent);
    } on RefreshException catch (e) {
      // The refresh never reached the server: fail this request as the
      // network error it is, and keep the session for the next attempt.
      return handler.next(
        DioException(requestOptions: options, type: DioExceptionType.connectionError, error: e.cause ?? e),
      );
    }
    if (token == null) {
      return handler.next(err); // session over: the original 401 stands
    }

    try {
      final response = await _retry(
        options.copyWith(
          headers: {...options.headers, 'Authorization': 'Bearer $token'},
          extra: {...options.extra, _retried: true},
        ),
      );
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

/// The `code` of the backend's `{"error": {"code": ...}}` envelope.
String? _errorCode(Object? body) {
  if (body is Map && body['error'] is Map) {
    final code = (body['error'] as Map)['code'];
    return code is String ? code : null;
  }
  return null;
}

/// Builds the [RefreshCall] for `POST /api/v1/auth/refresh`.
///
/// [dio] must be a client **without** [AuthInterceptor]: a refresh must never
/// trigger another refresh. Every failure is classified, because what the app
/// may do next depends on whether the server could have rotated the token.
RefreshCall httpRefreshCall(Dio dio) {
  return (refreshToken) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiConstants.authRefreshPath,
        data: {'refresh_token': refreshToken},
      );
      final data = response.data?['data'];
      if (data is Map && data['access_token'] is String && data['refresh_token'] is String) {
        return AuthTokens(
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] as String,
        );
      }
      // 200 but unreadable: the server did rotate, and we can't use the
      // result. Treat it like a lost answer.
      throw const RefreshException(RefreshFailure.outcomeUnknown, 'malformed refresh response');
    } on DioException catch (e) {
      throw RefreshException(_classify(e), e);
    }
  };
}

RefreshFailure _classify(DioException e) {
  return switch (e.type) {
    // Failed before the request was sent: nothing was rotated.
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.badCertificate => RefreshFailure.notDelivered,
    // 4xx: the server looked at the token and refused it.
    DioExceptionType.badResponse when (e.response?.statusCode ?? 500) < 500 => RefreshFailure.rejected,
    // 5xx, send/receive timeouts, anything else: it may have been rotated.
    _ => RefreshFailure.outcomeUnknown,
  };
}
