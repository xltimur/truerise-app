import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rectify/core/sharing/share_copy_builder.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/l10n/app_localizations_en.dart';

import '../data/fixtures/sample_calculation.dart';
import '../helpers/demo_fixtures.dart';

/// G17 release gate: result, share, and demo user-visible copy must keep
/// probabilistic framing and must never read as a certainty claim or as
/// medical / legal / financial advice.
///
/// Scope is deliberately narrow — only the result screen, share copy, and
/// demo evidence surfaces. Onboarding copy legitimately describes the user
/// problem with words like "exact birth time" / "accurate", so it is NOT
/// scanned here. ARB metadata descriptions are not user-visible and are
/// likewise out of scope; the corpus below is built exclusively from
/// `AppLocalizationsEn` getters/builders and the production share/demo
/// copy builders that feed real screens.
void main() {
  final l10n = AppLocalizationsEn();

  /// Result + share + demo copy, keyed by a human-readable label so a
  /// failure names the exact offending string.
  late final Map<String, String> corpus;

  setUpAll(() async {
    await initializeDateFormatting('en');

    final saved = SavedCalculation(
      request: sampleRequest(),
      result: sampleResult(),
    );

    corpus = <String, String>{
      // Result screen strings.
      'resultTitle': l10n.resultTitle,
      'resultNotFoundTitle': l10n.resultNotFoundTitle,
      'resultNotFoundBody': l10n.resultNotFoundBody,
      'resultRisingSign("Gemini")': l10n.resultRisingSign('Gemini'),
      'resultSampleData': l10n.resultSampleData,
      'resultLowConfidenceTitle': l10n.resultLowConfidenceTitle,
      'resultLowConfidenceTipEvents': l10n.resultLowConfidenceTipEvents,
      'resultLowConfidenceTipReviewInput':
          l10n.resultLowConfidenceTipReviewInput,
      'resultLowConfidenceTipWiderWindow':
          l10n.resultLowConfidenceTipWiderWindow,
      'resultConfidenceExplainerTitle': l10n.resultConfidenceExplainerTitle,
      'resultConfidenceExplainerBody': l10n.resultConfidenceExplainerBody,
      'resultConfidenceExplainerMethod': l10n.resultConfidenceExplainerMethod,
      'resultOtherCandidates': l10n.resultOtherCandidates,
      'resultSeeEvidence': l10n.resultSeeEvidence,
      'resultShare': l10n.resultShare,
      'resultShareImage': l10n.resultShareImage,
      'resultDemoShareLabel': l10n.resultDemoShareLabel,
      'resultDemoShareTitle': l10n.resultDemoShareTitle,
      'resultDemoShareButton': l10n.resultDemoShareButton,
      'resultFriendShareLabel': l10n.resultFriendShareLabel,
      'resultFriendShareTitle': l10n.resultFriendShareTitle,
      'resultFriendShareBody': l10n.resultFriendShareBody,
      'resultFriendShareButton': l10n.resultFriendShareButton,
      'resultFeedbackTitle': l10n.resultFeedbackTitle,
      'resultFeedbackYes': l10n.resultFeedbackYes,
      'resultFeedbackNotSure': l10n.resultFeedbackNotSure,
      'resultFeedbackNo': l10n.resultFeedbackNo,
      'resultFeedbackSaved': l10n.resultFeedbackSaved,
      'resultDemoNudgeTitle': l10n.resultDemoNudgeTitle,
      'resultDemoNudgeBody': l10n.resultDemoNudgeBody,
      'resultStartNewCalculation': l10n.resultStartNewCalculation,
      'resultSaveToHistory': l10n.resultSaveToHistory,
      'resultSaved': l10n.resultSaved,
      // Share copy: the full assembled share text plus the share-card
      // strings rendered onto the story image.
      'ShareCopyBuilder.build(sample)': ShareCopyBuilder.build(saved, l10n),
      'shareCardTagline': l10n.shareCardTagline,
      'shareCardConfidence(78)': l10n.shareCardConfidence(78),
      // Demo evidence prose, exactly as the loading screen resolves it.
      'demoEvidence.strongVenus': testDemoEvidenceCopy.strongVenus,
      'demoEvidence.strongSaturn': testDemoEvidenceCopy.strongSaturn,
      'demoEvidence.moderateJupiter': testDemoEvidenceCopy.moderateJupiter,
      'demoEvidence.moderateSolarArc': testDemoEvidenceCopy.moderateSolarArc,
      'demoEvidence.weakMercury': testDemoEvidenceCopy.weakMercury,
      'demoEvidence.noMatch': testDemoEvidenceCopy.noMatch,
    };
  });

  group('G17 probabilistic framing of result/share/demo copy', () {
    test('corpus is non-empty (sanity)', () {
      expect(corpus, isNotEmpty);
      corpus.forEach((label, text) {
        expect(text, isNotEmpty, reason: '$label resolved to an empty string');
      });
    });

    test('no certainty, medical, legal, or financial claim language', () {
      // Word-boundary patterns keep harmless copy safe: "confidence",
      // "confirm", "Not sure", and "uncertain" do not match \bcertain.
      final banned = <String, RegExp>{
        'guarantee': RegExp(r'\bguarantee[sd]?\b', caseSensitive: false),
        'certain/certainty': RegExp(
          r'\bcertain(ty|ly)?\b',
          caseSensitive: false,
        ),
        'definitive': RegExp(r'\bdefinitive(ly)?\b', caseSensitive: false),
        'exact/exactly': RegExp(r'\bexact(ly)?\b', caseSensitive: false),
        'precise/precision': RegExp(
          r'\bprecis(e|ely|ion)\b',
          caseSensitive: false,
        ),
        'proven': RegExp(r'\bproven\b', caseSensitive: false),
        '100%': RegExp(r'\b100\s*%'),
        'prediction': RegExp(
          r'\bpredict(s|ed|ing|ion|ions)?\b',
          caseSensitive: false,
        ),
        'diagnose/diagnosis': RegExp(
          r'\bdiagnos(e|es|ed|ing|is|tic)\b',
          caseSensitive: false,
        ),
        'medical advice': RegExp(r'\bmedical\s+advice\b', caseSensitive: false),
        'legal advice': RegExp(r'\blegal\s+advice\b', caseSensitive: false),
        'financial advice': RegExp(
          r'\bfinancial\s+advice\b',
          caseSensitive: false,
        ),
        'cure': RegExp(r'\bcure[sd]?\b', caseSensitive: false),
        'treat/treatment': RegExp(
          r'\btreat(s|ed|ing|ment|ments)?\b',
          caseSensitive: false,
        ),
      };

      final offenders = <String>[];
      corpus.forEach((label, text) {
        banned.forEach((term, pattern) {
          if (pattern.hasMatch(text)) {
            offenders.add('$label: banned term "$term" in: "$text"');
          }
        });
      });

      expect(
        offenders,
        isEmpty,
        reason:
            'Result/share/demo copy must stay probabilistic and must not '
            'make certainty, medical, legal, or financial claims. '
            'Found:\n${offenders.join('\n')}',
      );
    });

    test('corpus keeps at least one probabilistic marker', () {
      final probabilistic = RegExp(
        r'\b(confidence|probable|probably|plausible|candidate|candidates'
        r'|sample|estimate[sd]?)\b',
        caseSensitive: false,
      );
      final joined = corpus.values.join('\n');
      expect(
        joined,
        matches(probabilistic),
        reason:
            'Result/share/demo copy should frame the rectified time as a '
            'probabilistic estimate (e.g. "confidence", "plausible", '
            '"candidate", "sample") — none of these markers were found.',
      );
    });

    test(
      'share prompts contain no referral, reward, or forced-action language',
      () {
        final banned = <String, RegExp>{
          'referral': RegExp(r'\breferral\b', caseSensitive: false),
          'reward': RegExp(r'\breward(s|ed)?\b', caseSensitive: false),
          'bonus': RegExp(r'\bbonus(es)?\b', caseSensitive: false),
          'discount': RegExp(r'\bdiscount(s|ed)?\b', caseSensitive: false),
          'coupon': RegExp(r'\bcoupon(s)?\b', caseSensitive: false),
          'promo code': RegExp(r'\bpromo\s+code(s)?\b', caseSensitive: false),
          'invite code': RegExp(r'\binvite\s+code(s)?\b', caseSensitive: false),
          'unlock': RegExp(r'\bunlock(s|ed|ing)?\b', caseSensitive: false),
          'must share': RegExp(r'\bmust\s+share\b', caseSensitive: false),
          'contacts': RegExp(r'\bcontacts?\b', caseSensitive: false),
        };
        final sharePromptCorpus = <String, String>{
          'resultDemoShareLabel': l10n.resultDemoShareLabel,
          'resultDemoShareTitle': l10n.resultDemoShareTitle,
          'resultDemoShareButton': l10n.resultDemoShareButton,
          'resultFriendShareLabel': l10n.resultFriendShareLabel,
          'resultFriendShareTitle': l10n.resultFriendShareTitle,
          'resultFriendShareBody': l10n.resultFriendShareBody,
          'resultFriendShareButton': l10n.resultFriendShareButton,
        };
        final offenders = <String>[];
        sharePromptCorpus.forEach((label, text) {
          banned.forEach((term, pattern) {
            if (pattern.hasMatch(text)) {
              offenders.add('$label: banned term "$term" in: "$text"');
            }
          });
        });

        expect(
          offenders,
          isEmpty,
          reason:
              'Share prompts must stay App Store / Google Play safe: no rewards, '
              'referral codes, contacts access, or forced share wording. '
              'Found:\n${offenders.join('\n')}',
        );
      },
    );
  });
}
