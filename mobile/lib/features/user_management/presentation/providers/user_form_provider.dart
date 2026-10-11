import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/managed_user.dart';
import 'user_list_provider.dart';
import 'user_providers.dart';

part 'user_form_provider.g.dart';

/// What the edit form holds besides the user: an optional new password.
typedef UserEdit = ({String email, String name, String newPassword, int? roleId, bool isActive});

/// Backs the create/edit form. `userId == null` → create mode (state null).
@riverpod
class UserForm extends _$UserForm {
  @override
  Future<ManagedUser?> build(int? userId) async {
    if (userId == null) return null;
    return ref.watch(getUserUseCaseProvider)(userId);
  }

  Future<ManagedUser> create(UserInput input) async {
    final saved = await ref.read(createUserUseCaseProvider)(input);
    ref.invalidate(userListProvider);
    if (ref.mounted) state = AsyncData(saved);
    return saved;
  }

  /// Sends only what changed (PATCH). An empty new password means "keep".
  /// Throws `Failure`: 422 per field, 409 (self rules, duplicate email),
  /// 403 (a Super Admin account or role, for a non-Super-Admin).
  Future<ManagedUser> saveEdit(UserEdit edit) async {
    final existing = state.value!;
    final email = edit.email.trim().toLowerCase();
    final name = edit.name.trim();
    final patch = UserPatch(
      email: email != existing.email ? email : null,
      name: name != existing.name ? name : null,
      password: edit.newPassword.isEmpty ? null : edit.newPassword,
      roleId: edit.roleId != existing.roleId ? edit.roleId : null,
      isActive: edit.isActive != existing.isActive ? edit.isActive : null,
    );
    if (patch.isEmpty) return existing;
    final saved = await ref.read(updateUserUseCaseProvider)(existing.id, patch);
    ref.invalidate(userListProvider);
    if (ref.mounted) state = AsyncData(saved);
    return saved;
  }
}
