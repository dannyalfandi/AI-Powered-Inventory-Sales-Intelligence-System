// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current search text (name or email). [UserList] watches it.

@ProviderFor(UserSearchQuery)
final userSearchQueryProvider = UserSearchQueryProvider._();

/// Current search text (name or email). [UserList] watches it.
final class UserSearchQueryProvider
    extends $NotifierProvider<UserSearchQuery, String> {
  /// Current search text (name or email). [UserList] watches it.
  UserSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSearchQueryHash();

  @$internal
  @override
  UserSearchQuery create() => UserSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$userSearchQueryHash() => r'd4bb679e7a68ebb3c4019a476a0382eb5df99df9';

/// Current search text (name or email). [UserList] watches it.

abstract class _$UserSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(UserList)
final userListProvider = UserListProvider._();

final class UserListProvider
    extends $AsyncNotifierProvider<UserList, PagedState<ManagedUser>> {
  UserListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userListHash();

  @$internal
  @override
  UserList create() => UserList();
}

String _$userListHash() => r'edc04d6c2722ca00b2af2d4fff3e33311bf9f684';

abstract class _$UserList extends $AsyncNotifier<PagedState<ManagedUser>> {
  FutureOr<PagedState<ManagedUser>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PagedState<ManagedUser>>,
              PagedState<ManagedUser>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<ManagedUser>>,
                PagedState<ManagedUser>
              >,
              AsyncValue<PagedState<ManagedUser>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
