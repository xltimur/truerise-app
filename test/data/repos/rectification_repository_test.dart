import 'package:dio/dio.dart' show CancelToken;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/dto/rectification_response_dto.dart';
import 'package:rectify/data/api/rectification_api.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/prefs/live_quota_store.dart';
import 'package:rectify/data/repos/history_repository.dart';
import 'package:rectify/data/repos/rectification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/demo_fixtures.dart';
import '../fixtures/sample_calculation.dart';

/// Fake API that records every call. Used to assert that the demo
/// path never touches the network (DM3 / §10.4).
class _RecordingApi implements RectificationApi {
  int callCount = 0;
  RectificationSearchResponseDto? canned;
  String cannedRaw = '{}';
  AppFailure? failure;
  CancelToken? lastCancelToken;

  @override
  Future<Result<RectificationApiResponse, AppFailure>> rectify(
    RectificationSearchRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    callCount++;
    lastCancelToken = cancelToken;
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
  LiveQuotaStore? liveQuotaStore,
  bool bypassLiveQuota = false,
}) {
  return LiveRectificationRepository(
    api: api,
    history: history,
    liveQuotaStore: liveQuotaStore,
    bypassLiveQuota: bypassLiveQuota,
    now: () => DateTime.utc(2026, 5, 20, 12),
    demoDelay: Duration.zero,
  );
}

/// Minimal valid v3 response for tests that only care that the call
/// reached the API and round-tripped.
const _minimalCannedResponse = RectificationSearchResponseDto(
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
          interpretation: 'Proxy-mode evidence text.',
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
);

void main() {
  late AppDatabase db;
  late DriftHistoryRepository history;
  late _RecordingApi api;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
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

      final result = await repo.submit(request, demoCopy: testDemoEvidenceCopy);

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
      await repo.submit(
        sampleRequest(isDemo: true),
        demoCopy: testDemoEvidenceCopy,
      );
      expect(api.callCount, 0);
    });

    test('demo submit persists the result to history', () async {
      final repo = _makeRepo(api: api, history: history);
      final request = sampleRequest(isDemo: true);
      final result = await repo.submit(request, demoCopy: testDemoEvidenceCopy);
      expect(result.isOk, isTrue);

      final fetched = await history.findById(request.id);
      expect(fetched.isOk, isTrue);
      expect(fetched.valueOrNull!.result.isDemo, isTrue);
    });

    test(
      'demo submit succeeds and stays offline even with the live quota '
      'exhausted',
      () async {
        // Demo mode is fully local: no key, no quota gate, no network.
        SharedPreferences.setMockInitialValues(<String, Object>{
          'live_quota.count': LiveQuotaStore.maxAttempts,
          'live_quota.window_start_ms': DateTime.utc(
            2026,
            5,
            20,
            2,
          ).millisecondsSinceEpoch,
        });
        final repo = _makeRepo(
          api: api,
          history: history,
          liveQuotaStore: LiveQuotaStore(await SharedPreferences.getInstance()),
        );
        final result = await repo.submit(
          sampleRequest(isDemo: true),
          demoCopy: testDemoEvidenceCopy,
        );
        expect(result.isOk, isTrue);
        expect(api.callCount, 0);
      },
    );
  });

  group('Real path — proxy mode (no provider key configured)', () {
    // With no bundled or Settings key, the API layer is wired for the
    // proxy endpoint; the repository must still submit (the proxy holds
    // the provider credential server-side), gated only by the local
    // free-attempt quota.

    test(
      'no-key real submit reaches the API and records a quota attempt',
      () async {
        api
          ..canned = _minimalCannedResponse
          ..cannedRaw = '{"candidates":[{"rank":1,"time":"08:00"}]}';
        final quota = LiveQuotaStore(await SharedPreferences.getInstance());
        final repo = _makeRepo(
          api: api,
          history: history,
          liveQuotaStore: quota,
        );

        final result = await repo.submit(sampleRequest(eventCount: 1));

        expect(result.isOk, isTrue);
        expect(
          api.callCount,
          1,
          reason: 'No-key submissions must reach the proxy, not fail locally',
        );
        final snapshot = await quota.read(DateTime.utc(2026, 5, 20, 12));
        expect(
          snapshot.used,
          1,
          reason: 'Proxy-mode attempts must consume the local free quota',
        );
      },
    );

    test(
      'exhausted local quota blocks a no-key submit before the API',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          'live_quota.count': LiveQuotaStore.maxAttempts,
          'live_quota.window_start_ms': DateTime.utc(
            2026,
            5,
            20,
            2,
          ).millisecondsSinceEpoch,
        });
        final repo = _makeRepo(
          api: api,
          history: history,
          liveQuotaStore: LiveQuotaStore(await SharedPreferences.getInstance()),
        );

        final result = await repo.submit(sampleRequest());

        expect(result.isErr, isTrue);
        expect(result.failureOrNull, isA<RateLimitedFailure>());
        expect(
          (result.failureOrNull! as RateLimitedFailure).source,
          RateLimitSource.local,
        );
        expect(
          api.callCount,
          0,
          reason: 'Local quota must gate before any proxy call',
        );
      },
    );
  });

  group('Real path — API round trip', () {
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

    test('submit threads the cancel token into the API call', () async {
      api.failure = const TimeoutFailure();
      final repo = _makeRepo(api: api, history: history);
      final cancelToken = CancelToken();

      await repo.submit(sampleRequest(), cancelToken: cancelToken);

      expect(
        api.lastCancelToken,
        same(cancelToken),
        reason:
            'Cancel can only abort the HTTP request when the token '
            'reaches the Dio boundary',
      );
    });

    test(
      'API failure after a user cancel maps to submissionCancelledFailure '
      'and writes no history',
      () async {
        // An aborted Dio call surfaces as a transport failure; with the
        // cancel flag already raised it must come back as the marker
        // failure, never as an Unknown error.
        api.failure = const UnknownFailure('simulated dio cancel');
        final repo = _makeRepo(api: api, history: history);
        final request = sampleRequest();

        final result = await repo.submit(request, isCancelled: () => true);

        expect(result.failureOrNull, same(submissionCancelledFailure));
        final saved = await history.findById(request.id);
        expect(
          saved.isErr,
          isTrue,
          reason: 'a cancelled submission must not save a history row',
        );
      },
    );
  });

  group('Real path — local live quota', () {
    // Repo clock is fixed at 2026-05-20T12:00Z by _makeRepo; the seeded
    // window started 10h earlier, so 14h remain until the quota resets.
    final firstAttempt = DateTime.utc(2026, 5, 20, 2);

    Future<LiveQuotaStore> seedExhaustedQuota() async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'live_quota.count': LiveQuotaStore.maxAttempts,
        'live_quota.window_start_ms': firstAttempt.millisecondsSinceEpoch,
      });
      return LiveQuotaStore(await SharedPreferences.getInstance());
    }

    test(
      'exhausted quota returns local RateLimitedFailure without calling '
      'the API',
      () async {
        final repo = _makeRepo(
          api: api,
          history: history,
          liveQuotaStore: await seedExhaustedQuota(),
        );

        final result = await repo.submit(sampleRequest());

        expect(result.isErr, isTrue);
        expect(result.failureOrNull, isA<RateLimitedFailure>());
        final failure = result.failureOrNull! as RateLimitedFailure;
        expect(failure.source, RateLimitSource.local);
        expect(failure.resetAt, firstAttempt.add(LiveQuotaStore.window));
        expect(failure.retryAfter, const Duration(hours: 14));
        expect(
          api.callCount,
          0,
          reason: 'Local quota must gate before any network call',
        );
      },
    );

    test('bypassLiveQuota=true skips the gate and reaches the API', () async {
      api.failure = const TimeoutFailure();
      final repo = _makeRepo(
        api: api,
        history: history,
        liveQuotaStore: await seedExhaustedQuota(),
        bypassLiveQuota: true,
      );

      final result = await repo.submit(sampleRequest());

      expect(result.failureOrNull, isA<TimeoutFailure>());
      expect(api.callCount, 1);
    });
  });
}
