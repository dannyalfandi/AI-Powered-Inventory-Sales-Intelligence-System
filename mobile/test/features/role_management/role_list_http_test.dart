import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/role_management/data/datasources/role_remote_data_source.dart';
import 'package:inventory_intel/features/role_management/presentation/providers/role_providers.dart';
import 'package:inventory_intel/features/role_management/presentation/screens/role_list_screen.dart';

import '../../helpers/admin_json.dart';
import '../../helpers/auth_fixtures.dart';
import '../../helpers/l10n_harness.dart';

/// Answers every request with [body] and records `METHOD path?query`.
class RecordingBackend implements HttpClientAdapter {
  RecordingBackend(this.body);

  final String body;
  final requests = <String>[];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add('${options.method} ${options.uri.path}${options.uri.hasQuery ? '?${options.uri.query}' : ''}');
    return ResponseBody.fromString(body, 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

// The role list over the real datasource → repository → use case stack,
// answered with the captured GET /roles body: what one screen load costs on
// the wire. Before user_count it was 1 + one GET /users per role.
void main() {
  Future<RecordingBackend> pump(WidgetTester tester, AuthUser user, String body) async {
    final backend = RecordingBackend(body);
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = backend;
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          roleRemoteDataSourceProvider.overrideWithValue(RoleRemoteDataSourceImpl(dio)),
          signedInAs(user),
        ],
        retry: (_, _) => null,
        child: localizedApp(home: const RoleListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return backend;
  }

  for (final (who, user, body) in [
    ('Super Admin', superAdmin, adminGetRoles),
    ('a user manager (users.create, no roles.view)', userWith({Permissions.usersCreate, Permissions.rolesDelete}), managerGetRoles),
  ]) {
    testWidgets('$who: exactly ONE GET /roles, zero GET /users, every count from user_count', (tester) async {
      final backend = await pump(tester, user, body);

      expect(backend.requests, ['GET /api/v1/roles?page=1&page_size=100']);
      expect(backend.requests.where((r) => r.contains('/users')), isEmpty);

      final l10n = l10nOf(tester);
      String subtitle(int id) => tester.widget<Text>(find.byKey(ValueKey('role_subtitle_$id'))).data!;
      expect(subtitle(170), endsWith(l10n.roleUserCount(2)), reason: 'E2E Gudang: one live + one deleted user');
      expect(subtitle(172), endsWith(l10n.roleUserCount(0)));
      expect(subtitle(1), endsWith(l10n.roleUserCount(1)));
    });
  }
}
