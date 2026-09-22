import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Answers every request with 200 and records the headers it was sent.
class _Recorder extends Interceptor {
  final headers = <Map<String, dynamic>>[];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    headers.add(Map.of(options.headers));
    handler.resolve(Response(requestOptions: options, statusCode: 200, data: const {}));
  }
}

void main() {
  test('every request carries the language the app is running in', () async {
    var language = AppLanguage.english.code;
    final dio = buildDio(baseUrl: 'http://localhost:8080', language: () => language);
    final recorder = _Recorder();
    dio.interceptors.add(recorder);

    await dio.get<dynamic>('/api/v1/products');
    // Read per request, so a language change applies to the next call without
    // rebuilding the client.
    language = AppLanguage.indonesian.code;
    await dio.post<dynamic>('/api/v1/products', data: const {});

    expect(recorder.headers.map((h) => h['Accept-Language']), ['en', 'id']);
  });

  test('the dio provider follows the language controller', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      retry: (_, _) => null,
    );

    final dio = container.read(dioProvider);
    final recorder = _Recorder();
    dio.interceptors.add(recorder);

    await dio.get<dynamic>('/api/v1/categories');
    await container.read(languageControllerProvider.notifier).select(AppLanguage.indonesian);
    await dio.get<dynamic>('/api/v1/categories');

    expect(recorder.headers.map((h) => h['Accept-Language']), ['en', 'id']);
  });
}
