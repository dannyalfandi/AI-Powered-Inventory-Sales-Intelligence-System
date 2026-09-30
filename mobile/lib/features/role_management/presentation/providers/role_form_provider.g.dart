// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Backs the role form and the permission editor. `roleId == null` → create
/// mode (state is `null`); otherwise the role from GET /api/v1/roles/:id.

@ProviderFor(RoleForm)
final roleFormProvider = RoleFormFamily._();

/// Backs the role form and the permission editor. `roleId == null` → create
/// mode (state is `null`); otherwise the role from GET /api/v1/roles/:id.
final class RoleFormProvider extends $AsyncNotifierProvider<RoleForm, Role?> {
  /// Backs the role form and the permission editor. `roleId == null` → create
  /// mode (state is `null`); otherwise the role from GET /api/v1/roles/:id.
  RoleFormProvider._({
    required RoleFormFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'roleFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roleFormHash();

  @override
  String toString() {
    return r'roleFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RoleForm create() => RoleForm();

  @override
  bool operator ==(Object other) {
    return other is RoleFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roleFormHash() => r'd29be3afae0906285ab974bbe10c2d042de11de3';

/// Backs the role form and the permission editor. `roleId == null` → create
/// mode (state is `null`); otherwise the role from GET /api/v1/roles/:id.

final class RoleFormFamily extends $Family
    with
        $ClassFamilyOverride<
          RoleForm,
          AsyncValue<Role?>,
          Role?,
          FutureOr<Role?>,
          int?
        > {
  RoleFormFamily._()
    : super(
        retry: null,
        name: r'roleFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Backs the role form and the permission editor. `roleId == null` → create
  /// mode (state is `null`); otherwise the role from GET /api/v1/roles/:id.

  RoleFormProvider call(int? roleId) =>
      RoleFormProvider._(argument: roleId, from: this);

  @override
  String toString() => r'roleFormProvider';
}

/// Backs the role form and the permission editor. `roleId == null` → create
/// mode (state is `null`); otherwise the role from GET /api/v1/roles/:id.

abstract class _$RoleForm extends $AsyncNotifier<Role?> {
  late final _$args = ref.$arg as int?;
  int? get roleId => _$args;

  FutureOr<Role?> build(int? roleId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Role?>, Role?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Role?>, Role?>,
              AsyncValue<Role?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
