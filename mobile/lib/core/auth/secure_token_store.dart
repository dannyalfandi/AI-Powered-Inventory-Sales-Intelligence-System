import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_store.dart';

/// Tokens in platform secure storage (iOS Keychain; on Android, AES-GCM with
/// the key wrapped in the Android Keystore), with an in-memory copy in front.
///
/// The copy is what keeps [current] synchronous, which the single-flight
/// refresh depends on (see [TokenStore]): it is filled once by [load] before
/// the app starts, and every change updates it *before* touching storage, so
/// no reader ever waits on disk or sees a stale pair.
class SecureTokenStore implements TokenStore {
  SecureTokenStore._(this._storage, this._tokens);

  final FlutterSecureStorage _storage;
  AuthTokens? _tokens;

  static const _accessKey = 'auth.access_token';
  static const _refreshKey = 'auth.refresh_token';

  /// The storage options the app uses. On iOS the tokens are readable after
  /// the first unlock (so a background refresh works) and never leave the
  /// device through backups or iCloud Keychain.
  static const defaultStorage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  /// Reads the stored pair. Call before `runApp`, like SharedPreferences, so
  /// the first frame already knows whether there is a session.
  ///
  /// Unreadable storage (Keystore reset, restored backup) means no session:
  /// the user logs in again rather than the app failing to start.
  static Future<SecureTokenStore> load([FlutterSecureStorage storage = defaultStorage]) async {
    AuthTokens? tokens;
    try {
      final access = await storage.read(key: _accessKey);
      final refresh = await storage.read(key: _refreshKey);
      if (access != null && refresh != null) {
        tokens = AuthTokens(accessToken: access, refreshToken: refresh);
      }
    } on Object {
      tokens = null;
    }
    return SecureTokenStore._(storage, tokens);
  }

  @override
  AuthTokens? get current => _tokens;

  @override
  Future<void> save(AuthTokens tokens) async {
    _tokens = tokens; // memory first: visible to the next request at once
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    _tokens = null;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
