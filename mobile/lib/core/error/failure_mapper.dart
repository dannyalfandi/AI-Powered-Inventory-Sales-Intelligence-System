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
      const NetworkFailure('request timed out', issue: FailureIssue.timeout),
    DioExceptionType.cancel => const NetworkFailure('request cancelled', issue: FailureIssue.cancelled),
    // connectionError, badCertificate, unknown, and any type added by future Dio versions.
    _ => const NetworkFailure('cannot reach the server', issue: FailureIssue.unreachable),
  };
}

Failure _fromResponse(Response<dynamic>? response) {
  final status = response?.statusCode;
  final body = response?.data;
  final error = body is Map ? body['error'] : null;

  if (error is! Map) {
    // No parsable envelope: there is no backend sentence to show, so the UI
    // renders FailureIssue.malformedResponse in the user's language.
    return ServerFailure(
      'server error (HTTP ${status ?? '-'})',
      statusCode: status,
      issue: FailureIssue.malformedResponse,
    );
  }

  final code = error['code'] as String?;
  // The backend writes this in the language the request asked for.
  final message = (error['message'] as String?) ?? '';

  if (status == 422) {
    final messages = <String, String>{};
    final details = error['details'];
    if (details is List) {
      for (final d in details) {
        // Without a message there is nothing to show next to the field; the
        // screen then falls back to the 422's own sentence.
        if (d is Map && d['field'] is String && d['message'] is String) {
          final field = d['field'] as String;
          final msg = d['message'] as String;
          // Keep every message if the backend reports a field twice.
          messages.update(field, (prev) => '$prev; $msg', ifAbsent: () => msg);
        }
      }
    }
    return ValidationFailure(message, messages: messages);
  }

  return ServerFailure(message, statusCode: status, code: code);
}
