import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/data/prefs/settings_store.dart';
import 'package:rectify/data/repos/history_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures/sample_calculation.dart';

/// Phase-6 hard rule: an end-user-supplied Pro / Developer key lives
/// only in [SecureKeyStore]. It must not appear in
/// [SharedPreferences], any Drift column, or any persisted JSON blob
/// (`docs/implementation-plan.md` §9.5 / AC-Demo-7).
void main() {
  const secret = 'KEY-MUST-NOT-LEAK-INTO-PREFS-OR-SQLITE';

  test(
    'SecureKeyStore holds the key; SettingsStore + Drift carry no trace',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final settings = SettingsStore(prefs);
      final secure = InMemorySecureKeyStore();

      await secure.writeProApiKey(secret);
      expect(await secure.readProApiKey(), secret);

      // Sanity: writing the key did not bleed into prefs in any form.
      // Verify by snapshotting every prefs key value pair as JSON.
      final prefsSnapshot = <String, Object?>{
        for (final key in prefs.getKeys()) key: prefs.get(key),
      };
      expect(jsonEncode(prefsSnapshot).contains(secret), isFalse);

      // Touch every public SettingsStore writer; none should accept a
      // raw API key shape, and none should round-trip the secret.
      await settings.setDemoModeDefault(value: true);
      await settings.setOnboardingDone(value: true);
      await settings.setTimeFormat(TimeFormat.h12);
      final after = <String, Object?>{
        for (final key in prefs.getKeys()) key: prefs.get(key),
      };
      expect(jsonEncode(after).contains(secret), isFalse);

      // Drift: save a complete calculation aggregate and re-read it.
      // The rawResponseJson column is the one place a careless API
      // surface could echo the secret; we verify it stays clean.
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final history = DriftHistoryRepository(db);

      final saved = await history.save(sampleRequest(), sampleResult());
      expect(saved.isOk, isTrue);

      final fetched = await history.findById('req-001');
      expect(fetched.isOk, isTrue);
      final value = fetched.valueOrNull!;
      expect(value.result.rawResponseJson, isNull);
      // String-search every visible column for the secret.
      final dump = jsonEncode(<String, dynamic>{
        'label': value.request.label,
        'city': value.request.birthData.birthCity,
        'method': value.result.method,
        'apiCalcId': value.result.apiCalculationId,
        'raw': value.result.rawResponseJson,
      });
      expect(dump.contains(secret), isFalse);
    },
  );
}
