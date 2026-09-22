import '../validation/field_issue.dart';

/// Why a request failed, when the *app* is the one that noticed. The UI turns
/// it into a sentence from the ARB files.
///
/// Failures that carry a message from the backend have no issue: that text is
/// already in the user's language, because every request sends
/// `Accept-Language` (see AcceptLanguageInterceptor).
enum FailureIssue { timeout, cancelled, unreachable, malformedResponse, localValidation }

/// Failures are the only error type the presentation layer sees.
/// Repositories convert every exception (Dio, parsing, ...) into one of these.
sealed class Failure implements Exception {
  const Failure(this.message, {this.issue});

  /// Developer-facing text: logs, test names, and the fallback when there is
  /// no [issue] and no backend message.
  final String message;

  /// Set when the app produced this failure itself; null when [message] came
  /// from the backend.
  final FailureIssue? issue;

  @override
  String toString() => '$runtimeType: $message';
}

/// The backend answered with an error (4xx/5xx other than 422), or the
/// response could not be understood.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode, this.code, super.issue});

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
  const NetworkFailure(super.message, {super.issue = FailureIssue.unreachable});
}

/// Invalid input — either rejected locally by a usecase or by the backend
/// (HTTP 422 `validation_failed`).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.messages = const {}, this.issues = const {}, super.issue});

  /// Field name (backend JSON key, e.g. `sku`, `price`) → error message, as
  /// the backend wrote it. Already in the user's language.
  final Map<String, String> messages;

  /// Field name → what the *app* found wrong, before any request was sent.
  /// The UI renders these from the ARB files.
  final Map<String, FieldIssue> issues;

  /// The message to show for [field]: the local issue if there is one,
  /// otherwise whatever the backend said. [render] turns an issue into text
  /// (BuildContext.messageFor).
  String? messageFor(String field, String? Function(FieldIssue) render) {
    final issue = issues[field];
    return issue != null ? render(issue) : messages[field];
  }
}
