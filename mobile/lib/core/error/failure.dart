/// Failures are the only error type the presentation layer sees.
/// Repositories convert every exception (Dio, parsing, ...) into one of these.
sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The backend answered with an error (4xx/5xx other than 422), or the
/// response could not be understood.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode, this.code});

  /// HTTP status, e.g. 404, 409, 500. Null when the response was malformed.
  final int? statusCode;

  /// Backend error code from `{"error": {"code": ...}}`, e.g. `not_found`,
  /// `conflict`, `invalid_id`, `internal_error`.
  final String? code;

  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
}

/// The request never got a response: no connection, timeout, cancelled.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Invalid input — either rejected locally by a usecase or by the backend
/// (HTTP 422 `validation_failed`).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.messages = const {}});

  /// Field name (backend JSON key, e.g. `sku`, `price`) → error message.
  final Map<String, String> messages;
}
