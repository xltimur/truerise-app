import 'package:freezed_annotation/freezed_annotation.dart';

part 'rectification_request_dto.freezed.dart';
part 'rectification_request_dto.g.dart';

/// Birth data nested inside [SubjectDto].
///
/// Matches astrology-api.io v3 RectificationSearchRequest.subject.birth_data.
/// Either city+country_code or latitude+longitude may be provided; both sets
/// can be sent together and the provider will prefer coordinates when present.
@freezed
abstract class BirthDataV3Dto with _$BirthDataV3Dto {
  const factory BirthDataV3Dto({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    @Default(0) int second,
    String? city,
    @JsonKey(name: 'country_code') String? countryCode,
    double? latitude,
    double? longitude,
  }) = _BirthDataV3Dto;

  factory BirthDataV3Dto.fromJson(Map<String, dynamic> json) =>
      _$BirthDataV3DtoFromJson(json);
}

/// Subject wrapper required by the provider schema.
@freezed
abstract class SubjectDto with _$SubjectDto {
  @JsonSerializable(explicitToJson: true)
  const factory SubjectDto({
    @JsonKey(name: 'birth_data') required BirthDataV3Dto birthData,
  }) = _SubjectDto;

  factory SubjectDto.fromJson(Map<String, dynamic> json) =>
      _$SubjectDtoFromJson(json);
}

/// Time-search block for the rectification request.
///
/// Approximate mode (known window around a best-guess time):
///   - delta_minutes: half-width of the search window in minutes (± from
///     the estimated birth time).
///   - step_minutes:  resolution of the search grid.
///
/// Unknown / 24h mode (full-day search):
///   - start / end:   HH:MM boundaries of the search window.
///   - step_minutes:  resolution of the search grid.
@freezed
abstract class TimeSearchDto with _$TimeSearchDto {
  const factory TimeSearchDto({
    @JsonKey(name: 'delta_minutes') int? deltaMinutes,
    @JsonKey(name: 'step_minutes') int? stepMinutes,
    String? start,
    String? end,
  }) = _TimeSearchDto;

  factory TimeSearchDto.fromJson(Map<String, dynamic> json) =>
      _$TimeSearchDtoFromJson(json);
}

/// One life-event entry in the rectification request.
///
/// [date] is formatted as:
///   - `YYYY-MM-DD`  when the exact day is known
///   - `YYYY-MM`     when only the month is known ([datePrecision] = "month")
///   - `YYYY`        when only the year is known  ([datePrecision] = "year")
///
/// The provider's `EventInput` schema has no `id` field — events are
/// referenced in the response by `event_index` (their position in this
/// list), and the mapper restores the domain `LifeEvent.id` via that
/// index. Adding an extra field would be silently ignored by the API at
/// best, rejected at worst — so we don't serialize one.
@freezed
abstract class EventV3Dto with _$EventV3Dto {
  const factory EventV3Dto({
    required String category,
    required String date,
    @JsonKey(name: 'date_precision') String? datePrecision,
    String? description,
  }) = _EventV3Dto;

  factory EventV3Dto.fromJson(Map<String, dynamic> json) =>
      _$EventV3DtoFromJson(json);
}

/// Outbound rectification request body for astrology-api.io v3.
///
/// `POST /api/v3/rectification/search`
/// `Authorization: Bearer <user-api-key>`
///
/// Conversion from a domain CalculationRequest lives in
/// `lib/data/api/mappers.dart`; no provider-specific names leak past
/// that boundary.
@freezed
abstract class RectificationSearchRequestDto
    with _$RectificationSearchRequestDto {
  @JsonSerializable(explicitToJson: true)
  const factory RectificationSearchRequestDto({
    required SubjectDto subject,
    @JsonKey(name: 'time_search') required TimeSearchDto timeSearch,
    required List<EventV3Dto> events,
  }) = _RectificationSearchRequestDto;

  factory RectificationSearchRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RectificationSearchRequestDtoFromJson(json);
}
