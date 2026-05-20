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
}
