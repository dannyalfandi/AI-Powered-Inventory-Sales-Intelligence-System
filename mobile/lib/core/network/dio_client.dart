import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../error/failure_mapper.dart';

part 'dio_client.g.dart';

/// Single shared Dio instance for the whole app.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = buildDio(baseUrl: ApiConstants.baseUrl);
  ref.onDispose(dio.close);
  return dio;
}

Dio buildDio({required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.add(ApiErrorInterceptor());
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, logPrint: (o) => debugPrint('$o')),
    );
  }
  return dio;
}

/// Converts every Dio error into a [Failure] and attaches it as
/// `DioException.error`, so repositories only need to unwrap it.
class ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: mapDioException(err)));
  }
}
