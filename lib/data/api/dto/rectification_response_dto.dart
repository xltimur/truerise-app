import 'package:freezed_annotation/freezed_annotation.dart';

part 'rectification_response_dto.freezed.dart';
part 'rectification_response_dto.g.dart';

/// Wire-format candidate block returned by the provider.
@freezed
abstract class RectificationCandidateDto with _$RectificationCandidateDto {
  const factory RectificationCandidateDto({
    required int rank,
    required String time,
    required double confidence,
    String? ascendant,
  }) = _RectificationCandidateDto;

  factory RectificationCandidateDto.fromJson(Map<String, dynamic> json) =>
      _$RectificationCandidateDtoFromJson(json);
}

/// Wire-format evidence-per-event block returned by the provider.
@freezed
abstract class RectificationEventMatchDto with _$RectificationEventMatchDto {
  const factory RectificationEventMatchDto({
    required String eventId,
    required String matchStrength,
    required String explanation,
  }) = _RectificationEventMatchDto;

  factory RectificationEventMatchDto.fromJson(Map<String, dynamic> json) =>
      _$RectificationEventMatchDtoFromJson(json);
}

/// Inbound rectification response body
/// (`docs/implementation-plan.md` §7.2, §9.1).
@freezed
abstract class RectificationResponseDto with _$RectificationResponseDto {
  const factory RectificationResponseDto({
    required String calculationId,
    required List<RectificationCandidateDto> candidates,
    required List<RectificationEventMatchDto> evidence,
    String? method,
  }) = _RectificationResponseDto;

  factory RectificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RectificationResponseDtoFromJson(json);
}
