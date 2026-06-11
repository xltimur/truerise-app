import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rectify/core/update/update_info.dart';

/// Fetches the owner-hosted version JSON (see [UpdateInfo] for the
/// contract) over a deliberately bare HTTP client.
///
/// This client is **separate** from the rectification `dioProvider`
/// stack on purpose: it sends no Authorization header, no app id, and no
/// interceptors that could attach anything beyond the plain GET of a
/// public URL. Every failure mode — timeout, non-2xx, malformed body —
/// collapses to `null`: the update check must never break or delay the
/// app.
class UpdateInfoFetcher {
  UpdateInfoFetcher({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: _timeout,
              receiveTimeout: _timeout,
              sendTimeout: _timeout,
              headers: <String, Object?>{'Accept': 'application/json'},
            ),
          );

  /// Short on purpose: a version probe is best-effort background work.
  static const Duration _timeout = Duration(seconds: 10);

  final Dio _dio;

  Future<UpdateInfo?> fetch(String url) async {
    try {
      final response = await _dio.get<Object?>(url);
      var data = response.data;
      // Hosts that serve static JSON as text/plain hand us a String.
      if (data is String) {
        data = json.decode(data);
      }
      return UpdateInfo.tryParse(data);
    } on Object {
      return null;
    }
  }

  void close() => _dio.close();
}
