import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/sharing/invite_copy_builder.dart';
import 'package:rectify/l10n/app_localizations.dart';
import 'package:rectify/l10n/app_localizations_de.dart';
import 'package:rectify/l10n/app_localizations_en.dart';
import 'package:rectify/l10n/app_localizations_es.dart';
import 'package:rectify/l10n/app_localizations_fr.dart';
import 'package:rectify/l10n/app_localizations_pt.dart';

final AppLocalizations _en = AppLocalizationsEn();

/// All Tier-1 locales, keyed by tag for readable failure messages.
final Map<String, AppLocalizations> _locales = <String, AppLocalizations>{
  'en': AppLocalizationsEn(),
  'de': AppLocalizationsDe(),
  'es': AppLocalizationsEs(),
  'fr': AppLocalizationsFr(),
  'pt': AppLocalizationsPt(),
};

/// Personal / calculation data that must never appear in an invite. The
/// invite builder reads no `SavedCalculation` at all (it has no parameter
/// for one), so this is a belt-and-braces guard rather than a leak path.
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

/// Referral / reward / rating-bait wording that would turn a soft invite
/// into an incentivised referral or a rating nudge.
const List<String> _forbiddenIncentiveTokens = <String>[
  'referral',
  'reward',
  'bonus',
  'gift',
  'coupon',
  'promo',
  'discount',
  'voucher',
  'invite code',
  'promo code',
  'rate us',
  'stars',
  '5-star',
  '★',
  '⭐',
];

void main() {
  group('InviteCopyBuilder.build content (English)', () {
    late String copy;

    setUp(() {
      copy = InviteCopyBuilder.build(_en);
    });

    test('is non-empty', () {
      expect(copy, isNotEmpty);
    });

    test('includes the brand name', () {
      expect(copy, contains('TrueRise'));
    });

    test('includes the public landing/store link', () {
      expect(copy, contains(AppLinks.shareUrl));
    });

    test('reads as a soft "find your birth time" invite', () {
      expect(copy, contains('Try'));
      expect(copy, contains('birth time'));
    });
  });

  group('InviteCopyBuilder.build store link', () {
    test('the embedded link is a bare URL with no tracking query params', () {
      expect(AppLinks.shareUrl, startsWith('https://'));
      expect(AppLinks.shareUrl, isNot(contains('?')));
      final copy = InviteCopyBuilder.build(_en);
      expect(copy, isNot(contains('utm')));
      expect(copy, isNot(contains('ref=')));
    });
  });

  group('InviteCopyBuilder.build localization (EN/DE/ES/FR/PT)', () {
    test('invite copy is localized — distinct headline per locale', () {
      final headlines = <String>{};
      _locales.forEach((tag, l10n) {
        headlines.add(InviteCopyBuilder.build(l10n).split('\n').first);
      });
      expect(headlines, hasLength(_locales.length));
    });

    test('every locale carries the brand and the store link', () {
      _locales.forEach((tag, l10n) {
        final copy = InviteCopyBuilder.build(l10n);
        expect(copy, contains('TrueRise'), reason: 'brand missing in $tag');
        expect(
          copy,
          contains(AppLinks.shareUrl),
          reason: 'store link missing in $tag',
        );
      });
    });

    test('localized prose uses the expected per-locale wording', () {
      <String, List<String>>{
        'en': <String>['Try', 'birth time', 'Get the app'],
        'de': <String>['Probier', 'Geburtszeit', 'Hol dir die App'],
        'es': <String>['Prueba', 'hora de nacimiento', 'Descarga la app'],
        'fr': <String>['Essayez', 'heure de naissance', 'Téléchargez'],
        'pt': <String>['Experimente', 'horário de nascimento', 'Baixe o app'],
      }.forEach((tag, fragments) {
        final copy = InviteCopyBuilder.build(_locales[tag]!);
        for (final fragment in fragments) {
          expect(
            copy,
            contains(fragment),
            reason: 'locale $tag should contain "$fragment"',
          );
        }
      });
    });
  });

  group('InviteCopyBuilder.build privacy + compliance guarantees', () {
    test('no personal / calculation data leaks in any locale', () {
      _locales.forEach((tag, l10n) {
        final copy = InviteCopyBuilder.build(l10n);
        for (final token in _piiTokens) {
          expect(
            copy,
            isNot(contains(token)),
            reason: 'locale $tag leaked "$token"',
          );
        }
      });
    });

    test('no referral / reward / rating-bait wording in any locale', () {
      _locales.forEach((tag, l10n) {
        final copy = InviteCopyBuilder.build(l10n).toLowerCase();
        for (final token in _forbiddenIncentiveTokens) {
          expect(
            copy,
            isNot(contains(token.toLowerCase())),
            reason: 'locale $tag contains incentive/bait token "$token"',
          );
        }
      });
    });
  });
}
