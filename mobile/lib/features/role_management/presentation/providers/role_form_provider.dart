import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/role.dart';
import 'role_list_provider.dart';
import 'role_providers.dart';

part 'role_form_provider.g.dart';

/// Backs the role form and the permission editor. `roleId == null` → create
/// mode (state is `null`); otherwise the role from GET /api/v1/roles/:id.
@riverpod
class RoleForm extends _$RoleForm {
  @override
  Future<Role?> build(int? roleId) async {
    if (roleId == null) return null;
    return ref.watch(getRoleUseCaseProvider)(roleId);
  }

  /// Creates, or updates with only the fields that changed. Throws `Failure`
  /// (422 on `name`, 409 duplicate name or system role) for the form.
  Future<Role> save(RoleInput input) async {
    final id = roleId;
    final data = input.trimmed();
    final Role saved;
    if (id == null) {
      saved = await ref.read(createRoleUseCaseProvider)(data);
    } else {
      final existing = state.value;
      final patch = existing == null
          ? RolePatch(name: data.name, description: data.description)
          : RolePatch(
              name: data.name != existing.name ? data.name : null,
              description: data.description != existing.description ? data.description : null,
            );
      saved = patch.isEmpty ? existing! : await ref.read(updateRoleUseCaseProvider)(id, patch);
    }
    _refreshLists();
    if (ref.mounted) state = AsyncData(saved);
    return saved;
  }

  /// Replaces the role's permissions with exactly [keys] — the whole desired
  /// set, not what changed (PUT /roles/:id/permissions replaces the list).
  Future<Role> savePermissions(Iterable<String> keys) async {
    final saved = await ref.read(setRolePermissionsUseCaseProvider)(roleId!, keys);
    _refreshLists();
    if (ref.mounted) state = AsyncData(saved);
    return saved;
  }

  void _refreshLists() {
    ref.invalidate(roleListProvider);
    ref.invalidate(roleOptionsProvider);
  }
}
