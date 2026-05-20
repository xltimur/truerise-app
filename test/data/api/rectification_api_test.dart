import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/core/failures.dart';
import 'package:rectify/data/api/api_client.dart';
import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/rectification_api.dart';

import 'fake_http_adapter.dart';

const _validResponseJson = '''
{
  "calculationId": "remote-1",
  "method": "western_transit",
  "candidates": [
    {"rank": 1, "time": "07:14", "confidence": 0.91, "ascendant": "Leo"}
  ],
  "evidence": [
    {"eventId": "evt-1", "matchStrength": "strong", "explanation": "fits"}
  ]
}
''';

const _request = RectificationRequestDto(
  requestId: 'req-1',
  birthDate: '1990-05-14',
  birthPlace: BirthPlaceDto(
    city: 'Kyiv, Ukraine',
    latitude: 50.4501,
    longitude: 30.5234,
  ),
  timeWindow: TimeWindowDto(
    mode: 'approximate',
    approximateTime: '07:14',
    windowMinutes: 60,
  ),
  lifeEvents: <LifeEventDto>[
    LifeEventDto(id: 'evt-1', category: 'marriage', year: 2018),
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
  group('HttpRectificationApi (Phase 6 §9.5)', () {
    test('parses a well-formed 200 response and preserves rawJson', () async {
      final adapter = FakeHttpAdapter()..enqueueJson(_validResponseJson);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);

      expect(result.isOk, isTrue);
      final payload = result.valueOrNull!;
      expect(payload.dto.calculationId, 'remote-1');
      expect(payload.dto.candidates.single.confidence, closeTo(0.91, 1e-9));
      expect(payload.rawJson, _validResponseJson);
      // The recorded request should carry our X-Rectify-App-Id and a
      // JSON body with the DTO's exact field names.
      expect(adapter.requests, hasLength(1));
      final captured = adapter.requests.single;
      expect(captured.method, 'POST');
      expect(captured.uri.path, '/v1/rectification');
      expect(captured.headers['x-rectify-app-id'], ['rectify-test-app-id']);
      expect(captured.headers.containsKey('authorization'), isFalse);
      final body = jsonDecode(captured.bodyString) as Map<String, dynamic>;
      expect(body['requestId'], 'req-1');
      expect(body['birthDate'], '1990-05-14');
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

    test('connection timeout maps to TimeoutFailure', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueTransportFailure(DioExceptionType.connectionTimeout);
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.isErr, isTrue);
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

    test('200 with non-JSON body maps to MalformedResponseFailure', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueBody(body: '<html>not json</html>');
      final api = HttpRectificationApi(_wiredDio(adapter));

      final result = await api.rectify(_request);
      expect(result.failureOrNull, isA<MalformedResponseFailure>());
    });

    test('200 with a missing-field JSON body maps to malformed', () async {
      // Missing the required `candidates` field — fromJson on the
      // freezed DTO should throw, and the API catches that as
      // MalformedResponseFailure.
      final adapter = FakeHttpAdapter()
        ..enqueueJson('{"calculationId":"x","evidence":[]}');
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
