import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';

/// Auth modes the HTTP client supports (`docs/implementation-plan.md`
/// §9.5).
enum AuthMode {
  /// Demo path — repository short-circuits, no HTTP client is built.
  demo,

  /// Default for everyone else: traffic goes through the Rectify
  /// proxy with a public `RECTIFY_PROXY_APP_ID` identifier as the
  /// caller label. The provider key lives only on the proxy.
  proxy,

  /// Pro / Developer mode — the end-user supplied their own provider
  /// key in Settings; that key lives in `flutter_secure_storage` and
  /// is sent as Bearer against the provider URL directly.
  providerDirect,
}

/// Build a configured [Dio] instance for the given auth mode.
///
/// The function refuses to attach a [bearerToken] for [AuthMode.demo]
/// because demo path must never construct an HTTP client at all
/// (`docs/implementation-plan.md` §9.5, §10.4). Callers must short
/// circuit before reaching this function for the demo path.
Dio buildDio({
  required String baseUrl,
  required AuthMode authMode,
  String? bearerToken,
  String? proxyAppId,
  Duration timeout = const Duration(seconds: 30),
  bool enableLogging = kDebugMode,
}) {
  assert(
    authMode != AuthMode.demo,
    'Demo path must never construct a Dio instance — short-circuit '
    'in the repository (see implementation-plan §10.4).',
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (proxyAppId != null && proxyAppId.isNotEmpty)
          'X-Rectify-App-Id': proxyAppId,
      },
    ),
  );

  dio.interceptors.addAll(<Interceptor>[
    if (bearerToken != null && bearerToken.isNotEmpty)
      AuthInterceptor(bearerToken: bearerToken),
    if (enableLogging) const LoggingInterceptor(),
    const ErrorMappingInterceptor(),
  ]);

  return dio;
}

/// Adds `Authorization: Bearer <token>` to every outbound request.
///
/// Reads the token off [bearerToken] at construction time so a key
/// rotation rebuilds the Dio via `dioProvider` (see §9.5) — the
/// interceptor itself is intentionally inert.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.bearerToken});

  final String bearerToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $bearerToken';
    handler.next(options);
  }
}

/// Debug logger. Per §9.2 / §9.5 this interceptor **never** writes
/// request bodies, response bodies, headers, query params, or the
/// `Authorization` value. It emits one line per request: method,
/// URI path (no query), and the response status + latency.
///
/// Exposed (not private) so tests can install it against a fake Dio
/// adapter and assert the redaction guarantee directly.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor({this.sink = _defaultSink});

  /// Hook used by tests to capture emitted lines without parsing
  /// stdout. The default forwards to [debugPrint], which is itself
  /// stripped from release Flutter builds.
  final void Function(String line) sink;

  static void _defaultSink(String line) => debugPrint(line);

  /// Path-only rendering — strips query parameters and userinfo so
  /// nothing query-encoded leaks into the log line.
  static String _safePath(Uri uri) => uri.path.isEmpty ? '/' : uri.path;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['__rectify_start_ms__'] =
        DateTime.now().millisecondsSinceEpoch;
    sink('[rectify] → ${options.method} ${_safePath(options.uri)}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final start = response.requestOptions.extra['__rectify_start_ms__'] as int?;
    final latency = start == null
        ? '?'
        : '${DateTime.now().millisecondsSinceEpoch - start}ms';
    sink(
      '[rectify] ← ${response.statusCode} '
      '${_safePath(response.requestOptions.uri)} ($latency)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final start = err.requestOptions.extra['__rectify_start_ms__'] as int?;
    final latency = start == null
        ? '?'
        : '${DateTime.now().millisecondsSinceEpoch - start}ms';
    sink(
      '[rectify] ✗ ${err.type} ${_safePath(err.requestOptions.uri)} '
      '($latency)',
    );
    handler.next(err);
  }
}

/// Translates `DioException` into the typed [AppFailure] hierarchy
/// (`docs/implementation-plan.md` §9.6).
///
/// `RectificationApi` consumes this via [mapDioException] rather than
/// the interceptor itself; the interceptor exists so non-API callers
/// (geocoding, future analytics opt-out) get the same translation
/// without re-implementing the table.
class ErrorMappingInterceptor extends Interceptor {
  const ErrorMappingInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = mapDioException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
        message: err.message,
      ),
    );
  }
}

/// Convert a `DioException` into an [AppFailure] per §9.6's table.
AppFailure mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NoNetworkFailure();
    case DioExceptionType.badCertificate:
      return UnknownFailure(error);
    case DioExceptionType.cancel:
      return UnknownFailure(error);
    case DioExceptionType.unknown:
      // Often DNS / no network — Dio doesn't always classify cleanly.
      final inner = error.error;
      if (inner != null && inner.toString().toLowerCase().contains('socket')) {
        return const NoNetworkFailure();
      }
      return UnknownFailure(inner ?? error);
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode ?? 0;
      if (status == 400) {
        final message =
            _extractMessage(error.response?.data) ??
            'The provider rejected the request.';
        return BadRequestFailure(message);
      }
      if (status == 401 || status == 403) return const UnauthorizedFailure();
      if (status == 408) return const TimeoutFailure();
      if (status == 429) return const RateLimitedFailure();
      if (status >= 500 && status < 600) return ServerFailure(status);
      return UnknownFailure(error);
  }
}

String? _extractMessage(Object? body) {
  if (body is Map<String, dynamic>) {
    final raw = body['message'] ?? body['error'];
    if (raw is String) return raw;
    return null;
  }
  if (body is String && body.isNotEmpty) {
    // The provider can serve `Content-Type: application/json` while
    // Dio has been asked to keep the response as a string (see
    // [HttpRectificationApi] preserving `rawResponseJson`). Try a
    // best-effort decode so the 400 body's message is surfaced.
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return _extractMessage(decoded);
    } on FormatException {
      // Fall through.
    }
  }
  return null;
}

/// Convenience: wrap an [AppFailure] in `Result.err`.
Result<T, AppFailure> errResult<T>(AppFailure failure) =>
    Result<T, AppFailure>.err(failure);
