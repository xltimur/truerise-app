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
  RectificationSearchResponseDto? canned;
  String cannedRaw = '{}';
  AppFailure? failure;

  @override
  Future<Result<RectificationApiResponse, AppFailure>> rectify(
    RectificationSearchRequestDto request,
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

LiveRectificationRepository _makeRepo({
  required _RecordingApi api,
  required DriftHistoryRepository history,
  bool apiKeyIsConfigured = true,
}) {
  return LiveRectificationRepository(
    api: api,
    history: history,
    apiKeyIsConfigured: apiKeyIsConfigured,
    now: () => DateTime.utc(2026, 5, 20, 12),
    demoDelay: Duration.zero,
  );
}

void main() {
  late AppDatabase db;
  late DriftHistoryRepository history;
  late _RecordingApi api;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    history = DriftHistoryRepository(db);
    api = _RecordingApi();
  });

  tearDown(() async {
    await db.close();
  });

  group('Demo path (docs/mvp-scope.md §DM3, plan §10.4)', () {
    test('submit(isDemo=true) returns the §DM2 canonical shape', () async {
      final repo = _makeRepo(api: api, history: history);
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
      final repo = _makeRepo(api: api, history: history);
      await repo.submit(sampleRequest(isDemo: true));
      expect(api.callCount, 0);
    });

    test('demo submit persists the result to history', () async {
      final repo = _makeRepo(api: api, history: history);
      final request = sampleRequest(isDemo: true);
      final result = await repo.submit(request);
      expect(result.isOk, isTrue);

      final fetched = await history.findById(request.id);
      expect(fetched.isOk, isTrue);
      expect(fetched.valueOrNull!.result.isDemo, isTrue);
    });

    test('demo submit returns success even when apiKeyIsConfigured=false',
        () async {
      // Demo mode must never be blocked by missing API key.
      final repo = _makeRepo(
        api: api,
        history: history,
        apiKeyIsConfigured: false,
      );
      final result = await repo.submit(sampleRequest(isDemo: true));
      expect(result.isOk, isTrue);
      expect(api.callCount, 0);
    });
  });

  group('Real path — no API key configured', () {
    test('returns MissingApiKeyFailure before calling the API', () async {
      final repo = _makeRepo(
        api: api,
        history: history,
        apiKeyIsConfigured: false,
      );
      final result = await repo.submit(sampleRequest());

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<MissingApiKeyFailure>());
      expect(api.callCount, 0,
          reason: 'No network call should be made when key is absent');
    });

    test('MissingApiKeyFailure is distinct from NoNetworkFailure', () async {
      final repo = _makeRepo(
        api: api,
        history: history,
        apiKeyIsConfigured: false,
      );
      final result = await repo.submit(sampleRequest());

      expect(result.failureOrNull, isNot(isA<NoNetworkFailure>()));
      expect(result.failureOrNull, isA<MissingApiKeyFailure>());
    });
  });

  group('Real path — key configured', () {
    test(
      'submit maps API response back to a domain CalculationResult',
      () async {
        api
          ..canned = const RectificationSearchResponseDto(
            candidates: <CandidateV3Dto>[
              CandidateV3Dto(
                rank: 1,
                time: '08:00',
                aggregateScore: 19.2,
                normalizedScore: 91,
                grade: 'excellent',
                eventScores: <EventScoreDto>[
                  EventScoreDto(
                    eventIndex: 0,
                    eventDate: '2014-06',
                    eventCategory: 'marriage',
                    totalScore: 9.1,
                    interpretation: 'Real-mode evidence text.',
                  ),
                ],
                chart: <String, dynamic>{
                  'planetary_positions': <Map<String, dynamic>>[
                    <String, dynamic>{'name': 'Ascendant', 'sign': 'Leo'},
                  ],
                },
              ),
            ],
            summary: SummaryV3Dto(
              confidence: ConfidenceAssessmentDto(level: 'high'),
              peakTime: '08:00',
              techniquesUsed: <String>['transit'],
            ),
            computedAt: '2026-05-20T12:00:00Z',
          )
          ..cannedRaw = '{"candidates":[{"rank":1,"time":"08:00"}]}';

        final repo = _makeRepo(api: api, history: history);
        final request = sampleRequest(eventCount: 1);
        final result = await repo.submit(request);

        expect(result.isOk, isTrue);
        final calc = result.valueOrNull!;
        // v3 has no calculation_id in the response.
        expect(calc.apiCalculationId, isNull);
        expect(calc.method, 'transit');
        expect(calc.candidates.single.ascendant, 'Leo');
        expect(calc.evidence.single.eventId, request.events.single.id);
        expect(calc.evidence.single.matchStrength, MatchStrength.strong);
        expect(
          calc.rawResponseJson,
          '{"candidates":[{"rank":1,"time":"08:00"}]}',
        );
        expect(api.callCount, 1);

        final saved = await history.findById(request.id);
        expect(saved.isOk, isTrue);
        expect(
          saved.valueOrNull!.result.rawResponseJson,
          '{"candidates":[{"rank":1,"time":"08:00"}]}',
        );
      },
    );

    test('submit forwards API failures as Result.err', () async {
      api.failure = const TimeoutFailure();
      final repo = _makeRepo(api: api, history: history);
      final result = await repo.submit(sampleRequest());
      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<TimeoutFailure>());
    });
  });
}
