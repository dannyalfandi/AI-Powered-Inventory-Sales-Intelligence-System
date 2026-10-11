import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';

part 'auth_providers.g.dart';

// Dependency graph for the auth feature. Tests override authRepositoryProvider
// (or a usecase provider) with a mock.

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) => AuthRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider), ref.watch(tokenStoreProvider));

@Riverpod(keepAlive: true)
Login loginUseCase(Ref ref) => Login(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
GetCurrentUser getCurrentUserUseCase(Ref ref) => GetCurrentUser(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
Logout logoutUseCase(Ref ref) => Logout(ref.watch(authRepositoryProvider));
