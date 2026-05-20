import 'package:freezed_annotation/freezed_annotation.dart';

part 'rectification_request_dto.freezed.dart';
part 'rectification_request_dto.g.dart';

/// Wire-format birth place block embedded in [RectificationRequestDto].
@freezed
abstract class BirthPlaceDto with _$BirthPlaceDto {
  const factory BirthPlaceDto({
    required String city,
    required double latitude,
    required double longitude,
  }) = _BirthPlaceDto;

  factory BirthPlaceDto.fromJson(Map<String, dynamic> json) =>
      _$BirthPlaceDtoFromJson(json);
}

/// Wire-format time window block embedded in [RectificationRequestDto].
@freezed
abstract class TimeWindowDto with _$TimeWindowDto {
  const factory TimeWindowDto({
    required String mode,
    String? approximateTime,
    int? windowMinutes,
  }) = _TimeWindowDto;

  factory TimeWindowDto.fromJson(Map<String, dynamic> json) =>
      _$TimeWindowDtoFromJson(json);
}

/// Wire-format event block (one entry per submitted `LifeEvent`).
@freezed
abstract class LifeEventDto with _$LifeEventDto {
  const factory LifeEventDto({
    required String id,
    required String category,
    required int year,
    int? month,
    String? description,
  }) = _LifeEventDto;

  factory LifeEventDto.fromJson(Map<String, dynamic> json) =>
      _$LifeEventDtoFromJson(json);
}

/// Outbound rectification request body
/// (`docs/implementation-plan.md` §7.2, §9.1).
///
/// Mirrors the assumed provider schema in PRD §11. Conversion from a
/// domain `CalculationRequest` lives in `lib/data/api/mappers.dart`;
/// no provider-specific names leak past that boundary.
@freezed
abstract class RectificationRequestDto with _$RectificationRequestDto {
  const factory RectificationRequestDto({
    required String requestId,
    required String birthDate,
    required BirthPlaceDto birthPlace,
    required TimeWindowDto timeWindow,
    required List<LifeEventDto> lifeEvents,
  }) = _RectificationRequestDto;

  factory RectificationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RectificationRequestDtoFromJson(json);
}
