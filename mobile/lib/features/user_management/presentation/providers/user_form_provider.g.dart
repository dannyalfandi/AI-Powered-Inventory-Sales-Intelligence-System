// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Backs the create/edit form. `userId == null` → create mode (state null).

@ProviderFor(UserForm)
final userFormProvider = UserFormFamily._();

/// Backs the create/edit form. `userId == null` → create mode (state null).
final class UserFormProvider
    extends $AsyncNotifierProvider<UserForm, ManagedUser?> {
  /// Backs the create/edit form. `userId == null` → create mode (state null).
  UserFormProvider._({
    required UserFormFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'userFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userFormHash();

  @override
  String toString() {
    return r'userFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserForm create() => UserForm();

  @override
  bool operator ==(Object other) {
    return other is UserFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userFormHash() => r'57ff657ff540198e76dc4acfbbf8135a0e14a516';

/// Backs the create/edit form. `userId == null` → create mode (state null).

final class UserFormFamily extends $Family
    with
        $ClassFamilyOverride<
          UserForm,
          AsyncValue<ManagedUser?>,
          ManagedUser?,
          FutureOr<ManagedUser?>,
          int?
        > {
  UserFormFamily._()
    : super(
        retry: null,
        name: r'userFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Backs the create/edit form. `userId == null` → create mode (state null).

  UserFormProvider call(int? userId) =>
      UserFormProvider._(argument: userId, from: this);

  @override
  String toString() => r'userFormProvider';
}

/// Backs the create/edit form. `userId == null` → create mode (state null).

abstract class _$UserForm extends $AsyncNotifier<ManagedUser?> {
  late final _$args = ref.$arg as int?;
  int? get userId => _$args;

  FutureOr<ManagedUser?> build(int? userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ManagedUser?>, ManagedUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ManagedUser?>, ManagedUser?>,
              AsyncValue<ManagedUser?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
