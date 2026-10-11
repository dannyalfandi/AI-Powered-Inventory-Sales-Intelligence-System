import 'dart:async';

import 'token_store.dart';

/// How a call to `POST /api/v1/auth/refresh` can end, besides success.
enum RefreshFailure {
  /// The backend answered 401: the refresh token is expired, revoked or
  /// reused. The session is over; only a new login helps.
  rejected,

  /// The request never reached the backend (no connection, connect timeout).
  /// Nothing was rotated, so the same refresh token is still good later.
  notDelivered,

  /// The request was sent but no usable answer came back (receive timeout,
  /// dropped connection, 5xx). The backend may or may not have rotated the
  /// token, and the contract forbids retrying a refresh whose answer was
  /// lost: if it *was* rotated, a retry is a reuse, and the backend would log
  /// the user out on every device. So the app gives up the session instead.
  outcomeUnknown,
}

/// Thrown by [RefreshCall] to say which [RefreshFailure] happened.
class RefreshException implements Exception {
  const RefreshException(this.failure, [this.cause]);

  final RefreshFailure failure;
  final Object? cause;

  @override
  String toString() => 'RefreshException(${failure.name}${cause == null ? '' : ': $cause'})';
}

/// Exchanges a refresh token for a new pair, or throws [RefreshException].
typedef RefreshCall = Future<AuthTokens> Function(String refreshToken);

/// Makes sure the app calls `/auth/refresh` **at most once at a time**
/// (single-flight).
///
/// When the access token expires, every request in flight gets a 401 at about
/// the same moment. Each one asks this class for a usable token; only the
/// first starts a refresh and the rest await that same future. The backend
/// makes this mandatory, not just tidy: a refresh token works once, and
/// sending it a second time looks like theft and ends the user's sessions on
/// every device.
class TokenRefresher {
  TokenRefresher({required this._store, required this._refresh, this._onSessionEnded});

  final TokenStore _store;
  final RefreshCall _refresh;
  final void Function()? _onSessionEnded;

  /// The refresh in progress, shared by every caller that arrives while it
  /// runs. Null when idle.
  Future<String?>? _inFlight;

  /// Whether a refresh is running right now. For tests and diagnostics.
  bool get isRefreshing => _inFlight != null;

  /// Returns an access token to retry with, for a request that got 401
  /// `token_expired` after being sent with [failedAccessToken]; or null when
  /// there is no session to continue.
  ///
  /// Everything up to claiming [_inFlight] is synchronous. That is what makes
  /// this single-flight without a lock: Dart runs one isolate, so no other
  /// caller can run between reading the current token and claiming the
  /// refresh.
  Future<String?> accessTokenAfterExpiry(String failedAccessToken) {
    final current = _store.current;
    if (current == null) {
      return Future.value(null); // logged out meanwhile
    }
    if (current.accessToken != failedAccessToken) {
      // A late 401: this request was sent with a token that has already
      // been replaced (by a refresh that finished, or by a new login).
      // Refreshing again would spend the new refresh token for nothing.
      return Future.value(current.accessToken);
    }
    return _inFlight ??= _run(current.refreshToken);
  }

  Future<String?> _run(String refreshToken) async {
    try {
      final tokens = await _refresh(refreshToken);
      await _store.save(tokens);
      return tokens.accessToken;
    } on RefreshException catch (e) {
      if (e.failure == RefreshFailure.notDelivered) {
        // Nothing changed on the server; keep the session. The waiting
        // requests fail as network errors, and the next 401 may try again
        // with the same, still valid, refresh token.
        rethrow;
      }
      await _endSession();
      return null;
    } finally {
      // Cleared only after the new tokens are stored, so a 401 arriving from
      // here on sees them and takes the "late 401" path above.
      _inFlight = null;
    }
  }

  /// Ends the local session because the server said it is over (401 on a
  /// request that carried a token, other than an expired access token).
  Future<void> sessionRejected() => _endSession();

  Future<void> _endSession() async {
    if (_store.current == null) {
      return; // already ended: notify once, not once per failed request
    }
    await _store.clear();
    _onSessionEnded?.call();
  }
}
