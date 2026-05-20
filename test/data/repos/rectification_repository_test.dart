import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/dto/rectification_response_dto.dart';
import 'package:rectify/data/api/rectification_api.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/repos/history_repository.dart';
import 'package:rectify/data/repos/rectification_repository.dart';

import '../fixtures/sample_calculation.dart';

/// Fake API that records every call. Used to assert that the demo
/// path never touches the network (DM3 / §10.4).
class _RecordingApi implements RectificationApi {
  int callCount = 0;
  RectificationResponseDto? canned;
  String cannedRaw = '{}';
  AppFailure? failure;

  @override
  Future<Result<RectificationApiResponse, AppFailure>> rectify(
    RectificationRequestDto request,
  ) async {
    callCount++;
    if (failure != null) return Result.err(failure!);
    if (canned == null) {
      throw StateError('Test forgot to seed the canned response');
    }
    return Result.ok(
      RectificationApiResponse(dto: canned!, rawJson: cannedRaw),
    );
  }
}

void main() {
  late AppDatabase db;
  late DriftHistoryRepository history;
  late _RecordingApi api;
  late LiveRectificationRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    history = DriftHistoryRepository(db);
    api = _RecordingApi();
    repo = LiveRectificationRepository(
      api: api,
      history: history,
      now: () => DateTime.utc(2026, 5, 20, 12),
      demoDelay: Duration.zero,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Demo path (docs/mvp-scope.md §DM3, plan §10.4)', () {
    test('submit(isDemo=true) returns the §DM2 canonical shape', () async {
      final request = sampleRequest(isDemo: true, eventCount: 6);

      final result = await repo.submit(request);

      expect(result.isOk, isTrue);
      final calc = result.valueOrNull!;
      expect(calc.isDemo, isTrue);
      expect(calc.candidates.length, 3);
      expect(calc.candidates[0].confidence, closeTo(0.78, 1e-6));
      expect(calc.candidates[0].ascendant, 'Gemini');
      expect(calc.candidates[1].confidence, closeTo(0.61, 1e-6));
      expect(calc.candidates[2].confidence, closeTo(0.44, 1e-6));
      expect(calc.evidence.length, 6);

      final byStrength = <MatchStrength, int>{};
      for (final item in calc.evidence) {
        byStrength[item.matchStrength] =
            (byStrength[item.matchStrength] ?? 0) + 1;
      }
      expect(byStrength[MatchStrength.strong], 2);
      expect(byStrength[MatchStrength.moderate], 2);
      expect(byStrength[MatchStrength.weak], 1);
      expect(byStrength[MatchStrength.none], 1);
    });

    test('demo submit never calls RectificationApi.rectify', () async {
      final request = sampleRequest(isDemo: true);
      await repo.submit(request);
      expect(api.callCount, 0);
    });

    test('demo submit persists the result to history', () async {
      final request = sampleRequest(isDemo: true);
      final result = await repo.submit(request);
      expect(result.isOk, isTrue);

      final fetched = await history.findById(request.id);
      expect(fetched.isOk, isTrue);
      expect(fetched.valueOrNull!.result.isDemo, isTrue);
    });
  });

  group('Real path', () {
    test(
      'submit maps API response back to a domain CalculationResult',
      () async {
        api
          ..canned = const RectificationResponseDto(
            calculationId: 'remote-1',
            method: 'western_transit',
            candidates: <RectificationCandidateDto>[
              RectificationCandidateDto(
                rank: 1,
                time: '08:00',
                confidence: 0.91,
                ascendant: 'Leo',
              ),
            ],
            evidence: <RectificationEventMatchDto>[
              RectificationEventMatchDto(
                eventId: 'evt-1',
                matchStrength: 'strong',
                explanation: 'Real-mode evidence text.',
              ),
            ],
          )
          ..cannedRaw = '{"calculationId":"remote-1"}';

        final request = sampleRequest(eventCount: 1);
        final result = await repo.submit(request);
        expect(result.isOk, isTrue);
        final calc = result.valueOrNull!;
        expect(calc.apiCalculationId, 'remote-1');
        expect(calc.candidates.single.ascendant, 'Leo');
        expect(calc.evidence.single.matchStrength, MatchStrength.strong);
        expect(calc.rawResponseJson, '{"calculationId":"remote-1"}');
        expect(api.callCount, 1);

        final saved = await history.findById(request.id);
        expect(saved.isOk, isTrue);
        expect(
          saved.valueOrNull!.result.rawResponseJson,
          '{"calculationId":"remote-1"}',
        );
      },
    );

    test('submit forwards API failures as Result.err', () async {
      api.failure = const TimeoutFailure();
      final result = await repo.submit(sampleRequest());
      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<TimeoutFailure>());
    });
  });
}
