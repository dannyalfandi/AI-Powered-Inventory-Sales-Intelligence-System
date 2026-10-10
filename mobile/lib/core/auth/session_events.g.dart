// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fired by the network layer when the server ended the session (refresh
/// rejected, account deactivated) — from whatever request happened to notice.
///
/// It lives in `core/` so the HTTP client doesn't depend on the auth feature;
/// `AuthController` listens to it and drops the current user, and the router
/// follows the user to /login. The value is a counter: every signal is a new
/// state, so listeners always hear it.

@ProviderFor(SessionEnded)
final sessionEndedProvider = SessionEndedProvider._();

/// Fired by the network layer when the server ended the session (refresh
/// rejected, account deactivated) — from whatever request happened to notice.
///
/// It lives in `core/` so the HTTP client doesn't depend on the auth feature;
/// `AuthController` listens to it and drops the current user, and the router
/// follows the user to /login. The value is a counter: every signal is a new
/// state, so listeners always hear it.
final class SessionEndedProvider extends $NotifierProvider<SessionEnded, int> {
  /// Fired by the network layer when the server ended the session (refresh
  /// rejected, account deactivated) — from whatever request happened to notice.
  ///
  /// It lives in `core/` so the HTTP client doesn't depend on the auth feature;
  /// `AuthController` listens to it and drops the current user, and the router
  /// follows the user to /login. The value is a counter: every signal is a new
  /// state, so listeners always hear it.
  SessionEndedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionEndedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionEndedHash();

  @$internal
  @override
  SessionEnded create() => SessionEnded();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$sessionEndedHash() => r'33456dd5ec1bd26c29d911a3274e93df57583a7a';

/// Fired by the network layer when the server ended the session (refresh
/// rejected, account deactivated) — from whatever request happened to notice.
///
/// It lives in `core/` so the HTTP client doesn't depend on the auth feature;
/// `AuthController` listens to it and drops the current user, and the router
/// follows the user to /login. The value is a counter: every signal is a new
/// state, so listeners always hear it.

abstract class _$SessionEnded extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Fired by the network layer when a business endpoint answered **403**: the
/// role's permissions may have changed since `/auth/me` last described them
/// (a Super Admin took one away). The auth feature listens, and re-reads
/// `/auth/me` once the burst is over (see `PermissionRefresher`). Same
/// counter shape as [SessionEnded], for the same reason.

@ProviderFor(PermissionDenied)
final permissionDeniedProvider = PermissionDeniedProvider._();

/// Fired by the network layer when a business endpoint answered **403**: the
/// role's permissions may have changed since `/auth/me` last described them
/// (a Super Admin took one away). The auth feature listens, and re-reads
/// `/auth/me` once the burst is over (see `PermissionRefresher`). Same
/// counter shape as [SessionEnded], for the same reason.
final class PermissionDeniedProvider
    extends $NotifierProvider<PermissionDenied, int> {
  /// Fired by the network layer when a business endpoint answered **403**: the
  /// role's permissions may have changed since `/auth/me` last described them
  /// (a Super Admin took one away). The auth feature listens, and re-reads
  /// `/auth/me` once the burst is over (see `PermissionRefresher`). Same
  /// counter shape as [SessionEnded], for the same reason.
  PermissionDeniedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionDeniedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionDeniedHash();

  @$internal
  @override
  PermissionDenied create() => PermissionDenied();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$permissionDeniedHash() => r'e59e38ce477ffff023bbd277c14221ffa34c70f3';

/// Fired by the network layer when a business endpoint answered **403**: the
/// role's permissions may have changed since `/auth/me` last described them
/// (a Super Admin took one away). The auth feature listens, and re-reads
/// `/auth/me` once the burst is over (see `PermissionRefresher`). Same
/// counter shape as [SessionEnded], for the same reason.

abstract class _$PermissionDenied extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
