import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/secure_token_store.dart';
import '../auth/session_events.dart';
import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../constants/api_constants.dart';
import '../error/failure_mapper.dart';
import '../locale/locale_provider.dart';
import 'auth_interceptor.dart';

part 'dio_client.g.dart';

/// Single shared Dio instance for the whole app.
///
/// It watches the language: the backend localizes its messages from
/// `Accept-Language`, so switching language in Settings must change what the
/// server writes too, not only the app's own labels.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = buildDio(
    baseUrl: ApiConstants.baseUrl,
    language: () => ref.read(languageControllerProvider).code,
    tokens: ref.watch(tokenStoreProvider),
    // Whichever request notices that the server ended the session, the app
    // hears about it once, through one provider (and goes to /login).
    onSessionEnded: () => ref.read(sessionEndedProvider.notifier).signal(),
  );
  ref.onDispose(dio.close);
  return dio;
}

/// The session's tokens. `main()` overrides this with a [SecureTokenStore]
/// loaded before the first frame; the in-memory default is what tests get.
@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => MemoryTokenStore();

/// [language] is read per request (not captured once), so a language change
/// applies to the very next call without rebuilding the client.
///
/// With [tokens], requests carry the access token and an expired one is
/// refreshed through a single [TokenRefresher] shared by every request of
/// this client (see [AuthInterceptor]). [onSessionEnded] fires once when the
/// server ends the session (refresh rejected, account deactivated).
Dio buildDio({
  required String baseUrl,
  String Function()? language,
  TokenStore? tokens,
  void Function()? onSessionEnded,
  @visibleForTesting HttpClientAdapter? adapter,
}) {
  final dio = _baseDio(baseUrl, language, adapter);
  if (tokens != null) {
    // A separate client for /auth/refresh, without AuthInterceptor: a
    // refresh must never trigger another refresh.
    final refreshDio = _baseDio(baseUrl, language, adapter);
    final refresher = TokenRefresher(
      store: tokens,
      refresh: httpRefreshCall(refreshDio),
      onSessionEnded: onSessionEnded,
    );
    dio.interceptors.add(AuthInterceptor(store: tokens, refresher: refresher, retry: dio.fetch));
  }
  dio.interceptors.add(ApiErrorInterceptor());
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, logPrint: (o) => debugPrint('$o')),
    );
  }
  return dio;
}

Dio _baseDio(String baseUrl, String Function()? language, HttpClientAdapter? adapter) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
  if (adapter != null) {
    dio.httpClientAdapter = adapter;
  }
  if (language != null) {
    dio.interceptors.add(AcceptLanguageInterceptor(language));
  }
  return dio;
}

/// Tells the backend which language to answer in. Without the header the API
/// falls back to Indonesian, so the app always sends it explicitly.
class AcceptLanguageInterceptor extends Interceptor {
  const AcceptLanguageInterceptor(this._language);

  final String Function() _language;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[Headers.acceptHeader] ??= Headers.jsonContentType;
    options.headers['Accept-Language'] = _language();
    handler.next(options);
  }
}

/// Converts every Dio error into a [Failure] and attaches it as
/// `DioException.error`, so repositories only need to unwrap it.
class ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: mapDioException(err)));
  }
}
