import '../../../../core/error/guard.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/managed_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_models.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._remote);

  final UserRemoteDataSource _remote;

  @override
  Future<PageResult<ManagedUser>> getUsers({required int page, required int pageSize, String search = ''}) =>
      guardApiCall(() async {
        final (items, meta) = await _remote.fetchUsers(page: page, pageSize: pageSize, search: search);
        return PageResult(
          items: items.map((m) => m.toEntity()).toList(),
          page: meta.page,
          pageSize: meta.pageSize,
          total: meta.total,
        );
      });

  @override
  Future<ManagedUser> getUser(int id) => guardApiCall(() async => (await _remote.fetchUser(id)).toEntity());

  @override
  Future<ManagedUser> createUser(UserInput input) =>
      guardApiCall(() async => (await _remote.createUser(CreateUserRequest.fromEntity(input))).toEntity());

  @override
  Future<ManagedUser> updateUser(int id, UserPatch patch) =>
      guardApiCall(() async => (await _remote.updateUser(id, UpdateUserRequest.fromEntity(patch))).toEntity());

  @override
  Future<void> deleteUser(int id) => guardApiCall(() => _remote.deleteUser(id));
}
