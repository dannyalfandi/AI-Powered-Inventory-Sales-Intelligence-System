import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/session_events.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_controller.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/auth_fixtures.dart';


void main() {
  late MockAuthRepository repo;

  setUp(() => repo = MockAuthRepository());

  ProviderContainer container() =>
      ProviderContainer.test(overrides: [authRepositoryProvider.overrideWithValue(repo)], retry: (_, _) => null);

  group('hydrating at start-up', () {
    test('no stored tokens: logged out, and the server is not asked', () async {
      when(() => repo.hasSession).thenReturn(false);

      expect(await container().read(authControllerProvider.future), isNull);
      verifyNever(() => repo.currentUser());
    });

    test('stored tokens that still work: the user from /auth/me', () async {
      when(() => repo.hasSession).thenReturn(true);
      when(() => repo.currentUser()).thenAnswer((_) async => staff);

      final c = container();
      expect(await c.read(authControllerProvider.future), staff);
      expect(c.read(currentUserProvider), staff);
    });

    test('stored tokens the server rejects (401): logged out', () async {
      when(() => repo.hasSession).thenReturn(true);
      when(() => repo.currentUser()).thenThrow(const ServerFailure('invalid access token', statusCode: 401, code: 'unauthorized'));

      expect(await container().read(authControllerProvider.future), isNull);
    });

    test('server unreachable: logged out (to the login screen), not an error screen', () async {
      when(() => repo.hasSession).thenReturn(true);
      when(() => repo.currentUser()).thenThrow(const NetworkFailure('offline', issue: FailureIssue.unreachable));

      final c = container();
      expect(await c.read(authControllerProvider.future), isNull);
      expect(c.read(authControllerProvider).hasError, isFalse);
    });

    test('loading while /auth/me is in flight (the router shows the splash)', () async {
      when(() => repo.hasSession).thenReturn(true);
      when(() => repo.currentUser()).thenAnswer((_) async => staff);

      final c = container();
      expect(c.read(authControllerProvider).isLoading, isTrue);
      await c.read(authControllerProvider.future);
      expect(c.read(authControllerProvider).isLoading, isFalse);
    });
  });

  group('login', () {
    setUp(() => when(() => repo.hasSession).thenReturn(false));

    test('success: the user becomes current, email normalized', () async {
      when(() => repo.login(email: any(named: 'email'), password: any(named: 'password'))).thenAnswer((_) async => staff);
      final c = container();
      await c.read(authControllerProvider.future);

      await c.read(authControllerProvider.notifier).login(email: '  Staff@Example.COM ', password: 'staff12345');

      expect(c.read(currentUserProvider), staff);
      verify(() => repo.login(email: 'staff@example.com', password: 'staff12345')).called(1);
    });

    test('wrong credentials: the 401 reaches the form, nobody is logged in', () async {
      when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const ServerFailure('invalid email or password', statusCode: 401, code: 'invalid_credentials'));
      final c = container();
      await c.read(authControllerProvider.future);

      await expectLater(
        c.read(authControllerProvider.notifier).login(email: 'staff@example.com', password: 'nope'),
        throwsA(isA<ServerFailure>().having((f) => f.code, 'code', 'invalid_credentials')),
      );
      expect(c.read(currentUserProvider), isNull);
    });
  });

  test('logout: the repository logs out, the user is cleared', () async {
    when(() => repo.hasSession).thenReturn(true);
    when(() => repo.currentUser()).thenAnswer((_) async => superAdmin);
    when(() => repo.logout()).thenAnswer((_) async {});
    final c = container();
    await c.read(authControllerProvider.future);

    await c.read(authControllerProvider.notifier).logout();

    verify(() => repo.logout()).called(1);
    expect(c.read(currentUserProvider), isNull);
  });

  group('session ended by the server (signalled by the network layer)', () {
    test('drops the current user', () async {
      when(() => repo.hasSession).thenReturn(true);
      when(() => repo.currentUser()).thenAnswer((_) async => staff);
      final c = container();
      await c.read(authControllerProvider.future);

      c.read(sessionEndedProvider.notifier).signal();

      expect(c.read(currentUserProvider), isNull);
    });

    test('while logged out: nothing changes (no extra state for the router to react to)', () async {
      when(() => repo.hasSession).thenReturn(false);
      final c = container();
      await c.read(authControllerProvider.future);
      var changes = 0;
      c.listen(authControllerProvider, (_, _) => changes++);

      c.read(sessionEndedProvider.notifier)
        ..signal()
        ..signal();

      expect(changes, 0);
    });
  });
}
