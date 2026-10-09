import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/permissions.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../role_management/domain/entities/role.dart';
import '../../../role_management/presentation/providers/role_list_provider.dart';

part 'user_scope_provider.g.dart';

/// The role list by id, for `canManageUser`, or null while it is unknown:
/// still loading, failed, or not readable by the caller (GET /roles needs
/// one of [Permissions.roleList]; without it the list is never requested, so
/// no 403 is provoked). Null means "unknown": the UI then hides nothing and
/// leaves the decision to the backend.
@riverpod
Map<int, Role>? knownRoles(Ref ref) {
  final me = ref.watch(currentUserProvider);
  if (me == null || !me.canAny(Permissions.roleList)) return null;
  final roles = ref.watch(roleOptionsProvider).value;
  return roles == null ? null : {for (final r in roles) r.id: r};
}
