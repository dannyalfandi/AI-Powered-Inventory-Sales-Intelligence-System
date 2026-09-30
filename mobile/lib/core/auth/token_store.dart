/// The pair the backend issues on login and on every refresh.
///
/// The access token lives 15 minutes; the refresh token 7 days, and works
/// exactly **once**: the backend rotates it on every refresh and treats a
/// second use as theft (it then revokes every session of the user). That rule
/// is why the app funnels refreshes through `TokenRefresher`.
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

/// Holds the current [AuthTokens].
///
/// [current] is synchronous on purpose: `TokenRefresher` must compare "the
/// token my request was sent with" against "the token we have now" and claim
/// the refresh in the same synchronous step. An `await` between the two would
/// let two requests both see the old token and both refresh with a refresh
/// token that one of them has just used up.
abstract interface class TokenStore {
  /// The tokens in use, or null when logged out.
  AuthTokens? get current;

  /// Replaces the tokens. [current] returns them as soon as this is called;
  /// the future only covers persistence.
  Future<void> save(AuthTokens tokens);

  /// Forgets the tokens (logout, or the session ended on the server).
  Future<void> clear();
}

/// Keeps the tokens in memory only: a restart logs the user out.
///
/// The app runs on `SecureTokenStore`; this is the default of
/// `tokenStoreProvider` for tests and anything that never calls `main()`.
class MemoryTokenStore implements TokenStore {
  MemoryTokenStore([this._tokens]);

  AuthTokens? _tokens;

  @override
  AuthTokens? get current => _tokens;

  @override
  Future<void> save(AuthTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}
