import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/data/prefs/settings_store.dart';
import 'package:rectify/data/repos/settings_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SettingsStore prefs;
  late InMemorySecureKeyStore secure;
  late DefaultSettingsRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final sharedPrefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    prefs = SettingsStore(sharedPrefs);
    secure = InMemorySecureKeyStore();
    repo = DefaultSettingsRepository(prefs: prefs, secure: secure, db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DefaultSettingsRepository', () {
    test(
      'setProApiKey stores the key in secure storage and updates the flag',
      () async {
        await repo.setProApiKey('user-key-1234');

        expect(await secure.readProApiKey(), 'user-key-1234');
        final settings = await repo.read();
        expect(settings.proApiKeyConfigured, isTrue);
      },
    );

    test('clearProApiKey wipes the secure entry and resets the flag', () async {
      await repo.setProApiKey('user-key-1234');
      await repo.clearProApiKey();

      expect(await secure.readProApiKey(), isNull);
      final settings = await repo.read();
      expect(settings.proApiKeyConfigured, isFalse);
    });

    test('setTimeFormat persists the new format', () async {
      await repo.setTimeFormat(TimeFormat.h24);
      final settings = await repo.read();
      expect(settings.timeFormat, TimeFormat.h24);
    });

    test('deleteAllData clears prefs, secure storage, and DB tables', () async {
      await repo.setProApiKey('user-key');
      await repo.setOnboardingDone(value: true);
      await repo.setDemoModeDefault(value: true);

      final wipe = await repo.deleteAllData();
      expect(wipe.isOk, isTrue);

      expect(await secure.readProApiKey(), isNull);
      final settings = await repo.read();
      expect(settings.proApiKeyConfigured, isFalse);
      expect(settings.onboardingDone, isFalse);
      expect(settings.demoModeDefault, isFalse);
    });
  });
}
