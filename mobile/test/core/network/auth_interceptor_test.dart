import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/token_store.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/network/auth_interceptor.dart';
import 'package:inventory_intel/core/network/dio_client.dart';

/// What the fake backend does with the next `/auth/refresh`.
enum RefreshMode {
  /// Rotate and answer 200.
  rotate,

  /// Answer 401 (refresh token rejected).
  reject,

  /// Fail before the request "reaches" the server: nothing rotated.
  connectionError,

  /// Rotate on the server, then lose the answer (receive timeout).
  rotateThenLoseAnswer,
}

/// A fake backend under the whole Dio stack, with the real backend's rules:
///
/// - an access token is valid until [expireAccess]; then it gets 401
///   `token_expired`;
/// - a refresh token works **once**. Sending a used one again is counted in
///   [reuseAttempts] — against the real backend that is reuse detection, and
///   the user is logged out on every device. Every test asserts it stays 0.
class FakeBackend implements HttpClientAdapter {
  FakeBackend({required String access, required String refresh})
    : _validAccess = {access},
      _currentRefresh = refresh;

  final Set<String> _validAccess;
  final Set<String> _expiredAccess = {};
  String? _currentRefresh;
  var _issued = 0;

  RefreshMode refreshMode = RefreshMode.rotate;
  int refreshCalls = 0;
  int reuseAttempts = 0;

  /// Set when a test wants refreshes to wait (so requests can pile up).
  Completer<void>? refreshGate;

  /// Set when `/slow` should hold its answer until released.
  Completer<void>? slowGate;

  /// Every non-refresh request: `path Authorization`.
  final requests = <String>[];
  int expiredHits = 0;

  /// Makes every access token issued so far expired.
  void expireAccess() {
    _expiredAccess.addAll(_validAccess);
    _validAccess.clear();
  }

  /// When true, tokens issued by a refresh are already expired.
  bool issueExpired = false;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    if (options.path == '/api/v1/auth/refresh') {
      return _refresh(options);
    }

    final auth = options.headers['Authorization'] as String?;
    requests.add('${options.path} ${auth ?? '-'}');
    final token = auth?.replaceFirst('Bearer ', '');

    if (options.path == '/slow') {
      await slowGate?.future;
    }
    if (token == null) return _json(401, _error('unauthorized'));
    if (_expiredAccess.contains(token)) {
      expiredHits++;
      return _json(401, _error('token_expired'));
    }
    if (!_validAccess.contains(token)) return _json(401, _error('unauthorized'));

    return switch (options.path) {
      '/forbidden' => _json(403, _error('forbidden')),
      '/deactivated' => _json(401, _error('unauthorized')),
      _ => _json(200, {
        'data': {'path': options.path, 'token': token},
      }),
    };
  }

  Future<ResponseBody> _refresh(RequestOptions options) async {
    refreshCalls++;
    await refreshGate?.future;
    final sent = (options.data as Map)['refresh_token'] as String;

    switch (refreshMode) {
      case RefreshMode.reject:
        return _json(401, _error('unauthorized'));
      case RefreshMode.connectionError:
        throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
      case RefreshMode.rotate:
      case RefreshMode.rotateThenLoseAnswer:
        if (sent != _currentRefresh) {
          reuseAttempts++; // the real backend would now revoke every session
          return _json(401, _error('unauthorized'));
        }
        _issued++;
        final access = 'access-$_issued';
        _currentRefresh = 'refresh-$_issued';
        (issueExpired ? _expiredAccess : _validAccess).add(access);
        if (refreshMode == RefreshMode.rotateThenLoseAnswer) {
          throw DioException(requestOptions: options, type: DioExceptionType.receiveTimeout);
        }
        return _json(200, {
          'data': {'access_token': access, 'refresh_token': _currentRefresh, 'token_type': 'Bearer', 'expires_in': 900},
        });
    }
  }

  static Map<String, Object> _error(String code) => {
    'error': {'code': code, 'message': code},
  };

  static ResponseBody _json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

/// Lets queued futures and microtasks run until [done] holds.
Future<void> settleUntil(bool Function() done) async {
  for (var i = 0; i < 200 && !done(); i++) {
    await Future<void>.delayed(Duration.zero);
  }
  expect(done(), isTrue, reason: 'condition not reached');
}

class Harness {
  Harness({String access = 'access-0', String refresh = 'refresh-0'})
    : backend = FakeBackend(access: access, refresh: refresh),
      store = MemoryTokenStore(AuthTokens(accessToken: access, refreshToken: refresh)) {
    dio = buildDio(
      baseUrl: 'http://api.test',
      tokens: store,
      onSessionEnded: () => sessionEnded++,
      adapter: backend,
    );
  }

  final FakeBackend backend;
  final MemoryTokenStore store;
  late final Dio dio;
  int sessionEnded = 0;

  Future<Map<String, dynamic>> get(String path) async {
    final response = await dio.get<Map<String, dynamic>>(path);
    return response.data!['data'] as Map<String, dynamic>;
  }

  /// Runs [path] and returns the Failure it failed with.
  Future<Failure> failure(String path) async {
    try {
      await dio.get<dynamic>(path);
    } on DioException catch (e) {
      return e.error! as Failure;
    }
    fail('$path should have failed');
  }
}

void main() {
  group('attaching the token', () {
    test('every request carries the current access token', () async {
      final h = Harness();
      await h.get('/a');
      expect(h.backend.requests, ['/a Bearer access-0']);
    });

    test('requests marked skipAuth (login) carry none', () async {
      final h = Harness();
      await h.dio.get<dynamic>(
        '/login',
        options: Options(extra: {AuthInterceptor.skipAuth: true}, validateStatus: (_) => true),
      );
      expect(h.backend.requests, ['/login -']);
    });
  });

  group('single-flight refresh', () {
    test('5 requests expiring together cause exactly ONE refresh, and all succeed', () async {
      final h = Harness();
      h.backend.expireAccess();
      h.backend.refreshGate = Completer<void>(); // hold the refresh open

      final results = [for (var i = 0; i < 5; i++) h.get('/r$i')];
      // Wait until all five have their 401 and are waiting on the refresh.
      await settleUntil(() => h.backend.expiredHits == 5 && h.backend.refreshCalls >= 1);
      // Give the other four every chance to start a refresh of their own.
      for (var i = 0; i < 50; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(h.backend.refreshCalls, 1, reason: 'the other four wait instead of refreshing');

      h.backend.refreshGate!.complete();
      final data = await Future.wait(results);

      expect(data.map((d) => d['token']), everyElement('access-1'), reason: 'all retried with the new token');
      expect(h.backend.refreshCalls, 1);
      expect(h.backend.reuseAttempts, 0);
      expect(h.store.current!.refreshToken, 'refresh-1');
      // Each request went out twice: the 401, then one retry.
      for (var i = 0; i < 5; i++) {
        expect(h.backend.requests.where((r) => r.startsWith('/r$i ')), ['/r$i Bearer access-0', '/r$i Bearer access-1']);
      }
      expect(h.sessionEnded, 0);
    });

    test('a 401 that arrives AFTER the refresh finished retries with the new token, no second refresh', () async {
      final h = Harness();
      h.backend.slowGate = Completer<void>();
      // Sent with the old token, but its answer is held back.
      final late = h.get('/slow');
      await settleUntil(() => h.backend.requests.length == 1);

      h.backend.expireAccess();
      // Another request expires and refreshes, all the way to completion.
      expect((await h.get('/fast'))['token'], 'access-1');
      expect(h.backend.refreshCalls, 1);

      // Now the slow one gets its 401 for a token that was already replaced.
      h.backend.slowGate!.complete();
      expect((await late)['token'], 'access-1');
      expect(h.backend.refreshCalls, 1, reason: 'a late 401 must not spend the new refresh token');
      expect(h.backend.reuseAttempts, 0);
    });

    test('the next expiry refreshes again, with the rotated token (not a reuse)', () async {
      final h = Harness();
      h.backend.expireAccess();
      await h.get('/a');
      h.backend.expireAccess();
      await Future.wait([h.get('/b'), h.get('/c')]);

      expect(h.backend.refreshCalls, 2);
      expect(h.backend.reuseAttempts, 0);
      expect(h.store.current!.accessToken, 'access-2');
    });

    test('a token that is expired again right after the refresh is not retried a second time', () async {
      final h = Harness();
      h.backend
        ..expireAccess()
        ..issueExpired = true;

      final f = await h.failure('/a');

      expect((f as ServerFailure).statusCode, 401);
      expect(h.backend.refreshCalls, 1, reason: 'no refresh loop');
      expect(h.backend.requests, hasLength(2), reason: 'the original and exactly one retry');
    });
  });

  group('when the refresh fails', () {
    test('rejected (401): the session ends once, every waiting request fails, nothing retries', () async {
      final h = Harness();
      h.backend
        ..expireAccess()
        ..refreshMode = RefreshMode.reject;

      final failures = await Future.wait([h.failure('/a'), h.failure('/b'), h.failure('/c')]);

      expect(failures.map((f) => (f as ServerFailure).statusCode), everyElement(401));
      expect(h.backend.refreshCalls, 1);
      expect(h.sessionEnded, 1, reason: 'notified once, not once per request');
      expect(h.store.current, isNull);

      await h.failure('/d');
      expect(h.backend.requests.last, '/d -', reason: 'logged out: no token is sent any more');
      expect(h.backend.refreshCalls, 1);
    });

    test('never delivered (offline): requests fail as network errors, the session is kept', () async {
      final h = Harness();
      h.backend
        ..expireAccess()
        ..refreshMode = RefreshMode.connectionError;

      final failures = await Future.wait([h.failure('/a'), h.failure('/b')]);

      expect(failures, everyElement(isA<NetworkFailure>()));
      expect(h.backend.refreshCalls, 1);
      expect(h.sessionEnded, 0);
      expect(h.store.current!.refreshToken, 'refresh-0', reason: 'nothing was rotated, so the token is still good');

      // Back online: the same refresh token works, and it is not a reuse.
      h.backend.refreshMode = RefreshMode.rotate;
      expect((await h.get('/c'))['token'], 'access-1');
      expect(h.backend.reuseAttempts, 0);
    });

    test('answer lost after sending: the session ends and the refresh is NOT retried', () async {
      final h = Harness();
      h.backend
        ..expireAccess()
        ..refreshMode = RefreshMode.rotateThenLoseAnswer;

      await Future.wait([h.failure('/a'), h.failure('/b')]);

      expect(h.backend.refreshCalls, 1);
      expect(h.sessionEnded, 1);
      expect(h.store.current, isNull);

      // A retry would send refresh-0, which the server already rotated: a
      // reuse, and a logout on every device. The client must never do it.
      h.backend.refreshMode = RefreshMode.rotate;
      await h.failure('/c');
      expect(h.backend.refreshCalls, 1);
      expect(h.backend.reuseAttempts, 0);
    });
  });

  group('other auth answers', () {
    test('401 unauthorized (deactivated account) ends the session without refreshing', () async {
      final h = Harness();
      final f = await h.failure('/deactivated');

      expect((f as ServerFailure).statusCode, 401);
      expect(h.backend.refreshCalls, 0);
      expect(h.sessionEnded, 1);
      expect(h.store.current, isNull);
    });

    test('403 forbidden is a permission answer: no refresh, session kept', () async {
      final h = Harness();
      final f = await h.failure('/forbidden');

      expect((f as ServerFailure).statusCode, 403);
      expect(h.backend.refreshCalls, 0);
      expect(h.sessionEnded, 0);
      expect(h.store.current, isNotNull);
    });
  });
}
