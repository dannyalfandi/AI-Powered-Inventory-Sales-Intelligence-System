import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/error/failure_mapper.dart';

DioException _response(int status, Object? body) {
  final req = RequestOptions(path: '/api/v1/products');
  return DioException.badResponse(
    statusCode: status,
    requestOptions: req,
    response: Response(requestOptions: req, statusCode: status, data: body),
  );
}

DioException _type(DioExceptionType type) =>
    DioException(requestOptions: RequestOptions(path: '/'), type: type);

void main() {
  // Bodies below are exactly what backend pkg/response.Error produces.
  final cases = <({String name, DioException input, Matcher matcher})>[
    (
      name: '422 validation_failed → ValidationFailure with field messages',
      input: _response(422, {
        'error': {
          'code': 'validation_failed',
          'message': 'request validation failed',
          'details': [
            {'field': 'sku', 'message': 'is required'},
            {'field': 'price', 'message': 'must not be negative'},
          ],
        },
      }),
      matcher: isA<ValidationFailure>().having(
        (f) => f.messages,
        'messages',
        {'sku': 'is required', 'price': 'must not be negative'},
      ),
    ),
    (
      name: '409 conflict → ServerFailure(conflict)',
      input: _response(409, {
        'error': {'code': 'conflict', 'message': 'conflict: product sku A already exists'},
      }),
      matcher: isA<ServerFailure>()
          .having((f) => f.isConflict, 'isConflict', true)
          .having((f) => f.code, 'code', 'conflict')
          .having((f) => f.message, 'message', contains('already exists')),
    ),
    (
      name: '404 not_found → ServerFailure(not found)',
      input: _response(404, {
        'error': {'code': 'not_found', 'message': 'not found: product 9'},
      }),
      matcher: isA<ServerFailure>().having((f) => f.isNotFound, 'isNotFound', true),
    ),
    (
      name: '500 without envelope → generic ServerFailure',
      input: _response(500, '<html>oops</html>'),
      matcher: isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500),
    ),
    (
      name: 'connection error → NetworkFailure',
      input: _type(DioExceptionType.connectionError),
      matcher: isA<NetworkFailure>(),
    ),
    (
      name: 'receive timeout → NetworkFailure',
      input: _type(DioExceptionType.receiveTimeout),
      matcher: isA<NetworkFailure>(),
    ),
  ];

  for (final c in cases) {
    test(c.name, () => expect(mapDioException(c.input), c.matcher));
  }

  test('returns an already-attached Failure unchanged', () {
    const failure = NetworkFailure('x');
    final e = DioException(requestOptions: RequestOptions(path: '/'), error: failure);
    expect(mapDioException(e), same(failure));
  });
}
