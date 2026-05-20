import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/match_strength.dart';

import '../fixtures/sample_calculation.dart';

void main() {
  group('Demo response (docs/mvp-scope.md §DM2)', () {
    test('ships exactly three candidate times with descending confidence', () {
      expect(demoCandidates.length, 3);
      expect(demoCandidates[0].time, const TimeOfDay(hour: 7, minute: 14));
      expect(demoCandidates[0].confidence, closeTo(0.78, 1e-6));
      expect(demoCandidates[1].time, const TimeOfDay(hour: 7, minute: 42));
      expect(demoCandidates[1].confidence, closeTo(0.61, 1e-6));
      expect(demoCandidates[2].time, const TimeOfDay(hour: 8, minute: 3));
      expect(demoCandidates[2].confidence, closeTo(0.44, 1e-6));
    });

    test('top candidate carries the Gemini Rising sign', () {
      expect(demoCandidates.first.ascendant, 'Gemini');
    });

    test('buildDemoResult for 6 events produces 2/2/1/1 distribution', () {
      final request = sampleRequest(isDemo: true, eventCount: 6);
      final result = buildDemoResult(request, now: DateTime.utc(2026, 5, 20));

      expect(result.evidence.length, 6);
      final byStrength = <MatchStrength, int>{};
      for (final item in result.evidence) {
        byStrength[item.matchStrength] =
            (byStrength[item.matchStrength] ?? 0) + 1;
      }
      expect(byStrength[MatchStrength.strong], 2);
      expect(byStrength[MatchStrength.moderate], 2);
      expect(byStrength[MatchStrength.weak], 1);
      expect(byStrength[MatchStrength.none], 1);
    });

    test('every evidence entry has an explanation string', () {
      final request = sampleRequest(isDemo: true, eventCount: 6);
      final result = buildDemoResult(request, now: DateTime.utc(2026, 5, 20));
      for (final item in result.evidence) {
        expect(item.explanation, isNotEmpty);
      }
    });

    test('trims distribution to the user event count when fewer than 6', () {
      final request = sampleRequest(isDemo: true, eventCount: 3);
      final result = buildDemoResult(request, now: DateTime.utc(2026, 5, 20));

      expect(result.evidence.length, 3);
      // First three entries of the canonical 2/2/1/1 are
      // strong / strong / moderate.
      expect(result.evidence[0].matchStrength, MatchStrength.strong);
      expect(result.evidence[1].matchStrength, MatchStrength.strong);
      expect(result.evidence[2].matchStrength, MatchStrength.moderate);
    });

    test('pads weak/none stock evidence when user submitted more than 6', () {
      // Build a synthetic request with 8 events by extending the
      // fixture in-place.
      final base = sampleRequest(isDemo: true, eventCount: 6);
      final extended = base.copyWith(
        events: <dynamic>[
          ...base.events,
          base.events.first.copyWith(id: 'evt-7'),
          base.events.first.copyWith(id: 'evt-8'),
        ].cast(),
      );
      final result = buildDemoResult(extended, now: DateTime.utc(2026, 5, 20));

      expect(result.evidence.length, 8);
      for (var i = 6; i < 8; i++) {
        expect(
          result.evidence[i].matchStrength,
          anyOf(MatchStrength.weak, MatchStrength.none),
        );
      }
    });

    test('isDemo is true and method is demo_canonical', () {
      final result = buildDemoResult(
        sampleRequest(isDemo: true),
        now: DateTime.utc(2026, 5, 20),
      );
      expect(result.isDemo, isTrue);
      expect(result.method, 'demo_canonical');
      expect(result.apiCalculationId, isNull);
      expect(result.rawResponseJson, isNull);
    });
  });
}
