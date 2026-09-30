import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_intel/core/auth/session_events.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/core/router/app_router.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_controller.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_providers.dart';
import 'package:inventory_intel/features/auth/presentation/screens/login_screen.dart';
import 'package:inventory_intel/features/auth/presentation/screens/splash_screen.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:inventory_intel/features/settings/presentation/screens/settings_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/auth_fixtures.dart';
import '../../helpers/dashboard_fixtures.dart';
import '../../helpers/l10n_harness.dart';

void main() {
  group('authRedirect (the guard as a table)', () {
    const loading = AsyncLoading<AuthUser?>();
    const loggedOut = AsyncData<AuthUser?>(null);
    const loggedIn = AsyncData<AuthUser?>(staff);

    final cases = <(String, AsyncValue<AuthUser?>, String, String?)>[
      ('checking the session: any page waits on the splash', loading, '/products', '/splash'),
      ('checking the session, already on the splash: stay', loading, '/splash', null),
      ('logged out: every page goes to login', loggedOut, '/sales-orders/5', '/login'),
      ('logged out: the dashboard too', loggedOut, '/', '/login'),
      ('logged out, already on login: stay (no loop)', loggedOut, '/login', null),
      ('logged out, on the splash: login', loggedOut, '/splash', '/login'),
      ('logged in, on login: the dashboard', loggedIn, '/login', '/'),
      ('logged in, on the splash: the dashboard', loggedIn, '/splash', '/'),
      ('logged in, anywhere else: no redirect', loggedIn, '/customers', null),
    ];
    for (final (name, auth, location, want) in cases) {
      test(name, () => expect(authRedirect(auth, location), want));
    }
  });

  group('the real router', () {
    late MockAuthRepository auth;
    late MockDashboardRepository dashboard;
    late ProviderContainer container;
    late GoRouter router;

    setUpAll(registerDashboardFallbacks);

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      auth = MockAuthRepository();
      dashboard = MockDashboardRepository();
      stubDashboard(dashboard);
      container = ProviderContainer.test(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          dashboardRepositoryProvider.overrideWithValue(dashboard),
          sharedPreferencesProvider.overrideWithValue(preferences),
        ],
        retry: (_, _) => null,
      );
    });

    Future<void> start(WidgetTester tester) async {
      router = container.read(appRouterProvider);
      await tester.pumpWidget(UncontrolledProviderScope(container: container, child: localizedApp(routerConfig: router)));
    }

    String location() => router.routerDelegate.currentConfiguration.uri.path;

    testWidgets('start-up with a stored session: splash while /auth/me runs, then the dashboard', (tester) async {
      final me = Completer<AuthUser>();
      when(() => auth.hasSession).thenReturn(true);
      when(() => auth.currentUser()).thenAnswer((_) => me.future);

      await start(tester);
      await tester.pump();
      expect(find.byType(SplashScreen), findsOneWidget);

      me.complete(staff);
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(location(), '/');
    });

    testWidgets('start-up with no session: the login screen, whatever the start page', (tester) async {
      when(() => auth.hasSession).thenReturn(false);
      await start(tester);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      router.go('/products');
      await tester.pumpAndSettle();
      expect(location(), '/login', reason: 'guarded routes are unreachable without a user');
    });

    testWidgets('session ended by the server, deep in the app: back to login, once', (tester) async {
      when(() => auth.hasSession).thenReturn(true);
      when(() => auth.currentUser()).thenAnswer((_) async => staff);
      await start(tester);
      await tester.pumpAndSettle();

      // A full-screen route, pushed over the tabs: "anywhere in the app".
      router.go('/settings');
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      // What the network layer does when a refresh is rejected.
      container.read(sessionEndedProvider.notifier).signal();
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(location(), '/login');

      // Every other request that was in flight reports it too.
      var navigations = 0;
      router.routerDelegate.addListener(() => navigations++);
      container.read(sessionEndedProvider.notifier)
        ..signal()
        ..signal();
      await tester.pumpAndSettle();
      expect(navigations, 0, reason: 'already on /login: no redirect again');
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('login from the login screen: lands on the dashboard', (tester) async {
      when(() => auth.hasSession).thenReturn(false);
      when(() => auth.login(email: any(named: 'email'), password: any(named: 'password'))).thenAnswer((_) async => superAdmin);
      await start(tester);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('login_email')), 'admin@example.com');
      await tester.enterText(find.byKey(const Key('login_password')), 'admin12345');
      await tester.tap(find.byKey(const Key('login_submit')));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(location(), '/');
    });

    testWidgets('logout from Settings: shows who is logged in, then back to login', (tester) async {
      when(() => auth.hasSession).thenReturn(true);
      when(() => auth.currentUser()).thenAnswer((_) async => staff);
      when(() => auth.logout()).thenAnswer((_) async {});
      await start(tester);
      await tester.pumpAndSettle();
      router.go('/settings');
      await tester.pumpAndSettle();

      expect(find.text('Staf Demo'), findsOneWidget);
      expect(find.textContaining(l10nOf(tester).settingsAccountRole('Staff')), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('settings_logout')));
      await tester.tap(find.byKey(const Key('settings_logout')));
      await tester.pumpAndSettle();

      verify(() => auth.logout()).called(1);
      expect(container.read(currentUserProvider), isNull);
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
