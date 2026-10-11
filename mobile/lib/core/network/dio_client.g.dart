// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single shared Dio instance for the whole app.
///
/// It watches the language: the backend localizes its messages from
/// `Accept-Language`, so switching language in Settings must change what the
/// server writes too, not only the app's own labels.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Single shared Dio instance for the whole app.
///
/// It watches the language: the backend localizes its messages from
/// `Accept-Language`, so switching language in Settings must change what the
/// server writes too, not only the app's own labels.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Single shared Dio instance for the whole app.
  ///
  /// It watches the language: the backend localizes its messages from
  /// `Accept-Language`, so switching language in Settings must change what the
  /// server writes too, not only the app's own labels.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'6f1ed937eaa77f7cc5f2e7250c2c5f9fcc7112e9';

/// The session's tokens. `main()` overrides this with a [SecureTokenStore]
/// loaded before the first frame; the in-memory default is what tests get.

@ProviderFor(tokenStore)
final tokenStoreProvider = TokenStoreProvider._();

/// The session's tokens. `main()` overrides this with a [SecureTokenStore]
/// loaded before the first frame; the in-memory default is what tests get.

final class TokenStoreProvider
    extends $FunctionalProvider<TokenStore, TokenStore, TokenStore>
    with $Provider<TokenStore> {
  /// The session's tokens. `main()` overrides this with a [SecureTokenStore]
  /// loaded before the first frame; the in-memory default is what tests get.
  TokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStoreHash();

  @$internal
  @override
  $ProviderElement<TokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStore create(Ref ref) {
    return tokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStore>(value),
    );
  }
}

String _$tokenStoreHash() => r'a1690dabba9c7b113a1394f42cd480e908bc5787';
