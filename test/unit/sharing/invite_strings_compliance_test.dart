import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the "Invite a friend" copy (S4 — Invite Friend Lite). The invite
/// is a *soft* opt-in: it may name the product and link to the public store
/// page, but it must never become a referral/reward program, never carry
/// rating-bait, and never embed tracking parameters. This scans the source
/// `.arb` files directly so a future copy edit in any locale can't quietly
/// turn the invite into an incentivised referral or a "rate us 5 stars"
/// nudge.
void main() {
  const arbPaths = <String>[
    'lib/l10n/app_en.arb',
    'lib/l10n/app_de.arb',
    'lib/l10n/app_es.arb',
    'lib/l10n/app_fr.arb',
    'lib/l10n/app_pt.arb',
    'lib/l10n/app_uk.arb',
  ];

  // Every locale must define the invite affordance + the three invite copy
  // lines (headline / body / link CTA).
  const inviteKeys = <String>[
    'settingsInviteFriend',
    'homeInviteTitle',
    'homeInviteBody',
    'homeInviteButton',
    'inviteCopyHeadline',
    'inviteCopyBody',
    'inviteCopyGetApp',
  ];

  // Referral / reward / incentive language that would turn the soft invite
  // into a rewards program. Covers English plus the obvious equivalents in
  // the four other shipped locales. Scoped to the invite keys only — other
  // strings legitimately use words like "free" (e.g. the demo-mode helper).
  final referralReward = RegExp(
    r'\b(reward|bonus|gift|coupon|promo|voucher|discount|cashback|credit|'
    'referral|invite code|promo code|earn|'
    'recompensa|regalo|bono|cup[oó]n|descuento|'
    'pr[aä]mie|gutschein|rabatt|belohnung|geschenk|'
    'r[eé]compense|cadeau|r[eé]duction|'
    'presente|cupom|'
    r'винагород\w*|бонус\w*|подарунок|подарунки|купон\w*|'
    r'знижк\w*|промокод\w*|реферал\w*|зароб\w*)\b',
    caseSensitive: false,
  );

  // Rating-bait — mirror of the review-compliance guard so the invite can
  // never be repurposed into a star-rating nudge.
  final ratingBait = RegExp(
    '★|⭐|'
    r'\b(5|five|fünf|cinco|cinq)[\s-]?'
    r'(stars?|sternen?|sterne|estrellas?|étoiles?|estrelas?)\b|'
    r'\brate us\b|'
    r'\b(5|п.?ять)[\s-]?(зірок|зірки|зірочок)\b',
    caseSensitive: false,
  );

  // Tracking parameters that would de-anonymise the sharer.
  final trackingParams = RegExp('utm|ref=|[?]', caseSensitive: false);

  Map<String, dynamic> readArb(String path) {
    final file = File(path);
    expect(file.existsSync(), isTrue, reason: '$path should exist');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  test('every locale defines the invite keys', () {
    for (final path in arbPaths) {
      final arb = readArb(path);
      for (final key in inviteKeys) {
        expect(
          arb.containsKey(key),
          isTrue,
          reason: '$path is missing invite key $key',
        );
      }
    }
  });

  test('invite copy carries no referral / reward / incentive language', () {
    for (final path in arbPaths) {
      final arb = readArb(path);
      for (final key in inviteKeys) {
        final value = (arb[key] as String?) ?? '';
        expect(
          referralReward.hasMatch(value),
          isFalse,
          reason: '$path → $key reads as a referral/reward: "$value"',
        );
      }
    }
  });

  test('invite copy carries no rating-bait', () {
    for (final path in arbPaths) {
      final arb = readArb(path);
      for (final key in inviteKeys) {
        final value = (arb[key] as String?) ?? '';
        expect(
          ratingBait.hasMatch(value),
          isFalse,
          reason: '$path → $key contains rating-bait: "$value"',
        );
      }
    }
  });

  test('the invite link line carries no tracking parameters', () {
    for (final path in arbPaths) {
      final arb = readArb(path);
      final getApp = (arb['inviteCopyGetApp'] as String?) ?? '';
      expect(
        trackingParams.hasMatch(getApp),
        isFalse,
        reason: '$path → inviteCopyGetApp has tracking params: "$getApp"',
      );
    }
  });

  test('brand and link stay placeholders translators cannot alter', () {
    for (final path in arbPaths) {
      final arb = readArb(path);
      expect(
        (arb['inviteCopyHeadline'] as String?) ?? '',
        contains('{brand}'),
        reason: '$path → inviteCopyHeadline must keep the {brand} placeholder',
      );
      expect(
        (arb['inviteCopyGetApp'] as String?) ?? '',
        contains('{url}'),
        reason: '$path → inviteCopyGetApp must keep the {url} placeholder',
      );
    }
  });
}
