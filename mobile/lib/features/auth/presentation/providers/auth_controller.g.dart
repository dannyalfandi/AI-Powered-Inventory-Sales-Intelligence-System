// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Who is logged in: `AsyncData(user)`, `AsyncData(null)` when nobody is,
/// and `AsyncLoading` only while the stored session is checked at start-up.
///
/// The router follows this state (see `authRedirect`): no user → /login,
/// a user → the app. Nothing else navigates on login or logout.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Who is logged in: `AsyncData(user)`, `AsyncData(null)` when nobody is,
/// and `AsyncLoading` only while the stored session is checked at start-up.
///
/// The router follows this state (see `authRedirect`): no user → /login,
/// a user → the app. Nothing else navigates on login or logout.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, AuthUser?> {
  /// Who is logged in: `AsyncData(user)`, `AsyncData(null)` when nobody is,
  /// and `AsyncLoading` only while the stored session is checked at start-up.
  ///
  /// The router follows this state (see `authRedirect`): no user → /login,
  /// a user → the app. Nothing else navigates on login or logout.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'0436df1342782abf02bda99de29e1cff002503d9';

/// Who is logged in: `AsyncData(user)`, `AsyncData(null)` when nobody is,
/// and `AsyncLoading` only while the stored session is checked at start-up.
///
/// The router follows this state (see `authRedirect`): no user → /login,
/// a user → the app. Nothing else navigates on login or logout.

abstract class _$AuthController extends $AsyncNotifier<AuthUser?> {
  FutureOr<AuthUser?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthUser?>, AuthUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthUser?>, AuthUser?>,
              AsyncValue<AuthUser?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The logged-in user, or null. What the UI reads; tests override it.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// The logged-in user, or null. What the UI reads; tests override it.

final class CurrentUserProvider
    extends $FunctionalProvider<AuthUser?, AuthUser?, AuthUser?>
    with $Provider<AuthUser?> {
  /// The logged-in user, or null. What the UI reads; tests override it.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<AuthUser?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthUser? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUser?>(value),
    );
  }
}

String _$currentUserHash() => r'665792019bc5ea6e25bfcd669c7aeddfe780028d';
