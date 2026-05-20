import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/settings_model.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/data/prefs/settings_store.dart';
import 'package:rectify/data/secure/secure_key_store.dart';

/// Repository contract for app settings + "Delete all data"
/// (`docs/implementation-plan.md` §8.5 / §9.5).
abstract class SettingsRepository {
  Future<SettingsModel> read();

  Future<void> setDemoModeDefault({required bool value});
  Future<void> setTimeFormat(TimeFormat value);
  Future<void> setOnboardingDone({required bool value});

  /// Save the user's Pro / Developer key (kept in secure storage),
  /// and update the visible "key configured" flag in settings.
  Future<void> setProApiKey(String key);

  Future<void> clearProApiKey();

  /// Wipe Drift + shared_preferences + secure storage (§8.5).
  Future<Result<void, AppFailure>> deleteAllData();
}

class DefaultSettingsRepository implements SettingsRepository {
  DefaultSettingsRepository({
    required this.prefs,
    required this.secure,
    required this.db,
  });

  final SettingsStore prefs;
  final SecureKeyStore secure;
  final AppDatabase db;

  @override
  Future<SettingsModel> read() => prefs.read();

  @override
  Future<void> setDemoModeDefault({required bool value}) =>
      prefs.setDemoModeDefault(value: value);

  @override
  Future<void> setTimeFormat(TimeFormat value) => prefs.setTimeFormat(value);

  @override
  Future<void> setOnboardingDone({required bool value}) =>
      prefs.setOnboardingDone(value: value);

  @override
  Future<void> setProApiKey(String key) async {
    await secure.writeProApiKey(key);
    await prefs.setProApiKeyConfigured(value: true);
  }

  @override
  Future<void> clearProApiKey() async {
    await secure.clearProApiKey();
    await prefs.setProApiKeyConfigured(value: false);
  }

  @override
  Future<Result<void, AppFailure>> deleteAllData() async {
    try {
      await db.calculationsDao.deleteAll();
      await prefs.deleteAll();
      await secure.deleteAll();
      return const Result<void, AppFailure>.ok(null);
    } on Object catch (cause) {
      return Result.err(StorageFailure(cause));
    }
  }
}
