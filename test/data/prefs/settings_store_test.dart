import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/models/language_preference.dart';
import 'package:rectify/data/models/settings_model.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/data/prefs/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('SettingsStore', () {
    test(
      'read returns initial defaults when nothing has been written',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final store = SettingsStore(prefs);

        final settings = await store.read();
        expect(settings.demoModeDefault, isFalse);
        expect(settings.timeFormat, TimeFormat.h12);
        expect(settings.onboardingDone, isFalse);
        expect(settings.proApiKeyConfigured, isFalse);
        expect(settings.languagePreference, LanguagePreference.auto);
      },
    );

    test(
      'write persists every field and read recovers the same model',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final store = SettingsStore(prefs);

        const settings = SettingsModel(
          demoModeDefault: true,
          timeFormat: TimeFormat.h24,
          onboardingDone: true,
          proApiKeyConfigured: true,
          languagePreference: LanguagePreference.spanish,
        );
        await store.write(settings);

        final recovered = await store.read();
        expect(recovered, settings);
      },
    );

    test('individual setters update the persisted state', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SettingsStore(prefs);

      await store.setDemoModeDefault(value: true);
      await store.setTimeFormat(TimeFormat.h24);
      await store.setOnboardingDone(value: true);
      await store.setLanguagePreference(LanguagePreference.french);

      final settings = await store.read();
      expect(settings.demoModeDefault, isTrue);
      expect(settings.timeFormat, TimeFormat.h24);
      expect(settings.onboardingDone, isTrue);
      expect(settings.languagePreference, LanguagePreference.french);
    });

    test('language preference survives a simulated restart', () async {
      final prefs = await SharedPreferences.getInstance();
      await SettingsStore(prefs).setLanguagePreference(
        LanguagePreference.german,
      );

      // A fresh store over the same prefs models an app relaunch.
      final recovered = await SettingsStore(prefs).read();
      expect(recovered.languagePreference, LanguagePreference.german);
    });

    test('deleteAll wipes every persisted setting', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SettingsStore(prefs);

      await store.write(
        const SettingsModel(
          demoModeDefault: true,
          timeFormat: TimeFormat.h24,
          onboardingDone: true,
          proApiKeyConfigured: true,
          languagePreference: LanguagePreference.portuguese,
        ),
      );
      await store.deleteAll();

      final settings = await store.read();
      expect(settings, SettingsModel.initial());
    });
  });
}
