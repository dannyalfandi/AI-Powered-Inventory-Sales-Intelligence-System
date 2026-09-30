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
