import '../../auth/domain/entities/auth_user.dart';
import '../../role_management/domain/entities/role.dart';
import 'entities/managed_user.dart';

/// The app's copy of the backend's "only what you hold" rule
/// (`backend/internal/service/grant_scope.go`), used only to decide what to
/// *offer*: the backend enforces it on every request (403).
///
/// A Super Admin covers every role. Anyone else covers a role exactly when
/// it isn't the system role and every one of its permissions is in their own
/// [AuthUser.permissions]. That one definition ([_covers]) is behind both
/// functions below.
bool _covers(AuthUser me, Role role) =>
    me.role.isSystem || (!role.isSystem && role.permissions.every(me.permissions.contains));

/// Whether [me] may give [role] to a user (create, or change `role_id`).
bool canGrantRole(AuthUser me, Role role) => _covers(me, role);

/// What the app knows about [me] changing or deleting a user.
enum ManageAccess {
  /// Within scope: offer edit and delete (subject to the usual permissions
  /// and the self rules).
  allowed,

  /// Out of scope: the backend would answer 403, so don't offer it.
  denied,

  /// The target role's permissions aren't known (the role list isn't loaded,
  /// or the caller can't read it). Offer the actions; the backend decides.
  unknown,
}

/// Whether [me] may change (any field, password included) or delete
/// [target].
///
/// [rolesById] is the role list (GET /roles) by id, or null when it isn't
/// available. It is needed because the role embedded in a user carries no
/// usable permissions. A Super Admin target is recognised without it, from
/// the embedded `is_system`.
///
/// Your own account is always [ManageAccess.allowed] here: you may edit your
/// name, email and password, while the separate self rules keep your role,
/// your active switch and deleting yourself locked.
ManageAccess canManageUser(AuthUser me, ManagedUser target, Map<int, Role>? rolesById) {
  if (me.role.isSystem || target.id == me.id) return ManageAccess.allowed;
  if (target.roleIsSystem) return ManageAccess.denied;
  final role = rolesById?[target.roleId];
  if (role == null) return ManageAccess.unknown;
  return _covers(me, role) ? ManageAccess.allowed : ManageAccess.denied;
}
