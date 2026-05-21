import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/data/api/api_client.dart';

import 'fake_http_adapter.dart';

void main() {
  group('LoggingInterceptor redaction (§9.2 / §9.5)', () {
    test(
      'never logs Authorization headers, request bodies, or response bodies',
      () async {
        final captured = <String>[];
        final adapter = FakeHttpAdapter()
          ..enqueueJson(
            '{"calculationId":"secret-leak","method":"raw"}',
          );

        final dio =
            Dio(
                BaseOptions(
                  baseUrl: 'https://test.invalid',
                  headers: <String, String>{
                    'Authorization': 'Bearer USER-SECRET-KEY-DO-NOT-LEAK',
                    'X-Rectify-App-Id': 'rectify-test-app-id',
                    'Content-Type': 'application/json',
                  },
                ),
              )
              ..httpClientAdapter = adapter
              ..interceptors.add(LoggingInterceptor(sink: captured.add));

        await dio.post<String>(
          '/v1/rectification',
          data: '{"requestId":"sensitive-input","apiKey":"ALSO-SECRET"}',
          options: Options(responseType: ResponseType.plain),
        );

        // Every emitted line is checked against the sensitive set.
        const sensitive = <String>[
          'USER-SECRET-KEY-DO-NOT-LEAK',
          'Bearer',
          'authorization',
          'Authorization',
          'sensitive-input',
          'ALSO-SECRET',
          'apiKey',
          'requestId',
          'secret-leak',
        ];
        for (final line in captured) {
          for (final needle in sensitive) {
            expect(
              line.toLowerCase().contains(needle.toLowerCase()),
              isFalse,
              reason: 'Logging line "$line" leaked "$needle"',
            );
          }
        }
        // We *did* log: a request line and a response line.
        expect(captured.length, greaterThanOrEqualTo(2));
        expect(captured.any((line) => line.contains('POST')), isTrue);
        expect(captured.any((line) => line.contains('200')), isTrue);
      },
    );

    test(
      'request path is logged without query parameters',
      () async {
        final captured = <String>[];
        final adapter = FakeHttpAdapter()..enqueueJson('{}');

        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
          ..httpClientAdapter = adapter
          ..interceptors.add(LoggingInterceptor(sink: captured.add));

        await dio.get<String>(
          '/v1/rectification',
          queryParameters: <String, dynamic>{
            'api_key': 'SENSITIVE-QUERY-PARAM',
          },
          options: Options(responseType: ResponseType.plain),
        );

        for (final line in captured) {
          expect(line.contains('SENSITIVE-QUERY-PARAM'), isFalse);
          expect(line.contains('api_key'), isFalse);
          expect(line.contains('?'), isFalse);
        }
      },
    );
  });

  group('LoggingInterceptor error logging', () {
    test(
      'badResponse logs the HTTP status and the sanitized provider message',
      () async {
        final captured = <String>[];
        final adapter = FakeHttpAdapter()
          ..enqueueJson(
            '{"success":false,"error":{"code":"INTERNAL_ERROR",'
            '"message":"Range produces 719 candidates, '
            'exceeds maximum 500."}}',
            statusCode: 500,
          );

        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
          ..httpClientAdapter = adapter
          ..interceptors.add(LoggingInterceptor(sink: captured.add));

        try {
          await dio.post<String>(
            '/api/v3/rectification/search',
            options: Options(responseType: ResponseType.plain),
          );
        } on DioException {
          // Expected — the 500 surfaces as a badResponse.
        }

        expect(
          captured.any((line) => line.contains('500')),
          isTrue,
          reason: 'the HTTP status code must be logged',
        );
        expect(
          captured.any((line) => line.contains('exceeds maximum 500')),
          isTrue,
          reason: 'the provider error message must be surfaced',
        );
      },
    );

    test(
      'badResponse log redacts an API key in the provider message',
      () async {
        final captured = <String>[];
        final adapter = FakeHttpAdapter()
          ..enqueueJson(
            '{"error":{"message":'
            '"Key ask_0123456789abcdef0123 was rejected"}}',
            statusCode: 401,
          );

        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
          ..httpClientAdapter = adapter
          ..interceptors.add(LoggingInterceptor(sink: captured.add));

        try {
          await dio.post<String>(
            '/api/v3/rectification/search',
            options: Options(responseType: ResponseType.plain),
          );
        } on DioException {
          // Expected.
        }

        for (final line in captured) {
          expect(
            line.contains('ask_0123456789abcdef0123'),
            isFalse,
            reason: 'the API key must be redacted from "$line"',
          );
        }
        expect(
          captured.any((line) => line.contains('«redacted»')),
          isTrue,
          reason: 'a redaction marker should be present',
        );
      },
    );
  });
}
