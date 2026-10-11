// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userRemoteDataSource)
final userRemoteDataSourceProvider = UserRemoteDataSourceProvider._();

final class UserRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          UserRemoteDataSource,
          UserRemoteDataSource,
          UserRemoteDataSource
        >
    with $Provider<UserRemoteDataSource> {
  UserRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<UserRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserRemoteDataSource create(Ref ref) {
    return userRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRemoteDataSource>(value),
    );
  }
}

String _$userRemoteDataSourceHash() =>
    r'2e710d84d7ba61b4c9496d8ccb55e1be4187a9cf';

@ProviderFor(userRepository)
final userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'e818d56eae6e9905ea26c8f976bc69b87e6d9a9d';

@ProviderFor(getUsersUseCase)
final getUsersUseCaseProvider = GetUsersUseCaseProvider._();

final class GetUsersUseCaseProvider
    extends $FunctionalProvider<GetUsers, GetUsers, GetUsers>
    with $Provider<GetUsers> {
  GetUsersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUsersUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUsersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUsers> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetUsers create(Ref ref) {
    return getUsersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUsers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUsers>(value),
    );
  }
}

String _$getUsersUseCaseHash() => r'08779461dff54935669e304a05bf2ab92f99fdf3';

@ProviderFor(getUserUseCase)
final getUserUseCaseProvider = GetUserUseCaseProvider._();

final class GetUserUseCaseProvider
    extends $FunctionalProvider<GetUser, GetUser, GetUser>
    with $Provider<GetUser> {
  GetUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetUser create(Ref ref) {
    return getUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUser>(value),
    );
  }
}

String _$getUserUseCaseHash() => r'b746c73a32f425a1cda17d68841c51631adf62e0';

@ProviderFor(createUserUseCase)
final createUserUseCaseProvider = CreateUserUseCaseProvider._();

final class CreateUserUseCaseProvider
    extends $FunctionalProvider<CreateUser, CreateUser, CreateUser>
    with $Provider<CreateUser> {
  CreateUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createUserUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateUser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateUser create(Ref ref) {
    return createUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateUser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateUser>(value),
    );
  }
}

String _$createUserUseCaseHash() => r'aba05cb38b56d6d3a3a2a76f32ec7a42010b4e49';

@ProviderFor(updateUserUseCase)
final updateUserUseCaseProvider = UpdateUserUseCaseProvider._();

final class UpdateUserUseCaseProvider
    extends $FunctionalProvider<UpdateUser, UpdateUser, UpdateUser>
    with $Provider<UpdateUser> {
  UpdateUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateUserUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateUser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateUser create(Ref ref) {
    return updateUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateUser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateUser>(value),
    );
  }
}

String _$updateUserUseCaseHash() => r'ca21df581a1f678caba7933c8398e3f186a6a3c9';

@ProviderFor(deleteUserUseCase)
final deleteUserUseCaseProvider = DeleteUserUseCaseProvider._();

final class DeleteUserUseCaseProvider
    extends $FunctionalProvider<DeleteUser, DeleteUser, DeleteUser>
    with $Provider<DeleteUser> {
  DeleteUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteUserUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteUser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteUser create(Ref ref) {
    return deleteUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteUser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteUser>(value),
    );
  }
}

String _$deleteUserUseCaseHash() => r'05a045054aff98fd41273d0bee06b0cb520afa2f';
