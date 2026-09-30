import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/validation/field_issue.dart';

part 'auth_user.freezed.dart';

/// The logged-in user as `GET /api/v1/auth/me` describes it: who they are,
/// their one role, and the permission keys that role grants right now.
@freezed
abstract class AuthUser with _$AuthUser {
  const AuthUser._();

  const factory AuthUser({
    required int id,
    required String email,
    required String name,
    required AuthRole role,
    required Set<String> permissions,
  }) = _AuthUser;

  /// Whether the UI should offer an action needing [permission].
  ///
  /// A system role (Super Admin) passes every check on the backend, so it
  /// passes here too, even for a key the app's list doesn't know yet. The
  /// backend still enforces every request; this only decides what is shown.
  bool can(String permission) => role.isSystem || permissions.contains(permission);

  /// Whether the user holds at least one of [anyOf] — what decides if a whole
  /// area (e.g. role management) has an entry point at all.
  bool canAny(Iterable<String> anyOf) => role.isSystem || anyOf.any(permissions.contains);
}

@freezed
abstract class AuthRole with _$AuthRole {
  const factory AuthRole({required int id, required String name, required bool isSystem}) = _AuthRole;
}

/// Checks on the login form before anything is sent. The backend does its
/// own (and answers 401 for wrong credentials, never saying which part).
abstract final class LoginRules {
  static final _email = RegExp(r'^[^\s@<>]+@[^\s@<>]+\.[^\s@<>]+$');

  static FieldIssue? validateEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return const FieldIssue(FieldIssueKind.emailRequired);
    if (!_email.hasMatch(v)) return const FieldIssue(FieldIssueKind.emailInvalid);
    return null;
  }

  /// Only "not empty": length rules belong to setting a password, and a
  /// login form that rejects an existing password would lock its owner out.
  static FieldIssue? validatePassword(String value) =>
      value.isEmpty ? const FieldIssue(FieldIssueKind.passwordRequired) : null;
}
