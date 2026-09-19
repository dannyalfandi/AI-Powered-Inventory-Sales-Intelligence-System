import 'package:dio/dio.dart';

import 'failure.dart';

/// Maps a [DioException] to a [Failure], parsing the Go backend error envelope:
///
/// ```json
/// {"error": {"code": "validation_failed", "message": "...",
///            "details": [{"field": "sku", "message": "is required"}]}}
/// ```
Failure mapDioException(DioException e) {
  final attached = e.error;
  if (attached is Failure) return attached;

  return switch (e.type) {
    DioExceptionType.badResponse => _fromResponse(e.response),
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>
      const NetworkFailure('Server tidak merespons. Coba lagi.'),
    DioExceptionType.cancel => const NetworkFailure('Permintaan dibatalkan.'),
    // connectionError, badCertificate, unknown, and any type added by future Dio versions.
    _ => const NetworkFailure(
        'Tidak dapat terhubung ke server. Periksa koneksi atau API_BASE_URL.',
      ),
  };
}

Failure _fromResponse(Response<dynamic>? response) {
  final status = response?.statusCode;
  final body = response?.data;
  final error = body is Map ? body['error'] : null;

  if (error is! Map) {
    return ServerFailure('Server error (HTTP ${status ?? '-'})', statusCode: status);
  }

  final code = error['code'] as String?;
  final message = (error['message'] as String?) ?? 'Server error';

  if (status == 422) {
    final messages = <String, String>{};
    final details = error['details'];
    if (details is List) {
      for (final d in details) {
        if (d is Map && d['field'] is String) {
          final field = d['field'] as String;
          final msg = '${d['message'] ?? 'tidak valid'}';
          // Keep every message if the backend reports a field twice.
          messages.update(field, (prev) => '$prev; $msg', ifAbsent: () => msg);
        }
      }
    }
    return ValidationFailure(message, messages: messages);
  }

  return ServerFailure(message, statusCode: status, code: code);
}
