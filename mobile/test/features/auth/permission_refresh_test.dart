import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/app.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/core/auth/token_store.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/core/network/dio_client.dart';
import 'package:inventory_intel/core/auth/session_events.dart';
import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:inventory_intel/core/router/app_router.dart';
import 'package:inventory_intel/core/utils/clock.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_controller.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_providers.dart';
import 'package:inventory_intel/features/auth/presentation/providers/permission_refresher.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_providers.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/auth_fixtures.dart';
import '../../helpers/category_fixtures.dart';
import '../../helpers/product_fixtures.dart';

AuthUser _user(Set<String> permissions) => AuthUser(
  id: 30,
  email: 'gudang@example.com',
  name: 'Gudang',
  role: const AuthRole(id: 30, name: 'Gudang', isSystem: false),
  permissions: permissions,
);

final _wide = _user({Permissions.productsView, Permissions.categoriesView});
final _narrow = _user({Permissions.productsView});

void main() {
  // --- when to refresh ------------------------------------------------------

  group('PermissionRefresher: throttle, debounce, no overlap', () {
    late DateTime now;
    late int calls;
    late PermissionRefresher refresher;

    setUp(() {
      now = DateTime.utc(2026, 10, 9, 10);
      calls = 0;
      refresher = PermissionRefresher(refresh: () async => calls++, now: () => now);
    });
    tearDown(() => refresher.dispose());

    test('resume: at most once per 60 s (fake clock, no waiting)', () async {
      await refresher.onResumed();
      expect(calls, 1);
      now = now.add(const Duration(seconds: 59));
      await refresher.onResumed();
      expect(calls, 1, reason: '59 s later: throttled');
      now = now.add(const Duration(seconds: 1));
      await refresher.onResumed();
      expect(calls, 2, reason: '60 s after the first: allowed');
    });

    test('a call in flight is joined, never doubled', () async {
      final gate = Completer<void>();
      var started = 0;
      final slow = PermissionRefresher(
        refresh: () {
          started++;
          return gate.future;
        },
        now: () => now,
        minInterval: Duration.zero,
      );
      final a = slow.onResumed();
      final b = slow.onResumed();
      expect(started, 1);
      gate.complete();
      await Future.wait([a, b]);
      slow.dispose();
    });

    testWidgets('403: a burst becomes one call, after the burst settles', (tester) async {
      for (var i = 0; i < 12; i++) {
        refresher.onForbidden();
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(calls, 0, reason: 'still inside the burst');
      await tester.pump(refresher.debounce);
      expect(calls, 1);
      await tester.pump(const Duration(seconds: 5));
      expect(calls, 1, reason: 'nothing more without new 403s');
    });

    testWidgets('403 right after a resume refresh still refreshes (it is evidence, not a schedule)', (tester) async {
      await refresher.onResumed();
      refresher.onForbidden();
      await tester.pump(refresher.debounce);
      expect(calls, 2);
    });
  });

  // --- what a refresh does to the state ---------------------------------------

  group('AuthController.refreshPermissions', () {
    late MockAuthRepository repo;
    late ProviderContainer c;

    Future<void> startAs(AuthUser user) async {
      repo = MockAuthRepository();
      when(() => repo.hasSession).thenReturn(true);
      when(() => repo.currentUser()).thenAnswer((_) async => user);
      c = ProviderContainer.test(overrides: [authRepositoryProvider.overrideWithValue(repo)], retry: (_, _) => null);
      await c.read(authControllerProvider.future);
    }

    test('fewer permissions on the server: the state follows', () async {
      await startAs(_wide);
      when(() => repo.currentUser()).thenAnswer((_) async => _narrow);
      await c.read(authControllerProvider.notifier).refreshPermissions();
      expect(c.read(currentUserProvider), _narrow);
    });

    test('unchanged: no new state at all (nothing rebuilds, the router stays put)', () async {
      await startAs(_wide);
      var notified = 0;
      c.listen(authControllerProvider, (_, _) => notified++);
      await c.read(authControllerProvider.notifier).refreshPermissions();
      expect(notified, 0);
    });

    for (final (name, failure) in [
      ('offline', const NetworkFailure('offline', issue: FailureIssue.unreachable)),
      ('server error', const ServerFailure('boom', statusCode: 500, code: 'internal_error')),
    ]) {
      test('$name: quietly keeps the current state', () async {
        await startAs(_wide);
        when(() => repo.currentUser()).thenThrow(failure);
        await c.read(authControllerProvider.notifier).refreshPermissions();
        expect(c.read(currentUserProvider), _wide);
      });
    }

    test('logged out while the call was in flight: the late answer is ignored', () async {
      await startAs(_wide);
      final answer = Completer<AuthUser>();
      when(() => repo.currentUser()).thenAnswer((_) => answer.future);
      when(() => repo.logout()).thenAnswer((_) async {});
      final refresh = c.read(authControllerProvider.notifier).refreshPermissions();
      await c.read(authControllerProvider.notifier).logout();
      answer.complete(_narrow);
      await refresh;
      expect(c.read(currentUserProvider), isNull);
    });

    test('nobody logged in: no request', () async {
      await startAs(_wide);
      when(() => repo.logout()).thenAnswer((_) async {});
      await c.read(authControllerProvider.notifier).logout();
      clearInteractions(repo);
      await c.read(authControllerProvider.notifier).refreshPermissions();
      verifyNever(() => repo.currentUser());
    });
  });

  // --- through the real network stack ----------------------------------------

  group('over the real Dio client', () {
    late FakeApi api;
    late ProviderContainer c;

    Future<void> start() async {
      c = ProviderContainer.test(
        overrides: [
          tokenStoreProvider.overrideWithValue(
            MemoryTokenStore(const AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1')),
          ),
          // The app's own wiring (dio_client.dart), over a fake backend.
          dioProvider.overrideWith(
            (ref) => buildDio(
              baseUrl: 'http://api.test',
              tokens: ref.watch(tokenStoreProvider),
              onSessionEnded: () => ref.read(sessionEndedProvider.notifier).signal(),
              onForbidden: () => ref.read(permissionDeniedProvider.notifier).signal(),
              adapter: api,
            ),
          ),
        ],
        retry: (_, _) => null,
      );
      await c.read(authControllerProvider.future);
      c.read(permissionRefresherProvider); // starts its 403 listener, as InventoryApp does
    }

    Future<void> getIgnoringErrors(String path) async {
      try {
        await c.read(dioProvider).get<dynamic>(path);
      } on DioException {
        // the 403 is expected
      }
    }

    testWidgets('a burst of 403s from business endpoints → exactly one /auth/me, and the UI state updates', (tester) async {
      api = FakeApi(me: [_meJson(_wide), _meJson(_narrow)]);
      await tester.runAsync(start);
      await tester.runAsync(() => Future.wait([
        for (var i = 0; i < 6; i++) getIgnoringErrors(i.isEven ? '/api/v1/categories' : '/api/v1/products'),
      ]));
      expect(api.count('/api/v1/auth/me'), 1, reason: 'only the start-up call so far');

      // The 403s arrived on real I/O, so the debounce timer runs on real time.
      final debounce = c.read(permissionRefresherProvider).debounce;
      await tester.runAsync(() => Future<void>.delayed(debounce + const Duration(milliseconds: 300)));
      expect(api.count('/api/v1/auth/me'), 2, reason: 'six 403s, one refresh');
      expect(c.read(currentUserProvider)!.permissions, {Permissions.productsView});
    });

    testWidgets('a 403 from /auth/* is not a permission signal', (tester) async {
      api = FakeApi(me: [_meJson(_wide)], meStatus: [200, 403]);
      await tester.runAsync(start);
      await tester.runAsync(() => c.read(authControllerProvider.notifier).refreshPermissions());
      await tester.pump(const Duration(seconds: 2));
      expect(api.count('/api/v1/auth/me'), 2, reason: 'start-up + the one refresh; the 403 did not chain');
      expect(c.read(currentUserProvider), _wide);
    });

    testWidgets('401 on the refresh: the existing "session ended" path logs the user out', (tester) async {
      api = FakeApi(me: [_meJson(_wide)], meStatus: [200, 401]);
      await tester.runAsync(start);
      await tester.runAsync(() => c.read(authControllerProvider.notifier).refreshPermissions());
      expect(c.read(currentUserProvider), isNull);
      expect(c.read(tokenStoreProvider).current, isNull, reason: 'the network layer cleared the tokens');
    });

    testWidgets('offline on the refresh: nothing changes', (tester) async {
      api = FakeApi(me: [_meJson(_wide)], meStatus: [200, 0]);
      await tester.runAsync(start);
      await tester.runAsync(() => c.read(authControllerProvider.notifier).refreshPermissions());
      expect(c.read(currentUserProvider), _wide);
      expect(c.read(tokenStoreProvider).current, isNotNull);
    });
  });

  // --- the whole app: foreground → UI follows ---------------------------------

  group('InventoryApp', () {
    late MockAuthRepository auth;
    late DateTime now;

    Future<ProviderContainer> launch(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      auth = MockAuthRepository();
      when(() => auth.hasSession).thenReturn(true);
      when(() => auth.currentUser()).thenAnswer((_) async => _wide);
      final products = MockProductRepository();
      when(() => products.getProducts(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => productPage([]));
      final categories = MockCategoryRepository();
      when(() => categories.getCategories(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => const PageResult(items: [], page: 1, pageSize: 20, total: 0));
      now = DateTime.utc(2026, 10, 9, 10);
      final c = ProviderContainer.test(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          productRepositoryProvider.overrideWithValue(products),
          categoryRepositoryProvider.overrideWithValue(categories),
          sharedPreferencesProvider.overrideWithValue(preferences),
          clockProvider.overrideWithValue(() => now),
        ],
        retry: (_, _) => null,
      );
      await tester.pumpWidget(UncontrolledProviderScope(container: c, child: const InventoryApp()));
      await tester.pumpAndSettle();
      return c;
    }

    Future<void> backgroundThenForeground(WidgetTester tester) async {
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pumpAndSettle();
    }

    String location(ProviderContainer c) => c.read(appRouterProvider).routerDelegate.currentConfiguration.uri.path;

    testWidgets('a permission taken away while in the background: back on screen, the tab is gone and the user moved',
        (tester) async {
      final c = await launch(tester);
      c.read(appRouterProvider).go('/categories');
      await tester.pumpAndSettle();
      expect(location(c), '/categories');
      expect(find.byKey(const Key('tab_categories')), findsOneWidget);

      // A Super Admin removes categories.view from the role.
      when(() => auth.currentUser()).thenAnswer((_) async => _narrow);
      now = now.add(const Duration(minutes: 5));
      await backgroundThenForeground(tester);

      expect(location(c), '/products', reason: 'moved to the first tab still allowed');
      expect(find.byKey(const Key('tab_categories')), findsNothing);
      expect(find.byType(NavigationBar), findsNothing, reason: 'one tab left');
    });

    testWidgets('foreground again within 60 s: no second /auth/me', (tester) async {
      await launch(tester);
      clearInteractions(auth);
      await backgroundThenForeground(tester); // the first resume refreshes
      verify(() => auth.currentUser()).called(1);
      now = now.add(const Duration(seconds: 30));
      await backgroundThenForeground(tester);
      verifyNever(() => auth.currentUser());
      now = now.add(const Duration(seconds: 31));
      await backgroundThenForeground(tester);
      verify(() => auth.currentUser()).called(1);
    });
  });
}

Map<String, dynamic> _meJson(AuthUser u) => {
  'data': {
    'id': u.id,
    'email': u.email,
    'name': u.name,
    'is_active': true,
    'role': {'id': u.role.id, 'name': u.role.name, 'is_system': u.role.isSystem},
    'permissions': u.permissions.toList(),
  },
};

/// A fake backend under the real Dio stack: `/auth/me` answers from [me]
/// (one body per call, the last one repeating) with the status from
/// [meStatus] (200 by default; 0 = connection error); every business path
/// answers 403 forbidden. Counts calls per path.
class FakeApi implements HttpClientAdapter {
  FakeApi({required this.me, this.meStatus = const []});

  final List<Map<String, dynamic>> me;
  final List<int> meStatus;
  final _calls = <String, int>{};
  var _meCalls = 0;

  int count(String path) => _calls[path] ?? 0;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final path = options.uri.path;
    _calls[path] = count(path) + 1;
    if (path == '/api/v1/auth/me') {
      final i = _meCalls++;
      final status = i < meStatus.length ? meStatus[i] : 200;
      if (status == 0) {
        throw DioException.connectionError(requestOptions: options, reason: 'offline');
      }
      if (status == 401) return _json(401, _error('unauthorized', 'akun ini tidak aktif'));
      if (status == 403) return _json(403, _error('forbidden', 'anda tidak punya izin'));
      return _json(200, me[i < me.length ? i : me.length - 1]);
    }
    return _json(403, _error('forbidden', 'anda tidak punya izin categories.view'));
  }

  static Map<String, dynamic> _error(String code, String message) => {
    'error': {'code': code, 'message': message},
  };

  static ResponseBody _json(int status, Map<String, dynamic> body) =>
      ResponseBody.fromString(jsonEncode(body), status, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      });

  @override
  void close({bool force = false}) {}
}
