@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Phase 8 release security gate (`docs/mvp-scope.md` AC-Demo-6,
/// AC-Demo-7; `docs/implementation-plan.md` §16).
///
/// Scans the production Dart sources under `lib/` and asserts:
///
///  1. **No payment / monetization surface words.** The MVP has zero
///     in-app purchase, paywall, or "credit" UX; if any of those words
///     creep into a screen string we have leaked a Phase-9 feature into
///     the demo binary.
///  2. **No literal Mapbox `sk.…` secret tokens, OpenAI-style `sk-…`
///     literals with key bodies, or hard-coded `Bearer …` headers**
///     in production source. The only credential ever sent is the
///     end-user-supplied Pro key from secure storage; the only `sk-…`
///     occurrence allowed in `lib/` is the placeholder `'sk-…'` (with
///     ellipsis character) used as the API key sheet hint.
///
/// The test parses only `lib/**.dart` — `test/**`, fixtures, and docs
/// are exempt because they intentionally include "sk-test-NOT-A-REAL-
/// KEY-…" strings as negative assertions for upstream tests.
void main() {
  final libDir = Directory('lib');

  group('No payment surface / no secret strings in lib/', () {
    final dartFiles = libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    test('lib/ has at least one Dart file (sanity)', () {
      expect(dartFiles, isNotEmpty);
    });

    // 1. Payment surface words. We tolerate the comment in
    // `result_screen.dart` that documents the *absence* of a paywall
    // ("CTA does not link to a paywall"); that's a justification, not a
    // surface. The check below ignores comment lines.
    //
    // We restrict to string-literal contents (between quotes) so the
    // scan never flags legitimate identifiers like `StreamSubscription`
    // or `subscription` (a draft-repository variable name). Anything
    // that would actually reach the user has to land inside a `'…'` or
    // `"…"` string at some point.
    final paymentSurfacePhrases = <RegExp>[
      RegExp(r'\bpaywall\b', caseSensitive: false),
      RegExp(r'\bsubscription\b', caseSensitive: false),
      RegExp(r'\brestore\s+purchase\b', caseSensitive: false),
      RegExp(r'\bin-?app\s+purchase\b', caseSensitive: false),
      RegExp(r'\bbuy\s+now\b', caseSensitive: false),
      RegExp(r'\bunlock\s+pro\b', caseSensitive: false),
      RegExp(r'\b1\s+Calculation\s+Credit\b', caseSensitive: false),
    ];

    // Strip everything that isn't a string-literal body from a line of
    // Dart so identifier collisions (`subscription`, `IAPProduct`)
    // don't trip the gate. We don't need a full Dart tokenizer here —
    // a permissive single/double-quoted body match catches all the
    // user-visible copy in this project.
    Iterable<String> stringLiteralsOn(String line) sync* {
      final matcher = RegExp(r"'([^'\\]|\\.)*'|\x22([^\x22\\]|\\.)*\x22");
      for (final m in matcher.allMatches(line)) {
        yield m.group(0)!;
      }
    }

    test('lib/ contains no payment-surface words in user-facing strings', () {
      final offenders = <String>[];
      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        final lines = content.split('\n');
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          final trimmed = line.trimLeft();
          // Skip comment lines — those reference deferred features by
          // name when documenting why they're absent.
          if (trimmed.startsWith('//') ||
              trimmed.startsWith('///') ||
              trimmed.startsWith('*')) {
            continue;
          }
          for (final literal in stringLiteralsOn(line)) {
            for (final pattern in paymentSurfacePhrases) {
              if (pattern.hasMatch(literal)) {
                offenders.add(
                  '${file.path}:${i + 1}: ${line.trim()}',
                );
              }
            }
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'MVP must not ship payment-surface user-facing copy. '
            'Found:\n${offenders.join('\n')}',
      );
    });

    // 2. Secret-shaped string literals. Detects Mapbox `sk.<word>`,
    // OpenAI-style `sk-<long body>`, and hard-coded `Bearer <body>`.
    // The single tolerated occurrence is the literal placeholder
    // `'sk-…'` (one ellipsis char) used in the API-key bottom sheet.
    final secretPatterns = <RegExp>[
      // sk. followed by ≥ 8 word chars → looks like a Mapbox secret.
      RegExp(r'sk\.[A-Za-z0-9_-]{8,}'),
      // sk- followed by ≥ 8 plain chars. The API-key sheet's `'sk-…'`
      // placeholder uses the ellipsis (U+2026), not an ASCII run, so it
      // is excluded here by construction.
      RegExp('[\'"]sk-[A-Za-z0-9_]{8,}[\'"]'),
      // Hard-coded Authorization header with a body ≥ 8 chars.
      RegExp('[\'"]Bearer\\s+[A-Za-z0-9_.-]{8,}[\'"]'),
    ];

    test('lib/ contains no literal secret-shaped strings', () {
      final offenders = <String>[];
      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        final lines = content.split('\n');
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          for (final pattern in secretPatterns) {
            if (pattern.hasMatch(line)) {
              offenders.add('${file.path}:${i + 1}: ${line.trim()}');
            }
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'MVP must not embed real provider secrets. '
            'Found:\n${offenders.join('\n')}',
      );
    });
  });
}
