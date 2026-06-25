import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/models/language_preference.dart';

void main() {
  group('LanguagePreference', () {
    test('round-trips every value through its tag', () {
      for (final value in LanguagePreference.values) {
        expect(LanguagePreference.fromTag(value.tag), value);
      }
    });

    test('unknown or empty tag falls back to auto', () {
      expect(LanguagePreference.fromTag('xx'), LanguagePreference.auto);
      expect(LanguagePreference.fromTag(''), LanguagePreference.auto);
    });

    test('auto maps to a null locale (device-driven)', () {
      expect(LanguagePreference.auto.locale, isNull);
    });

    test('each explicit language maps to its language-code Locale', () {
      expect(LanguagePreference.english.locale, const Locale('en'));
      expect(LanguagePreference.german.locale, const Locale('de'));
      expect(LanguagePreference.spanish.locale, const Locale('es'));
      expect(LanguagePreference.french.locale, const Locale('fr'));
      expect(LanguagePreference.portuguese.locale, const Locale('pt'));
      expect(LanguagePreference.ukrainian.locale, const Locale('uk'));
    });

    test('ukrainian tag round-trips through fromTag', () {
      expect(LanguagePreference.fromTag('uk'), LanguagePreference.ukrainian);
    });
  });
}
