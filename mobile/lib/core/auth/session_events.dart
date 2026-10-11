import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_events.g.dart';

/// Fired by the network layer when the server ended the session (refresh
/// rejected, account deactivated) — from whatever request happened to notice.
///
/// It lives in `core/` so the HTTP client doesn't depend on the auth feature;
/// `AuthController` listens to it and drops the current user, and the router
/// follows the user to /login. The value is a counter: every signal is a new
/// state, so listeners always hear it.
@Riverpod(keepAlive: true)
class SessionEnded extends _$SessionEnded {
  @override
  int build() => 0;

  void signal() => state++;
}

/// Fired by the network layer when a business endpoint answered **403**: the
/// role's permissions may have changed since `/auth/me` last described them
/// (a Super Admin took one away). The auth feature listens, and re-reads
/// `/auth/me` once the burst is over (see `PermissionRefresher`). Same
/// counter shape as [SessionEnded], for the same reason.
@Riverpod(keepAlive: true)
class PermissionDenied extends _$PermissionDenied {
  @override
  int build() => 0;

  void signal() => state++;
}
