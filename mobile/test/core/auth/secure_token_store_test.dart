import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/secure_token_store.dart';
import 'package:inventory_intel/core/auth/token_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();

  test('loads the stored pair at start-up', () async {
    FlutterSecureStorage.setMockInitialValues({'auth.access_token': 'a0', 'auth.refresh_token': 'r0'});

    final store = await SecureTokenStore.load(storage);

    expect(store.current?.accessToken, 'a0');
    expect(store.current?.refreshToken, 'r0');
  });

  test('nothing stored, or only half a pair: no session', () async {
    FlutterSecureStorage.setMockInitialValues({});
    expect((await SecureTokenStore.load(storage)).current, isNull);

    FlutterSecureStorage.setMockInitialValues({'auth.access_token': 'a0'});
    expect((await SecureTokenStore.load(storage)).current, isNull);
  });

  test('save: `current` changes synchronously, before storage is written', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final store = await SecureTokenStore.load(storage);

    final writing = store.save(const AuthTokens(accessToken: 'a1', refreshToken: 'r1'));
    // Not awaited yet: the single-flight refresh relies on this.
    expect(store.current?.accessToken, 'a1');
    await writing;

    expect(await storage.read(key: 'auth.access_token'), 'a1');
    expect(await storage.read(key: 'auth.refresh_token'), 'r1');
    // A fresh start sees what was saved.
    expect((await SecureTokenStore.load(storage)).current?.refreshToken, 'r1');
  });

  test('clear: forgotten in memory at once, and in storage', () async {
    FlutterSecureStorage.setMockInitialValues({'auth.access_token': 'a0', 'auth.refresh_token': 'r0'});
    final store = await SecureTokenStore.load(storage);

    final clearing = store.clear();
    expect(store.current, isNull);
    await clearing;

    expect(await storage.read(key: 'auth.refresh_token'), isNull);
    expect((await SecureTokenStore.load(storage)).current, isNull);
  });
}
