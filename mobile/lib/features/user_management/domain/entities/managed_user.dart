import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/validation/field_issue.dart';

part 'managed_user.freezed.dart';

/// A user account as user management sees it (backend model.User). Not the
/// logged-in user — that is `AuthUser` in the auth feature.
@freezed
abstract class ManagedUser with _$ManagedUser {
  const factory ManagedUser({
    required int id,
    required String email,
    required String name,
    required int roleId,
    required String roleName,
    required bool roleIsSystem,
    required bool isActive,
    required DateTime createdAt,
  }) = _ManagedUser;
}

/// Data to create a user (POST /api/v1/users).
@freezed
abstract class UserInput with _$UserInput {
  const UserInput._();

  const factory UserInput({
    required String email,
    required String password,
    required String name,
    required int? roleId,
    @Default(true) bool isActive,
  }) = _UserInput;

  /// Trims the name, and trims + lowercases the email like the backend
  /// stores it. The password is sent exactly as typed.
  UserInput normalized() =>
      copyWith(email: email.trim().toLowerCase(), name: name.trim());
}

/// Partial update (PATCH /api/v1/users/:id): null fields stay unchanged.
/// Every field the backend's UpdateUserInput accepts, password included.
@freezed
abstract class UserPatch with _$UserPatch {
  const UserPatch._();

  const factory UserPatch({String? email, String? password, String? name, int? roleId, bool? isActive}) =
      _UserPatch;

  bool get isEmpty => email == null && password == null && name == null && roleId == null && isActive == null;
}

/// User rules, mirroring backend `validateUserEmail/Name/Password`
/// (user_service.go). Uniqueness and the self/Super-Admin rules are the
/// backend's (409/403); the UI also prevents the self ones up front.
abstract final class UserRules {
  static const nameMaxLength = 255;
  static const emailMaxLength = 255;
  static const passwordMinLength = 8;

  /// bcrypt's input limit, in bytes (backend auth.MaxPasswordBytes).
  static const passwordMaxBytes = 72;

  static final _email = RegExp(r'^[^\s@<>]+@[^\s@<>]+\.[^\s@<>]+$');

  static FieldIssue? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return const FieldIssue(FieldIssueKind.nameRequired);
    if (v.length > nameMaxLength) return const FieldIssue(FieldIssueKind.nameTooLong, max: nameMaxLength);
    return null;
  }

  static FieldIssue? validateEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return const FieldIssue(FieldIssueKind.emailRequired);
    if (v.length > emailMaxLength) return const FieldIssue(FieldIssueKind.emailTooLong, max: emailMaxLength);
    if (!_email.hasMatch(v)) return const FieldIssue(FieldIssueKind.emailInvalid);
    return null;
  }

  /// [required] is true when creating; when editing, empty means "keep".
  static FieldIssue? validatePassword(String value, {required bool required}) {
    if (value.isEmpty) return required ? const FieldIssue(FieldIssueKind.passwordRequired) : null;
    if (value.runes.length < passwordMinLength) {
      return const FieldIssue(FieldIssueKind.passwordTooShort, max: passwordMinLength);
    }
    if (_utf8Length(value) > passwordMaxBytes) {
      return const FieldIssue(FieldIssueKind.passwordTooLong, max: passwordMaxBytes);
    }
    return null;
  }

  static FieldIssue? validateRole(int? roleId) =>
      roleId == null || roleId <= 0 ? const FieldIssue(FieldIssueKind.roleRequired) : null;

  /// UTF-8 byte length without importing dart:convert into the domain.
  static int _utf8Length(String s) {
    var n = 0;
    for (final r in s.runes) {
      n += r < 0x80 ? 1 : r < 0x800 ? 2 : r < 0x10000 ? 3 : 4;
    }
    return n;
  }
}
