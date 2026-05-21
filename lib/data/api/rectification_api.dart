import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/api/api_client.dart' show mapDioException;
import 'package:rectify/data/api/dto/rectification_request_dto.dart'
    show RectificationSearchRequestDto;
import 'package:rectify/data/api/dto/rectification_response_dto.dart'
    show RectificationSearchResponseDto;

/// Combined return value from the rectification API: the parsed DTO
/// alongside the verbatim response body so the repository can persist
/// it into the `rawResponseJson` column for support reproductions
/// (`docs/implementation-plan.md` §7.1).
@immutable
class RectificationApiResponse {
  const RectificationApiResponse({required this.dto, required this.rawJson});

  final RectificationSearchResponseDto dto;
  final String rawJson;
}

/// HTTP boundary for the rectification provider
/// (`docs/implementation-plan.md` §9.3).
///
/// The repository talks only to this interface so the demo path,
/// fake-server tests, and a future provider swap don't ripple past
/// the data layer.
abstract class RectificationApi {
  Future<Result<RectificationApiResponse, AppFailure>> rectify(
    RectificationSearchRequestDto request,
  );
}

/// Default HTTP implementation: POSTs to [path] on the configured
/// base URL and decodes the body into [RectificationSearchResponseDto].
///
/// Captures the raw JSON body unchanged so the repository can pass it
/// to the mapper as `rawResponseJson` without re-encoding (re-encoding
/// would lose provider-specific extras useful for support).
class HttpRectificationApi implements RectificationApi {
  HttpRectificationApi(this._dio, {this.path = '/api/v3/rectification/search'});

  final Dio _dio;
  final String path;

  @override
  Future<Result<RectificationApiResponse, AppFailure>> rectify(
    RectificationSearchRequestDto request,
  ) async {
    try {
      // Force a string body so we can keep the exact wire bytes for
      // `rawResponseJson` without round-tripping through Dart maps.
      final response = await _dio.post<String>(
        path,
        data: request.toJson(),
        options: Options(responseType: ResponseType.plain),
      );
      final raw = response.data;
      if (raw == null || raw.isEmpty) {
        return const Err(MalformedResponseFailure());
      }
      try {
        final decoded = jsonDecode(raw);
        if (decoded is! Map<String, dynamic>) {
          return const Err(MalformedResponseFailure());
        }
        final body = _unwrapEnvelope(decoded);
        final dto = RectificationSearchResponseDto.fromJson(body);
        return Result.ok(
          RectificationApiResponse(dto: dto, rawJson: raw),
        );
      } on Object {
        return const Err(MalformedResponseFailure());
      }
    } on DioException catch (error) {
      // Prefer the interceptor's pre-translated failure when present;
      // fall back to the table here for callers that built Dio
      // without `ErrorMappingInterceptor` (tests, ad-hoc clients).
      final mapped = error.error is AppFailure
          ? error.error! as AppFailure
          : mapDioException(error);
      return Result.err(mapped);
    } on Object catch (cause) {
      return Result.err(UnknownFailure(cause));
    }
  }
}

/// astrology-api.io v3 wraps every successful response in
/// `{ "success": true, "data": { ... }, "metadata": {...} }`. The
/// `RectificationSearchResponseDto` models the inner business shape,
/// so peel the envelope here when present and leave bare-shape bodies
/// (used by older tests and the fake adapter) alone.
Map<String, dynamic> _unwrapEnvelope(Map<String, dynamic> body) {
  if (body['success'] == true && body['data'] is Map<String, dynamic>) {
    return body['data'] as Map<String, dynamic>;
  }
  return body;
}
