import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the App Store / Play compliance of every shipped string: an
/// in-app review ask may request only an honest review, never a specific
/// star count and never with rating-bait. This scans the source `.arb`
/// files directly so a future copy edit in any locale can't quietly
/// reintroduce a "rate us 5 stars" pattern.
void main() {
  const arbPaths = <String>[
    'lib/l10n/app_en.arb',
    'lib/l10n/app_de.arb',
    'lib/l10n/app_es.arb',
    'lib/l10n/app_fr.arb',
    'lib/l10n/app_pt.arb',
  ];

  const reviewKeys = <String>[
    'reviewPromptTitle',
    'reviewPromptBody',
    'reviewPromptConfirm',
    'reviewPromptDismiss',
  ];

  // Explicit rating-bait we must never ship anywhere: a star count (in
  // the five shipped locales), star glyphs, or "rate us" nagging.
  final ratingBait = RegExp(
    '★|⭐|'
    r'\b(5|five|fünf|cinco|cinq)[\s-]?'
    r'(stars?|sternen?|sterne|estrellas?|étoiles?|estrelas?)\b|'
    r'\brate us\b',
    caseSensitive: false,
  );

  // The review ask must actually ask for a review in its own language —
  // a cheap positive check that the neutral copy survived translation.
  const reviewWordByLocale = <String, String>{
    'en': 'review',
    'de': 'bewert',
    'es': 'reseñ',
    'fr': 'avis',
    'pt': 'avali',
  };

  Map<String, dynamic> readArb(String path) {
    final file = File(path);
    expect(file.existsSync(), isTrue, reason: '$path should exist');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  Iterable<MapEntry<String, String>> stringEntries(Map<String, dynamic> arb) {
    return arb.entries
        .where((e) => !e.key.startsWith('@') && e.value is String)
        .map((e) => MapEntry(e.key, e.value as String));
  }

  test('no shipped string contains 5-star / rating-bait wording', () {
    for (final path in arbPaths) {
      for (final entry in stringEntries(readArb(path))) {
        expect(
          ratingBait.hasMatch(entry.value),
          isFalse,
          reason:
              '$path → ${entry.key} contains rating-bait: '
              '"${entry.value}"',
        );
      }
    }
  });

  test('every locale defines the neutral review-prompt keys', () {
    for (final path in arbPaths) {
      final arb = readArb(path);
      for (final key in reviewKeys) {
        expect(
          arb.containsKey(key),
          isTrue,
          reason: '$path is missing review key $key',
        );
      }
    }
  });

  test('review-prompt copy never mentions stars and stays an honest ask', () {
    for (final path in arbPaths) {
      final arb = readArb(path);
      final locale = (arb['@@locale'] as String?) ?? '';
      final combined = reviewKeys
          .map((k) => (arb[k] as String?) ?? '')
          .join(' ')
          .toLowerCase();

      expect(
        combined.contains('★') || combined.contains('⭐'),
        isFalse,
        reason: '$path review copy contains a star glyph',
      );
      expect(
        RegExp(r'\bstars?\b').hasMatch(combined),
        isFalse,
        reason: '$path review copy mentions stars',
      );

      final reviewWord = reviewWordByLocale[locale];
      expect(
        reviewWord,
        isNotNull,
        reason: '$path has an unexpected @@locale "$locale"',
      );
      expect(
        combined.contains(reviewWord!),
        isTrue,
        reason:
            '$path review copy ($locale) should ask for a review '
            '(expected to contain "$reviewWord")',
      );
    }
  });
}
