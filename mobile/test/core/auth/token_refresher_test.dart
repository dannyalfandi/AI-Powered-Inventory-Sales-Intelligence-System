import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/token_refresher.dart';
import 'package:inventory_intel/core/auth/token_store.dart';

void main() {
  const old = AuthTokens(accessToken: 'a0', refreshToken: 'r0');
  const fresh = AuthTokens(accessToken: 'a1', refreshToken: 'r1');

  test('concurrent callers share one refresh (the same future)', () async {
    final gate = Completer<AuthTokens>();
    final sent = <String>[];
    final refresher = TokenRefresher(
      store: MemoryTokenStore(old),
      refresh: (token) {
        sent.add(token);
        return gate.future;
      },
    );

    final calls = [for (var i = 0; i < 10; i++) refresher.accessTokenAfterExpiry('a0')];
    expect(refresher.isRefreshing, isTrue);
    gate.complete(fresh);

    expect(await Future.wait(calls), everyElement('a1'));
    expect(sent, ['r0'], reason: 'one refresh, with the one current refresh token');
    expect(refresher.isRefreshing, isFalse);
  });

  test('a caller whose token was already replaced gets the current one, no refresh', () async {
    var refreshes = 0;
    final refresher = TokenRefresher(
      store: MemoryTokenStore(fresh),
      refresh: (_) async {
        refreshes++;
        return fresh;
      },
    );

    expect(await refresher.accessTokenAfterExpiry('a0'), 'a1');
    expect(refreshes, 0);
  });

  test('logged out: nothing to refresh', () async {
    final refresher = TokenRefresher(store: MemoryTokenStore(), refresh: (_) async => fresh);
    expect(await refresher.accessTokenAfterExpiry('a0'), isNull);
  });

  test('after a refresh settles, a new expiry starts a new one', () async {
    final sent = <String>[];
    final store = MemoryTokenStore(old);
    var n = 0;
    final refresher = TokenRefresher(
      store: store,
      refresh: (token) async {
        sent.add(token);
        n++;
        return AuthTokens(accessToken: 'a$n', refreshToken: 'r$n');
      },
    );

    await refresher.accessTokenAfterExpiry('a0');
    await refresher.accessTokenAfterExpiry('a1');
    expect(sent, ['r0', 'r1'], reason: 'each refresh uses the token the previous one produced');
  });

  test('sessionRejected ends the session once, however often it is called', () async {
    var ended = 0;
    final store = MemoryTokenStore(old);
    final refresher = TokenRefresher(store: store, refresh: (_) async => fresh, onSessionEnded: () => ended++);

    await Future.wait([refresher.sessionRejected(), refresher.sessionRejected()]);
    await refresher.sessionRejected();

    expect(store.current, isNull);
    expect(ended, 1);
  });
}
