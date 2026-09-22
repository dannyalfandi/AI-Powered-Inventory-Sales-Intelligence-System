import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../error/failure_mapper.dart';
import '../locale/locale_provider.dart';

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
  );
  ref.onDispose(dio.close);
  return dio;
}

/// [language] is read per request (not captured once), so a language change
/// applies to the very next call without rebuilding the client.
Dio buildDio({required String baseUrl, String Function()? language}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
  if (language != null) {
    dio.interceptors.add(AcceptLanguageInterceptor(language));
  }
  dio.interceptors.add(ApiErrorInterceptor());
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, logPrint: (o) => debugPrint('$o')),
    );
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
