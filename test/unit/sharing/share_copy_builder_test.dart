import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/sharing/share_copy_builder.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/l10n/app_localizations.dart';
import 'package:rectify/l10n/app_localizations_de.dart';
import 'package:rectify/l10n/app_localizations_en.dart';
import 'package:rectify/l10n/app_localizations_es.dart';
import 'package:rectify/l10n/app_localizations_fr.dart';
import 'package:rectify/l10n/app_localizations_pt.dart';

import '../../data/fixtures/sample_calculation.dart';

SavedCalculation _savedSample() => SavedCalculation(
  request: sampleRequest(),
  result: sampleResult(),
);

final AppLocalizations _en = AppLocalizationsEn();

/// All Tier-1 locales, keyed by tag for readable failure messages.
final Map<String, AppLocalizations> _locales = <String, AppLocalizations>{
  'en': AppLocalizationsEn(),
  'de': AppLocalizationsDe(),
  'es': AppLocalizationsEs(),
  'fr': AppLocalizationsFr(),
  'pt': AppLocalizationsPt(),
};

/// Private data that must never appear in shared copy, in any locale.
const List<String> _piiTokens = <String>[
  'Kyiv',
  'Ukraine',
  '1990',
  'May',
  'marriage',
  'careerChange',
  'relocation',
  'University',
  'Sample calculation',
  'req-001',
  'rawResponseJson',
  'apiCalculationId',
];

void main() {
  group('ShareCopyBuilder.build privacy guarantees (English)', () {
    late String copy;

    setUp(() {
      copy = ShareCopyBuilder.build(_savedSample(), _en);
    });

    test('does not include birth city', () {
      expect(copy, isNot(contains('Kyiv')));
      expect(copy, isNot(contains('Ukraine')));
    });

    test('does not include birth date', () {
      expect(copy, isNot(contains('1990')));
      // Month name is not included (the month number "5" and day "14"
      // appear in the time string "7:14" so bare digit checks are not
      // meaningful here — year uniquely identifies the birth date).
      expect(copy, isNot(contains('May')));
    });

    test('does not include life event categories or descriptions', () {
      expect(copy, isNot(contains('marriage')));
      expect(copy, isNot(contains('careerChange')));
      expect(copy, isNot(contains('relocation')));
      expect(copy, isNot(contains('University')));
    });

    test('does not include request label', () {
      expect(copy, isNot(contains('Sample calculation')));
    });

    test('does not include request or result IDs', () {
      expect(copy, isNot(contains('req-001')));
    });

    test('does not include rawResponseJson', () {
      // rawResponseJson is null in the fixture; ensure key string not leaked.
      expect(copy, isNot(contains('rawResponseJson')));
      expect(copy, isNot(contains('apiCalculationId')));
    });
  });

  group('ShareCopyBuilder.build content (English)', () {
    test('includes rectified hour and minute', () {
      final copy = ShareCopyBuilder.build(_savedSample(), _en);
      // Top candidate: 7:14 AM
      expect(copy, contains('7:14'));
    });

    test('includes AM/PM meridiem', () {
      final copy = ShareCopyBuilder.build(_savedSample(), _en);
      expect(copy, contains('AM'));
    });

    test('includes ascending sign', () {
      final copy = ShareCopyBuilder.build(_savedSample(), _en);
      expect(copy, contains('Gemini Rising'));
    });

    test('includes confidence percentage', () {
      final copy = ShareCopyBuilder.build(_savedSample(), _en);
      // 0.78 → 78%
      expect(copy, contains('78%'));
    });

    test('includes app name', () {
      final copy = ShareCopyBuilder.build(_savedSample(), _en);
      expect(copy, contains('TrueRise'));
    });

    test('returns non-empty fallback when candidates list is empty', () {
      final saved = SavedCalculation(
        request: sampleRequest(),
        result: sampleResult().copyWith(candidates: const []),
      );
      final copy = ShareCopyBuilder.build(saved, _en);
      expect(copy, isNotEmpty);
      expect(copy, contains('TrueRise'));
      // Still must not leak request data
      expect(copy, isNot(contains('Kyiv')));
      // Fallback still carries the store link so it stays a growth surface.
      expect(copy, contains(AppLinks.shareUrl));
    });

    test('omits "Rising" line when ascendant is null', () {
      final saved = SavedCalculation(
        request: sampleRequest(),
        result: sampleResult().copyWith(
          candidates: [
            sampleResult().candidates.first.copyWith(ascendant: null),
          ],
        ),
      );
      final copy = ShareCopyBuilder.build(saved, _en);
      expect(copy, isNot(contains('Rising')));
      expect(copy, contains('78%'));
    });

    test('uses 12-hour format even for PM times', () {
      // 14:05 → 2:05 PM
      final saved = SavedCalculation(
        request: sampleRequest(),
        result: sampleResult().copyWith(
          candidates: [
            sampleResult().candidates.first.copyWith(
              time: const TimeOfDay(hour: 14, minute: 5),
            ),
          ],
        ),
      );
      final copy = ShareCopyBuilder.build(saved, _en);
      expect(copy, contains('2:05'));
      expect(copy, contains('PM'));
      expect(copy, isNot(contains('14:')));
    });
  });

  group('ShareCopyBuilder.build store link', () {
    test('includes the public landing/store link', () {
      final copy = ShareCopyBuilder.build(_savedSample(), _en);
      expect(copy, contains(AppLinks.shareUrl));
    });

    test('the embedded link is a bare URL with no tracking query params', () {
      // A privacy-safe link carries no "?utm=" / "?id=" style parameters
      // that could identify the sharer.
      expect(AppLinks.shareUrl, startsWith('https://'));
      expect(AppLinks.shareUrl, isNot(contains('?')));
      // The single source of truth must satisfy the privacy-safe contract,
      // whether it is the default or an owner-supplied TRUERISE_SHARE_URL.
      expect(AppLinks.isPrivacySafeShareUrl(AppLinks.shareUrl), isTrue);
    });
  });

  group('ShareCopyBuilder.build localization (EN/DE/ES/FR/PT)', () {
    test('share copy is localized — distinct headline per locale', () {
      final headlines = <String>{};
      _locales.forEach((tag, l10n) {
        final copy = ShareCopyBuilder.build(_savedSample(), l10n);
        headlines.add(copy.split('\n').first);
      });
      // Five locales must produce five distinct first lines.
      expect(headlines, hasLength(_locales.length));
    });

    test(
      'every locale carries brand, time, confidence, and the store link',
      () {
        _locales.forEach((tag, l10n) {
          final copy = ShareCopyBuilder.build(_savedSample(), l10n);
          expect(copy, contains('TrueRise'), reason: 'brand missing in $tag');
          expect(copy, contains('7:14'), reason: 'time missing in $tag');
          // Confidence renders as "78%" (en/es/fr/pt) or "78 %" (de) — assert
          // the locale-agnostic number so the German spaced-percent passes too.
          expect(copy, contains('78'), reason: 'confidence missing in $tag');
          expect(
            copy,
            contains(AppLinks.shareUrl),
            reason: 'store link missing in $tag',
          );
        });
      },
    );

    test('localized prose uses the expected per-locale wording', () {
      <String, List<String>>{
        'en': <String>['rectification result', 'Calculated with', 'Find your'],
        'de': <String>['Geburtszeit', 'Berechnet mit', 'Finde deine'],
        'es': <String>[
          'hora de nacimiento',
          'Calculado con',
          'Averigua tu',
        ],
        'fr': <String>[
          'heure de naissance',
          'Calculé avec',
          'Trouvez votre',
        ],
        'pt': <String>[
          'horário de nascimento',
          'Calculado com',
          'Descubra seu',
        ],
      }.forEach((tag, fragments) {
        final copy = ShareCopyBuilder.build(_savedSample(), _locales[tag]!);
        for (final fragment in fragments) {
          expect(
            copy,
            contains(fragment),
            reason: 'locale $tag should contain "$fragment"',
          );
        }
      });
    });

    test('no private data leaks in any locale', () {
      _locales.forEach((tag, l10n) {
        final copy = ShareCopyBuilder.build(_savedSample(), l10n);
        for (final token in _piiTokens) {
          expect(
            copy,
            isNot(contains(token)),
            reason: 'locale $tag leaked "$token"',
          );
        }
      });
    });

    test(
      'empty-candidate fallback stays privacy-safe and linked per locale',
      () {
        final saved = SavedCalculation(
          request: sampleRequest(),
          result: sampleResult().copyWith(candidates: const []),
        );
        _locales.forEach((tag, l10n) {
          final copy = ShareCopyBuilder.build(saved, l10n);
          expect(copy, isNotEmpty, reason: 'empty fallback blank in $tag');
          expect(copy, contains('TrueRise'), reason: 'brand missing in $tag');
          expect(
            copy,
            contains(AppLinks.shareUrl),
            reason: 'store link missing in $tag',
          );
          for (final token in _piiTokens) {
            expect(
              copy,
              isNot(contains(token)),
              reason: 'fallback locale $tag leaked "$token"',
            );
          }
        });
      },
    );
  });
}
