import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Lightweight fake [HttpClientAdapter] that returns canned bytes for
/// the next request, records every captured request, and exposes a
/// hook for simulating Dio's various error types
/// (`DioExceptionType.connectionError`, `connectionTimeout`, …).
///
/// Replacement for `pkg:dio_test` so the suite doesn't take an extra
/// dependency just to drive Phase 6 mappings.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter();

  final List<CapturedRequest> requests = <CapturedRequest>[];
  _CannedResponse? _next;
  DioExceptionType? _nextFailure;

  /// Seed the next response. [body] is the verbatim response body.
  void enqueueJson(String body, {int statusCode = 200}) {
    _next = _CannedResponse(
      bytes: Uint8List.fromList(utf8.encode(body)),
      statusCode: statusCode,
      contentType: 'application/json; charset=utf-8',
    );
  }

  /// Seed a non-JSON or empty body — used to drive the malformed path.
  void enqueueBody({
    required String body,
    int statusCode = 200,
    String contentType = 'text/plain',
  }) {
    _next = _CannedResponse(
      bytes: Uint8List.fromList(utf8.encode(body)),
      statusCode: statusCode,
      contentType: contentType,
    );
  }

  /// Simulate a Dio transport failure (timeout, socket error, etc.).
  // ignore: use_setters_to_change_properties — kept as a verb for symmetry
  void enqueueTransportFailure(DioExceptionType type) {
    _nextFailure = type;
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    // Lowercase header keys to mirror the HTTP/2 wire-format and
    // make case-insensitive assertions trivial in tests.
    final headers = options.headers.map<String, List<String>>(
      (key, value) => MapEntry(key.toLowerCase(), <String>[value.toString()]),
    );

    var bodyBytes = Uint8List(0);
    if (requestStream != null) {
      final builder = BytesBuilder(copy: false);
      await requestStream.forEach(builder.add);
      bodyBytes = builder.toBytes();
    }

    requests.add(
      CapturedRequest(
        method: options.method,
        uri: options.uri,
        headers: Map<String, List<String>>.from(headers),
        bodyBytes: bodyBytes,
      ),
    );

    if (_nextFailure != null) {
      final failureType = _nextFailure!;
      _nextFailure = null;
      // Dio surfaces transport failures by inspecting the error thrown
      // from the adapter; the easiest fidelity is to construct a
      // DioException with the right type so the interceptor table
      // matches it 1:1.
      throw DioException(
        requestOptions: options,
        type: failureType,
        error: switch (failureType) {
          DioExceptionType.connectionError => const SocketException(
            'No route to host',
          ),
          _ => 'simulated ${failureType.name}',
        },
      );
    }

    final response = _next;
    if (response == null) {
      throw StateError(
        'FakeHttpAdapter.fetch called but no canned response queued.',
      );
    }
    _next = null;

    return ResponseBody.fromBytes(
      response.bytes,
      response.statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[response.contentType],
      },
    );
  }
}

class CapturedRequest {
  CapturedRequest({
    required this.method,
    required this.uri,
    required this.headers,
    required this.bodyBytes,
  });

  final String method;
  final Uri uri;
  final Map<String, List<String>> headers;
  final Uint8List bodyBytes;

  String get bodyString => utf8.decode(bodyBytes);
}

class _CannedResponse {
  _CannedResponse({
    required this.bytes,
    required this.statusCode,
    required this.contentType,
  });

  final Uint8List bytes;
  final int statusCode;
  final String contentType;
}
