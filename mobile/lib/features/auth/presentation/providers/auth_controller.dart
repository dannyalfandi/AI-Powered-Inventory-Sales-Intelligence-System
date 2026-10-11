import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/session_events.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_providers.dart';

part 'auth_controller.g.dart';

/// Who is logged in: `AsyncData(user)`, `AsyncData(null)` when nobody is,
/// and `AsyncLoading` only while the stored session is checked at start-up.
///
/// The router follows this state (see `authRedirect`): no user → /login,
/// a user → the app. Nothing else navigates on login or logout.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthUser?> build() async {
    // The server ended the session, noticed by any request anywhere in the
    // app (the network layer already cleared the tokens).
    ref.listen(sessionEndedProvider, (_, _) {
      if (state.value != null) state = const AsyncData(null);
    });

    // Start-up: stored tokens are only a claim. /auth/me checks they still
    // work (refreshing an expired access token on the way), and brings the
    // role and permissions as they are *now*.
    try {
      return await ref.read(getCurrentUserUseCaseProvider)();
    } on Failure {
      // Expired, revoked, deactivated, or the server is unreachable: go to
      // the login screen. Only an auth failure has already cleared the
      // tokens (in the network layer); after a network failure they stay,
      // and the next start tries them again.
      return null;
    }
  }

  /// Logs in and makes [user] the current user. Throws `Failure` for the
  /// form to show (401 `invalid_credentials`, 422, network); on failure the
  /// state is left as it was (logged out).
  Future<void> login({required String email, required String password}) async {
    final user = await ref.read(loginUseCaseProvider)(email: email, password: password);
    state = AsyncData(user);
  }

  /// Re-reads `/auth/me` so a role whose permissions changed on the server
  /// takes effect without logging in again: tabs, sections and buttons follow
  /// the new state, and the router moves off a tab that is no longer allowed.
  ///
  /// The call goes through the same client as everything else, so an expired
  /// access token is refreshed by the shared single-flight refresher on the
  /// way. Failures keep the current state: offline or a 5xx changes nothing,
  /// and a 401 has already ended the session through the network layer
  /// ([sessionEndedProvider]). Use [PermissionRefresher], which throttles and
  /// debounces, rather than calling this directly.
  Future<void> refreshPermissions() async {
    final before = state.value;
    if (before == null) return;
    final AuthUser? fresh;
    try {
      fresh = await ref.read(getCurrentUserUseCaseProvider)();
    } on Failure {
      return;
    }
    // No tokens (null), or logged out / someone else logged in while the
    // call was in flight: this answer is about a session that is gone.
    final now = state.value;
    if (!ref.mounted || fresh == null || now == null || now.id != fresh.id) return;
    // Unchanged → no new state, so nothing rebuilds and the router stays put.
    if (fresh != now) state = AsyncData(fresh);
  }

  /// Revokes the session on the server (best effort), forgets the tokens,
  /// and clears the user. Works offline.
  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider)();
    state = const AsyncData(null);
  }
}

/// The logged-in user, or null. What the UI reads; tests override it.
@Riverpod(keepAlive: true)
AuthUser? currentUser(Ref ref) => ref.watch(authControllerProvider).value;

/// Permission checks for widgets: `if (ref.hasPermission(Permissions.productsDelete)) ...`.
///
/// The rule for the UI is to **hide** what the user can't do rather than show
/// it disabled: a button that never works, with no reason given, only
/// confuses. The backend enforces every permission regardless (403).
extension PermissionRef on WidgetRef {
  bool hasPermission(String permission) => watch(currentUserProvider)?.can(permission) ?? false;

  /// At least one of [anyOf], e.g. `ref.hasAnyPermission(Permissions.roleManagement)`.
  bool hasAnyPermission(Iterable<String> anyOf) => watch(currentUserProvider)?.canAny(anyOf) ?? false;
}
