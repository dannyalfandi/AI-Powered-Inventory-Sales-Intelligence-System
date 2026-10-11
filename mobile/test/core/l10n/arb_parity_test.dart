import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Both ARB files carry the same keys, and each message uses the same
// placeholders in both languages — the same check the Go and Python i18n
// catalogs have. English is the template; a key missing from app_id.arb
// would silently fall back to English instead of failing anywhere else.

Map<String, String> _messages(String file) {
  final json = jsonDecode(File('lib/l10n/$file').readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final e in json.entries)
      if (!e.key.startsWith('@')) e.key: e.value as String,
  };
}

/// Placeholder names used by a message, ICU plural/select included
/// (`{count, plural, …}` → count; `{name}` → name).
Set<String> _placeholders(String message) =>
    RegExp(r'\{(\w+)[},]').allMatches(message).map((m) => m.group(1)!).toSet();

void main() {
  final en = _messages('app_en.arb');
  final id = _messages('app_id.arb');

  test('the same keys in English and Indonesian', () {
    expect(id.keys.toSet().difference(en.keys.toSet()), isEmpty, reason: 'only in app_id.arb');
    expect(en.keys.toSet().difference(id.keys.toSet()), isEmpty, reason: 'missing from app_id.arb');
  });

  test('every message uses the same placeholders in both languages', () {
    final mismatched = [
      for (final key in en.keys)
        if (id.containsKey(key) && !_setEquals(_placeholders(en[key]!), _placeholders(id[key]!))) key,
    ];
    expect(mismatched, isEmpty);
  });

  test('the user-count label stays neutral: it counts deleted and inactive users too', () {
    // user_count includes them (backend FK users.role_id ON DELETE RESTRICT),
    // so the label must not say "active".
    for (final message in [en['roleUserCount']!, id['roleUserCount']!]) {
      expect(message.toLowerCase(), isNot(contains('active')));
      expect(message.toLowerCase(), isNot(contains('aktif')));
    }
  });
}

bool _setEquals(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);
