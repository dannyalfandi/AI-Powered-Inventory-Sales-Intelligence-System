import '../../../../core/pagination/paged.dart';
import '../entities/managed_user.dart';

/// User accounts. Every method throws `Failure`.
abstract interface class UserRepository {
  Future<PageResult<ManagedUser>> getUsers({required int page, required int pageSize, String search = ''});

  Future<ManagedUser> getUser(int id);

  Future<ManagedUser> createUser(UserInput input);

  Future<ManagedUser> updateUser(int id, UserPatch patch);

  /// Soft delete + deactivate + revoke the user's sessions (backend).
  Future<void> deleteUser(int id);
}
