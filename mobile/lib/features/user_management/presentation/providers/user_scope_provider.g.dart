// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_scope_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The role list by id, for `canManageUser`, or null while it is unknown:
/// still loading, failed, or not readable by the caller (GET /roles needs
/// one of [Permissions.roleList]; without it the list is never requested, so
/// no 403 is provoked). Null means "unknown": the UI then hides nothing and
/// leaves the decision to the backend.

@ProviderFor(knownRoles)
final knownRolesProvider = KnownRolesProvider._();

/// The role list by id, for `canManageUser`, or null while it is unknown:
/// still loading, failed, or not readable by the caller (GET /roles needs
/// one of [Permissions.roleList]; without it the list is never requested, so
/// no 403 is provoked). Null means "unknown": the UI then hides nothing and
/// leaves the decision to the backend.

final class KnownRolesProvider
    extends
        $FunctionalProvider<Map<int, Role>?, Map<int, Role>?, Map<int, Role>?>
    with $Provider<Map<int, Role>?> {
  /// The role list by id, for `canManageUser`, or null while it is unknown:
  /// still loading, failed, or not readable by the caller (GET /roles needs
  /// one of [Permissions.roleList]; without it the list is never requested, so
  /// no 403 is provoked). Null means "unknown": the UI then hides nothing and
  /// leaves the decision to the backend.
  KnownRolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knownRolesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knownRolesHash();

  @$internal
  @override
  $ProviderElement<Map<int, Role>?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<int, Role>? create(Ref ref) {
    return knownRoles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, Role>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, Role>?>(value),
    );
  }
}

String _$knownRolesHash() => r'2c3f907f3924159021c67f176eea471037532bd9';
