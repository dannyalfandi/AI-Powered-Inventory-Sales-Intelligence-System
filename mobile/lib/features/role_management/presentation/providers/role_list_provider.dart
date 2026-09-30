import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/role.dart';
import 'role_providers.dart';

part 'role_list_provider.g.dart';

/// Every role, system role first (the backend's order). Roles are few, so
/// the list loads them all instead of paging.
@riverpod
class RoleList extends _$RoleList {
  @override
  Future<List<Role>> build() => ref.watch(getRolesUseCaseProvider)();

  /// Deletes on the server first, then drops the row. Not optimistic: a 409
  /// ("still linked to users", "system role") is an expected answer, and the
  /// row must simply stay. Rethrows the [Failure] for the UI.
  Future<void> delete(int id) async {
    await ref.read(deleteRoleUseCaseProvider)(id);
    ref.invalidate(roleOptionsProvider);
    final current = state.value;
    if (!ref.mounted || current == null) return;
    state = AsyncData(current.where((r) => r.id != id).toList());
  }
}

/// Every role, for the user form's role picker. Invalidated whenever roles
/// are created, renamed or deleted.
@riverpod
Future<List<Role>> roleOptions(Ref ref) => ref.watch(getRolesUseCaseProvider)();

/// How many users have the role (non-deleted; from GET /users). Only watched
/// by users who hold `users.view` — the call needs it.
@riverpod
Future<int> roleUserCount(Ref ref, int roleId) => ref.watch(countRoleUsersUseCaseProvider)(roleId);

/// The fixed permission catalog, descriptions in the app's language.
@riverpod
Future<List<CatalogPermission>> permissionCatalog(Ref ref) => ref.watch(getPermissionCatalogUseCaseProvider)();

/// User-facing message for a failed role delete. A 409 is quoted as the
/// backend wrote it (already localized): "role 7 is still linked to 2
/// user(s), including deleted ones", or the system-role lock.
String roleDeleteErrorMessage(BuildContext context, Failure failure) {
  final reason = errorMessage(context, failure);
  if (failure is ServerFailure && failure.isConflict) return reason;
  return context.l10n.roleDeleteFailed(reason);
}
