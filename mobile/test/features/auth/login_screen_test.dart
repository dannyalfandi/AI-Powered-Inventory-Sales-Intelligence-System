import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_controller.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_providers.dart';
import 'package:inventory_intel/features/auth/presentation/screens/login_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/auth_fixtures.dart';
import '../../helpers/l10n_harness.dart';

void main() {
  late MockAuthRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = MockAuthRepository();
    when(() => repo.hasSession).thenReturn(false);
    container = ProviderContainer.test(overrides: [authRepositoryProvider.overrideWithValue(repo)], retry: (_, _) => null);
  });

  Future<void> pumpLogin(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: localizedApp(home: const LoginScreen())),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fillAndSubmit(WidgetTester tester, {String email = 'staff@example.com', String password = 'staff12345'}) async {
    await tester.enterText(find.byKey(const Key('login_email')), email);
    await tester.enterText(find.byKey(const Key('login_password')), password);
    await tester.tap(find.byKey(const Key('login_submit')));
  }

  void stubLogin(Future<AuthUser> Function() answer) =>
      when(() => repo.login(email: any(named: 'email'), password: any(named: 'password'))).thenAnswer((_) => answer());

  group('validation before sending', () {
    testWidgets('empty form: both fields required, nothing sent', (tester) async {
      await pumpLogin(tester);
      await tester.tap(find.byKey(const Key('login_submit')));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      expect(find.text(l10n.validationEmailRequired), findsOneWidget);
      expect(find.text(l10n.validationPasswordRequired), findsOneWidget);
      verifyNever(() => repo.login(email: any(named: 'email'), password: any(named: 'password')));
    });

    testWidgets('malformed email', (tester) async {
      await pumpLogin(tester);
      await fillAndSubmit(tester, email: 'staff-at-example');
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).validationEmailInvalid), findsOneWidget);
      verifyNever(() => repo.login(email: any(named: 'email'), password: any(named: 'password')));
    });

    testWidgets('a short password is not rejected here (only "not empty")', (tester) async {
      stubLogin(() async => staff);
      await pumpLogin(tester);
      await fillAndSubmit(tester, password: 'x');
      await tester.pumpAndSettle();

      verify(() => repo.login(email: 'staff@example.com', password: 'x')).called(1);
    });
  });

  testWidgets('401: a clear "wrong email or password" in the form, and the user can retry', (tester) async {
    stubLogin(() => Future.error(const ServerFailure('invalid email or password', statusCode: 401, code: 'invalid_credentials')));
    await pumpLogin(tester);
    await fillAndSubmit(tester, password: 'wrong-pass');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_error')), findsOneWidget);
    expect(find.text(l10nOf(tester).loginInvalidCredentials), findsOneWidget);
    expect(container.read(currentUserProvider), isNull);
    // The form is usable again right away, with what was typed kept.
    expect(tester.widget<FilledButton>(find.byKey(const Key('login_submit'))).onPressed, isNotNull);
    expect(find.text('staff@example.com'), findsOneWidget);

    // Typing again clears the message.
    await tester.enterText(find.byKey(const Key('login_password')), 'staff12345');
    await tester.pump();
    expect(find.byKey(const Key('login_error')), findsNothing);
  });

  testWidgets('loading: button disabled with a spinner, fields locked, until the answer', (tester) async {
    final answer = Completer<AuthUser>();
    stubLogin(() => answer.future);
    await pumpLogin(tester);
    await fillAndSubmit(tester);
    await tester.pump();

    final button = tester.widget<FilledButton>(find.byKey(const Key('login_submit')));
    expect(button.onPressed, isNull, reason: 'no double submit');
    expect(find.descendant(of: find.byKey(const Key('login_submit')), matching: find.byType(CircularProgressIndicator)),
        findsOneWidget);
    expect(tester.widget<TextField>(find.descendant(of: find.byKey(const Key('login_email')), matching: find.byType(TextField))).enabled,
        isFalse);

    answer.complete(staff);
    await tester.pumpAndSettle();
    expect(container.read(currentUserProvider), staff, reason: 'logged in; the router takes it from here');
  });

  testWidgets('422 from the backend: messages under the fields', (tester) async {
    stubLogin(() => Future.error(const ValidationFailure('request validation failed', messages: {'email': 'is required'})));
    await pumpLogin(tester);
    await fillAndSubmit(tester);
    await tester.pumpAndSettle();

    expect(find.text('is required'), findsOneWidget);
    expect(find.byKey(const Key('login_error')), findsNothing);
  });

  testWidgets('offline: a network message, not "wrong password"', (tester) async {
    stubLogin(() => Future.error(const NetworkFailure('cannot reach the server', issue: FailureIssue.unreachable)));
    await pumpLogin(tester);
    await fillAndSubmit(tester);
    await tester.pumpAndSettle();

    final l10n = l10nOf(tester);
    expect(find.byKey(const Key('login_error')), findsOneWidget);
    expect(find.text(l10n.loginFailed(l10n.networkUnreachable)), findsOneWidget);
    expect(find.text(l10n.loginInvalidCredentials), findsNothing);
  });

  testWidgets('the password can be shown and hidden', (tester) async {
    await pumpLogin(tester);
    TextField password() =>
        tester.widget<TextField>(find.descendant(of: find.byKey(const Key('login_password')), matching: find.byType(TextField)));

    expect(password().obscureText, isTrue);
    await tester.tap(find.byKey(const Key('login_toggle_password')));
    await tester.pump();
    expect(password().obscureText, isFalse);
  });
}
