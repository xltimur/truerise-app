import 'package:drift/native.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/repos/history_repository.dart';

import '../fixtures/sample_calculation.dart';

void main() {
  late AppDatabase db;
  late DriftHistoryRepository history;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    history = DriftHistoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase (in-memory) — Calculation aggregate', () {
    test('write → read → delete round-trip preserves the aggregate', () async {
      final request = sampleRequest();
      final result = _resultFor(request);

      final saved = await history.save(request, result);
      expect(saved.isOk, isTrue, reason: 'save should succeed');

      final fetched = await history.findById(request.id);
      expect(fetched.isOk, isTrue);
      final hydrated = fetched.valueOrNull!;
      expect(hydrated.request.id, request.id);
      expect(hydrated.request.events.length, 5);
      expect(hydrated.result.candidates.length, result.candidates.length);
      expect(hydrated.result.evidence.length, result.evidence.length);
      expect(hydrated.result.candidates.first.time.hour, 7);
      expect(hydrated.result.candidates.first.time.minute, 14);

      final deleted = await history.deleteById(request.id);
      expect(deleted.isOk, isTrue);

      final fetchedAgain = await history.findById(request.id);
      expect(
        fetchedAgain.isErr,
        isTrue,
        reason: 'after delete, the calculation must not be findable',
      );
    });

    test(
      'cascade delete also removes life events, candidates and evidence',
      () async {
        final request = sampleRequest(eventCount: 3);
        final result = _resultFor(request);
        await history.save(request, result);

        await history.deleteById(request.id);

        final events = await db.lifeEventsDao.forCalculation(request.id);
        final candidates = await db.candidateResultsDao.forCalculation(
          request.id,
        );
        final evidence = await db.evidenceDao.forCalculation(request.id);
        expect(events, isEmpty);
        expect(candidates, isEmpty);
        expect(evidence, isEmpty);
      },
    );

    test('watchAll emits when a calculation is inserted', () async {
      final stream = history.watchAll();
      final emissions = <int>[];
      final sub = stream.listen((rows) => emissions.add(rows.length));
      // Let Drift dispatch the initial empty result before mutating.
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final request = sampleRequest(eventCount: 2);
      await history.save(request, _resultFor(request));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      await sub.cancel();
      expect(emissions.first, 0);
      expect(emissions.last, 1);
    });

    test('deleteAll wipes every Calculations row', () async {
      final requestA = sampleRequest(id: 'a', eventCount: 2);
      final requestB = sampleRequest(id: 'b', eventCount: 3);
      await history.save(requestA, _resultFor(requestA));
      await history.save(requestB, _resultFor(requestB));

      final wipe = await history.deleteAll();
      expect(wipe.isOk, isTrue);

      final found = await history.findById('a');
      expect(found.isErr, isTrue);
    });
  });
}

/// Build a deterministic [CalculationResult] for [request] without
/// dragging in the demo-response builder (the demo path is tested
/// separately by `rectification_repository_test.dart`).
CalculationResult _resultFor(CalculationRequest request) {
  return CalculationResult(
    requestId: request.id,
    candidates: const <CandidateTime>[
      CandidateTime(
        rank: 1,
        time: TimeOfDay(hour: 7, minute: 14),
        confidence: 0.78,
        ascendant: 'Gemini',
      ),
      CandidateTime(
        rank: 2,
        time: TimeOfDay(hour: 7, minute: 42),
        confidence: 0.61,
      ),
    ],
    evidence: <EvidenceItem>[
      for (final event in request.events)
        EvidenceItem(
          eventId: event.id,
          matchStrength: MatchStrength.moderate,
          explanation: 'Stock evidence for ${event.id}',
        ),
    ],
    isDemo: false,
    completedAt: DateTime.utc(2026, 5, 20, 12),
    apiCalculationId: 'api-${request.id}',
    method: 'western_transit',
    rawResponseJson: '{"stub":true}',
  );
}
