import 'package:rectify/data/models/settings_model.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistence wrapper for [SettingsModel]
/// (`docs/implementation-plan.md` §8.1).
///
/// Reads field-by-field so a future addition is backwards-compatible
/// without a migration. Stores no secrets — see `SecureKeyStore`.
class SettingsStore {
  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kDemoModeDefault = 'settings.demo_mode_default';
  static const _kTimeFormat = 'settings.time_format';
  static const _kOnboardingDone = 'settings.onboarding_done';
  static const _kProApiKeyConfigured = 'settings.pro_api_key_configured';

  Future<SettingsModel> read() async => readSync();

  /// Synchronous read for code paths that need the current value
  /// without an `await` — e.g. the Riverpod settings controller's
  /// initial `build()` and the GoRouter onboarding-gate `redirect`.
  /// Safe because [SharedPreferences] caches values in memory.
  SettingsModel readSync() {
    return SettingsModel(
      demoModeDefault: _prefs.getBool(_kDemoModeDefault) ?? false,
      timeFormat: TimeFormat.fromTag(
        _prefs.getString(_kTimeFormat) ?? TimeFormat.h12.tag,
      ),
      onboardingDone: _prefs.getBool(_kOnboardingDone) ?? false,
      proApiKeyConfigured: _prefs.getBool(_kProApiKeyConfigured) ?? false,
    );
  }

  Future<void> write(SettingsModel settings) async {
    await _prefs.setBool(_kDemoModeDefault, settings.demoModeDefault);
    await _prefs.setString(_kTimeFormat, settings.timeFormat.tag);
    await _prefs.setBool(_kOnboardingDone, settings.onboardingDone);
    await _prefs.setBool(
      _kProApiKeyConfigured,
      settings.proApiKeyConfigured,
    );
  }

  Future<void> setDemoModeDefault({required bool value}) =>
      _prefs.setBool(_kDemoModeDefault, value);

  Future<void> setTimeFormat(TimeFormat value) =>
      _prefs.setString(_kTimeFormat, value.tag);

  Future<void> setOnboardingDone({required bool value}) =>
      _prefs.setBool(_kOnboardingDone, value);

  Future<void> setProApiKeyConfigured({required bool value}) =>
      _prefs.setBool(_kProApiKeyConfigured, value);

  /// Wipe every settings key. Used by "Delete all data" (§8.5).
  Future<void> deleteAll() async {
    await _prefs.remove(_kDemoModeDefault);
    await _prefs.remove(_kTimeFormat);
    await _prefs.remove(_kOnboardingDone);
    await _prefs.remove(_kProApiKeyConfigured);
  }
}
