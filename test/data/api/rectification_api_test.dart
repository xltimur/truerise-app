import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/core/failures.dart';
import 'package:rectify/data/api/api_client.dart';
import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/rectification_api.dart';

import 'fake_http_adapter.dart';

/// Valid v3 response matching RectificationSearchResponseDto.
///
/// Mirrors the shapes documented at astrology-api.io v3
/// (`CandidateResult`, `SearchSummary`) — candidates carry `time`
/// (not `birth_time`), `normalized_score` (0..100) replaces a
/// pre-normalized `confidence`, evidence lives under each candidate as
/// `event_scores[]`, and `summary` contains a nested `confidence`
/// block instead of a `calculation_id`.
const _validResponseJson = '''
{
  "candidates": [
    {
      "rank": 1,
      "time": "07:14",
      "aggregate_score": 18.4,
      "normalized_score": 91.0,
      "grade": "excellent",
      "events_strongly_correlated": 1,
      "event_scores": [
        {
          "event_index": 0,
          "event_date": "2018-06",
          "event_category": "marriage",
          "total_score": 9.1,
          "interpretation": "fits"
        }
      ]
    }
  ],
  "summary": {
    "confidence": {
      "level": "high",
      "explanation": "top-1 well-separated",
      "gap_ratio": 0.45,
      "lift_ratio": 1.8
    },
    "peak_time": "07:14",
    "techniques_used": ["transit"],
    "step_minutes": 2
  },
  "computed_at": "2026-05-20T12:00:00Z"
}
''';

/// Same payload wrapped in the live v3 success envelope
/// (`{ success, data: {...}, metadata }`). Verified 2026-05-20 against
/// the live POST /api/v3/rectification/search response — every
/// successful call carries the envelope and the DTO models only the
/// inner business shape.
const _envelopedResponseJson = '''
{
  "success": true,
  "data": $_validResponseJson,
  "metadata": {
    "api_version": "3.2.0",
    "credits_used": 15,
    "request_id": "req_test_envelope"
  }
}
''';

/// Minimal v3 request DTO used by most tests — keeps fixture small.
const _request = RectificationSearchRequestDto(
  subject: SubjectDto(
    birthData: BirthDataV3Dto(
      year: 1990,
      month: 5,
      day: 14,
      hour: 14,
      minute: 0,
    ),
  ),
  timeSearch: TimeSearchDto(deltaMinutes: 60, stepMinutes: 2),
  events: <EventV3Dto>[
    EventV3Dto(
      category: 'marriage',
      date: '2018-06',
      datePrecision: 'month',
    ),
  ],
);

Dio _wiredDio(FakeHttpAdapter adapter, {String? bearerToken}) {
  return buildDio(
    baseUrl: 'https://test.invalid',
    authMode: AuthMode.proxy,
    bearerToken: bearerToken,
    proxyAppId: 'rectify-test-app-id',
    timeout: const Duration(milliseconds: 200),
    enableLogging: false,
  )..httpClientAdapter = adapter;
}

void main() {
  group('HttpRectificationApi (astrology-api.io v3)', () {
    test('parses a well-formed 200 response and preserves rawJson', () async {
      final adapter = FakeHttpAdapter()..enqueueJson(_validResponseJson);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);

      expect(result.isOk, isTrue);
      final payload = result.valueOrNull!;
      expect(payload.dto.candidates.single.time, '07:14');
      expect(
        payload.dto.candidates.single.normalizedScore,
        closeTo(91.0, 1e-9),
      );
      expect(payload.dto.summary?.confidence?.level, 'high');
      expect(payload.dto.computedAt, '2026-05-20T12:00:00Z');
      expect(payload.rawJson, _validResponseJson);

      expect(adapter.requests, hasLength(1));
      final captured = adapter.requests.single;
      expect(captured.method, 'POST');
      // Default path on a direct-instantiated HttpRectificationApi
      expect(captured.uri.path, '/api/v3/rectification/search');
      final body = jsonDecode(captured.bodyString) as Map<String, dynamic>;
      expect(body.containsKey('subject'), isTrue);
      expect(body.containsKey('time_search'), isTrue);
    });

    test(
      'sends Authorization: Bearer <key> when a Pro key is supplied',
      () async {
        final adapter = FakeHttpAdapter()..enqueueJson(_validResponseJson);
        final api = HttpRectificationApi(
          _wiredDio(adapter, bearerToken: 'pro-user-supplied-secret'),
        );

        final result = await api.rectify(_request);
        expect(result.isOk, isTrue);
        expect(
          adapter.requests.single.headers['authorization'],
          ['Bearer pro-user-supplied-secret'],
        );
      },
    );

    test(
      'Bearer token is not present in the request body',
      () async {
        final adapter = FakeHttpAdapter()..enqueueJson(_validResponseJson);
        final api = HttpRectificationApi(
          _wiredDio(adapter, bearerToken: 'secret-key-xyz'),
        );

        await api.rectify(_request);

        final body = adapter.requests.single.bodyString;
        expect(body.contains('secret-key-xyz'), isFalse,
            reason: 'API key must not appear in the POST body');
      },
    );

    test('connection timeout maps to TimeoutFailure', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueTransportFailure(DioExceptionType.connectionTimeout);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<TimeoutFailure>());
    });

    test('receive timeout maps to TimeoutFailure', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueTransportFailure(DioExceptionType.receiveTimeout);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<TimeoutFailure>());
    });

    test('connection error maps to NoNetworkFailure', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueTransportFailure(DioExceptionType.connectionError);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<NoNetworkFailure>());
    });

    test('400 maps to BadRequestFailure with the provider message', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueJson(
          '{"message":"Birth date is too far in the past."}',
          statusCode: 400,
        );
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      final failure = result.failureOrNull;
      expect(failure, isA<BadRequestFailure>());
      expect(
        (failure! as BadRequestFailure).message,
        'Birth date is too far in the past.',
      );
    });

    test('400 reads the message from the v3 success/error envelope', () async {
      // The live v3 API wraps errors as
      // `{success:false, error:{code,message,...}}`; a flat `message`
      // lookup misses it and falls back to generic copy.
      final adapter = FakeHttpAdapter()
        ..enqueueJson(
          '{"success":false,"data":null,"error":{"code":"INVALID_INPUT",'
          '"message":"Range produces 719 candidates, exceeds maximum 500."}}',
          statusCode: 400,
        );
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      final failure = result.failureOrNull;
      expect(failure, isA<BadRequestFailure>());
      expect(
        (failure! as BadRequestFailure).message,
        'Range produces 719 candidates, exceeds maximum 500.',
      );
    });

    test('422 maps to BadRequestFailure (FastAPI validation)', () async {
      // FastAPI request-validation rejections come back as 422 with a
      // `detail[]` array — they must land on the bad-request screen,
      // not the generic server screen.
      final adapter = FakeHttpAdapter()
        ..enqueueJson(
          '{"detail":[{"loc":["body","events"],'
          '"msg":"List should have at least 1 item","type":"too_short"}]}',
          statusCode: 422,
        );
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      final failure = result.failureOrNull;
      expect(failure, isA<BadRequestFailure>());
      expect(
        (failure! as BadRequestFailure).message,
        contains('at least 1 item'),
      );
    });

    test('401 maps to UnauthorizedFailure', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueJson('{"message":"no"}', statusCode: 401);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
    });

    test('403 also maps to UnauthorizedFailure', () async {
      final adapter = FakeHttpAdapter()..enqueueJson('{}', statusCode: 403);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
    });

    test('429 maps to RateLimitedFailure', () async {
      final adapter = FakeHttpAdapter()..enqueueJson('{}', statusCode: 429);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<RateLimitedFailure>());
    });

    test('500 maps to ServerFailure(500)', () async {
      final adapter = FakeHttpAdapter()..enqueueJson('{}', statusCode: 500);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      final failure = result.failureOrNull;
      expect(failure, isA<ServerFailure>());
      expect((failure! as ServerFailure).status, 500);
    });

    test(
      'unwraps {success, data, metadata} envelope from live v3 responses',
      () async {
        final adapter = FakeHttpAdapter()..enqueueJson(_envelopedResponseJson);
        final api = HttpRectificationApi(_wiredDio(adapter));

        final result = await api.rectify(_request);

        expect(result.isOk, isTrue, reason: 'envelope should be peeled');
        final payload = result.valueOrNull!;
        expect(payload.dto.candidates.single.time, '07:14');
        expect(payload.dto.summary?.confidence?.level, 'high');
        // rawJson keeps the full envelope so support can reproduce the
        // request_id / metadata block from saved_calculations.
        expect(payload.rawJson, _envelopedResponseJson);
        expect(payload.rawJson.contains('"metadata"'), isTrue);
      },
    );

    test('200 with non-JSON body maps to MalformedResponseFailure', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueBody(body: '<html>not json</html>');
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<MalformedResponseFailure>());
    });

    test('200 with a missing-field JSON body maps to malformed', () async {
      // Missing the required `candidates` field; `summary` is still
      // optional in the DTO so we don't need to include it here.
      final adapter = FakeHttpAdapter()
        ..enqueueJson('{"summary":null,"computed_at":null}');
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<MalformedResponseFailure>());
    });

    test('empty 200 body maps to MalformedResponseFailure', () async {
      final adapter = FakeHttpAdapter()..enqueueBody(body: '');
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<MalformedResponseFailure>());
    });
  });
}
