import 'package:dio/dio.dart';

import 'failure.dart';
import 'failure_mapper.dart';

/// Runs a data-source call and converts every exception into a [Failure], so
/// repositories never leak Dio or JSON-parsing errors to the UI.
Future<T> guardApiCall<T>(Future<T> Function() body) async {
  try {
    return await body();
  } on Failure {
    rethrow;
  } on DioException catch (e) {
    throw mapDioException(e);
  } on TypeError catch (_) {
    // Missing/mistyped JSON field — backend contract drift.
    throw const ServerFailure('malformed response', code: 'invalid_response', issue: FailureIssue.malformedResponse);
  } on FormatException catch (_) {
    throw const ServerFailure('malformed response', code: 'invalid_response', issue: FailureIssue.malformedResponse);
  }
}
