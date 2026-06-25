import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/l10n/locale_resolution.dart';

void main() {
  const supported = [
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('uk'),
  ];

  group('resolveAppLocale', () {
    test('German device locale resolves to German', () {
      final result = resolveAppLocale([const Locale('de')], supported);
      expect(result.languageCode, 'de');
    });

    test('French device locale resolves to French', () {
      final result = resolveAppLocale([const Locale('fr')], supported);
      expect(result.languageCode, 'fr');
    });

    test('unsupported Japanese-only locale falls back to English', () {
      final result = resolveAppLocale([const Locale('ja')], supported);
      expect(result.languageCode, 'en');
    });

    test(
      'unsupported primary with supported secondary resolves secondary',
      () {
        // Device: [Japanese, French] — first supported in list wins.
        final result = resolveAppLocale(
          [const Locale('ja'), const Locale('fr')],
          supported,
        );
        expect(result.languageCode, 'fr');
      },
    );

    test('null device locales fall back to English', () {
      final result = resolveAppLocale(null, supported);
      expect(result.languageCode, 'en');
    });

    test('empty device locales fall back to English', () {
      final result = resolveAppLocale([], supported);
      expect(result.languageCode, 'en');
    });

    test('region-tagged device locale resolves by language code only', () {
      // de-AT (Austrian German) should resolve to de, not fall through.
      final result = resolveAppLocale([const Locale('de', 'AT')], supported);
      expect(result.languageCode, 'de');
    });

    test('Ukrainian device locale resolves to Ukrainian', () {
      final result = resolveAppLocale([const Locale('uk')], supported);
      expect(result.languageCode, 'uk');
    });

    test('region-tagged uk-UA device locale resolves to Ukrainian', () {
      final result = resolveAppLocale([const Locale('uk', 'UA')], supported);
      expect(result.languageCode, 'uk');
    });
  });
}
