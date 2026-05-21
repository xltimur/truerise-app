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

/// Debug logger. This interceptor **never** writes request bodies,
/// request headers, query params, the `Authorization` value, or a
/// successful response body. It emits one line per request (method +
/// path, no query) and one per response (status + latency).
///
/// On an HTTP *error* response it adds a second line carrying the
/// provider's own error message, so a debug run shows *why* a call
/// failed instead of a bare `badResponse`. That message is read only
/// from known error-message fields (never the echoed birth/event
/// payload), secret-redacted, and length-capped.
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
    final status = err.response?.statusCode;
    sink(
      '[rectify] ✗ ${err.type}${status == null ? '' : ' $status'} '
      '${_safePath(err.requestOptions.uri)} ($latency)',
    );
    // On an HTTP error response, surface the provider's own (sanitized)
    // explanation so a debug run shows the cause — e.g. a 4xx
    // validation message — rather than a bare `badResponse`.
    if (err.type == DioExceptionType.badResponse) {
      final detail = _sanitizedErrorDetail(err.response?.data);
      if (detail != null) sink('[rectify]   ↳ $detail');
    }
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
      // 400 (documented) and 422 (FastAPI request validation) both mean
      // the provider rejected the *payload*: surface its explanation
      // and route the user to review their draft, not a generic
      // "try again" server screen.
      if (status == 400 || status == 422) {
        final message =
            _extractProviderMessage(error.response?.data) ??
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

/// Decode [body] to a JSON map when possible.
///
/// Accepts an already-decoded `Map` or a raw JSON `String` — the
/// rectification client keeps the response body as a plain string
/// (`HttpRectificationApi`) so error bodies arrive here unparsed.
Map<String, dynamic>? _asJsonMap(Object? body) {
  if (body is Map<String, dynamic>) return body;
  if (body is String && body.isNotEmpty) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // Not JSON — nothing to extract.
    }
  }
  return null;
}

/// Pull a human-readable error message out of a provider error body.
///
/// Handles the shapes astrology-api.io v3 actually returns:
///   - the v3 envelope `{ "error": { "code": ..., "message": ... } }`
///   - a flat `{ "message": ... }` or `{ "error": "..." }`
///   - FastAPI request-validation `{ "detail": "..." }` or
///     `{ "detail": [ { "loc": [...], "msg": ... } ] }`
///
/// Returns null when no message field is present. Only known
/// message/field-location keys are read — the birth/event payload is
/// never echoed out of here.
String? _extractProviderMessage(Object? body) {
  final json = _asJsonMap(body);
  if (json == null) return null;

  final error = json['error'];
  if (error is Map) {
    final message = error['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();
  }
  if (error is String && error.trim().isNotEmpty) return error.trim();

  final message = json['message'];
  if (message is String && message.trim().isNotEmpty) return message.trim();

  final detail = json['detail'];
  if (detail is String && detail.trim().isNotEmpty) return detail.trim();
  if (detail is List) {
    final parts = <String>[];
    for (final item in detail) {
      if (item is! Map) continue;
      final msg = item['msg'];
      if (msg is! String || msg.trim().isEmpty) continue;
      final loc = item['loc'];
      final field = loc is List
          ? loc.where((e) => e is String || e is int).join('.')
          : '';
      parts.add(field.isEmpty ? msg.trim() : '$field: ${msg.trim()}');
    }
    if (parts.isNotEmpty) return parts.join('; ');
  }
  return null;
}

/// Build a short, secret-free one-liner from a provider error body for
/// the debug log. Reads only the provider's message field, redacts
/// anything resembling an API key / bearer token, and caps the length.
String? _sanitizedErrorDetail(Object? body) {
  final message = _extractProviderMessage(body);
  if (message == null) return null;
  var text = _redactSecrets(message).replaceAll(RegExp(r'\s+'), ' ').trim();
  if (text.isEmpty) return null;
  const maxLength = 200;
  if (text.length > maxLength) text = '${text.substring(0, maxLength)}…';
  return text;
}

/// Mask substrings that look like an astrology-api.io key (`ask_…`) or
/// a bearer token, so a copy-pasted provider message can never leak a
/// credential into the debug log.
String _redactSecrets(String input) => input
    .replaceAll(RegExp('ask_[A-Za-z0-9]{8,}'), 'ask_«redacted»')
    .replaceAll(
      RegExp(r'[Bb]earer\s+[A-Za-z0-9._\-]+'),
      'Bearer «redacted»',
    );

/// Convenience: wrap an [AppFailure] in `Result.err`.
Result<T, AppFailure> errResult<T>(AppFailure failure) =>
    Result<T, AppFailure>.err(failure);
