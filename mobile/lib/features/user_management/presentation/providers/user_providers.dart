import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/update_user.dart';

part 'user_providers.g.dart';

// Dependency graph for user management. Tests override userRepositoryProvider.

@Riverpod(keepAlive: true)
UserRemoteDataSource userRemoteDataSource(Ref ref) => UserRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) => UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetUsers getUsersUseCase(Ref ref) => GetUsers(ref.watch(userRepositoryProvider));

@Riverpod(keepAlive: true)
GetUser getUserUseCase(Ref ref) => GetUser(ref.watch(userRepositoryProvider));

@Riverpod(keepAlive: true)
CreateUser createUserUseCase(Ref ref) => CreateUser(ref.watch(userRepositoryProvider));

@Riverpod(keepAlive: true)
UpdateUser updateUserUseCase(Ref ref) => UpdateUser(ref.watch(userRepositoryProvider));

@Riverpod(keepAlive: true)
DeleteUser deleteUserUseCase(Ref ref) => DeleteUser(ref.watch(userRepositoryProvider));
