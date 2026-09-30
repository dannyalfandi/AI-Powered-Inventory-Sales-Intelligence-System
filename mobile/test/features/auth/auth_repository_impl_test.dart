import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/token_store.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:inventory_intel/features/auth/data/models/auth_models.dart';
import 'package:inventory_intel/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemote extends Mock implements AuthRemoteDataSource {}

const _pair = TokenPairModel(accessToken: 'a1', refreshToken: 'r1', tokenType: 'Bearer', expiresIn: 900);
const _me = MeModel(
  id: 2,
  email: 'staff@example.com',
  name: 'Staf Demo',
  isActive: true,
  role: RoleRefModel(id: 2, name: 'Staff', isSystem: false),
  permissions: ['products.view'],
);

DioException _status(int code, Map<String, dynamic> body) {
  final req = RequestOptions(path: '/');
  return DioException.badResponse(
    statusCode: code,
    requestOptions: req,
    response: Response(requestOptions: req, statusCode: code, data: body),
  );
}

void main() {
  late MockAuthRemote remote;
  late MemoryTokenStore store;
  late AuthRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(const LoginRequest(email: '', password: ''));
    registerFallbackValue(const RefreshTokenRequest(refreshToken: ''));
  });

  setUp(() {
    remote = MockAuthRemote();
    store = MemoryTokenStore();
    repo = AuthRepositoryImpl(remote, store);
  });

  test('login stores the pair, then asks /auth/me for the permissions', () async {
    when(() => remote.login(any())).thenAnswer((_) async => _pair);
    when(() => remote.me()).thenAnswer((_) async => _me);

    final user = await repo.login(email: 'staff@example.com', password: 'staff12345');

    expect(store.current?.accessToken, 'a1');
    expect(store.current?.refreshToken, 'r1');
    expect(user.permissions, {'products.view'});
    expect(repo.hasSession, isTrue);
  });

  test('wrong credentials: a 401 Failure, and nothing is stored', () async {
    when(() => remote.login(any())).thenThrow(
      _status(401, {
        'error': {'code': 'invalid_credentials', 'message': 'invalid email or password'},
      }),
    );

    await expectLater(
      repo.login(email: 'staff@example.com', password: 'x'),
      throwsA(isA<ServerFailure>().having((f) => f.statusCode, 'status', 401)),
    );
    expect(store.current, isNull);
  });

  test('login succeeds but /auth/me fails: the tokens are dropped again (no half login)', () async {
    when(() => remote.login(any())).thenAnswer((_) async => _pair);
    when(() => remote.me()).thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError));

    await expectLater(repo.login(email: 'a@b.c', password: 'p'), throwsA(isA<NetworkFailure>()));
    expect(store.current, isNull);
  });

  test('logout revokes the refresh token on the server and forgets the tokens', () async {
    await store.save(const AuthTokens(accessToken: 'a1', refreshToken: 'r1'));
    when(() => remote.logout(any())).thenAnswer((_) async {});

    await repo.logout();

    verify(() => remote.logout(const RefreshTokenRequest(refreshToken: 'r1'))).called(1);
    expect(store.current, isNull);
  });

  test('logout works offline: tokens forgotten, no error', () async {
    await store.save(const AuthTokens(accessToken: 'a1', refreshToken: 'r1'));
    when(() => remote.logout(any()))
        .thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError));

    await repo.logout();

    expect(store.current, isNull);
  });

  test('logout with no session sends nothing', () async {
    await repo.logout();
    verifyNever(() => remote.logout(any()));
  });
}
