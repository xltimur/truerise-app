import 'package:freezed_annotation/freezed_annotation.dart';

part 'rectification_response_dto.freezed.dart';
part 'rectification_response_dto.g.dart';

/// Per-event scoring entry inside a candidate (`event_scores[]`).
///
/// The provider returns one of these per (candidate × enabled event)
/// pair. `event_index` references the position of the event in the
/// original request `events[]` array, which is how the mapper
/// reconstructs the domain `LifeEvent.id`.
@freezed
abstract class EventScoreDto with _$EventScoreDto {
  const factory EventScoreDto({
    @JsonKey(name: 'event_index') required int eventIndex,
    @JsonKey(name: 'event_date') required String eventDate,
    @JsonKey(name: 'event_category') required String eventCategory,
    @JsonKey(name: 'event_description') String? eventDescription,
    @JsonKey(name: 'total_score') @Default(0.0) double totalScore,
    String? interpretation,
  }) = _EventScoreDto;

  factory EventScoreDto.fromJson(Map<String, dynamic> json) =>
      _$EventScoreDtoFromJson(json);
}

/// One birth-time candidate in the provider response.
///
/// Maps `CandidateResult` from astrology-api.io v3. The full `chart`
/// payload is preserved as a raw map so the mapper can extract the
/// ascendant lazily without modeling 200+ chart fields.
@freezed
abstract class CandidateV3Dto with _$CandidateV3Dto {
  const factory CandidateV3Dto({
    required int rank,
    required String time,
    @JsonKey(name: 'aggregate_score') @Default(0.0) double aggregateScore,
    @JsonKey(name: 'normalized_score') @Default(0.0) double normalizedScore,
    @Default('') String grade,
    @JsonKey(name: 'event_scores')
    @Default(<EventScoreDto>[])
    List<EventScoreDto> eventScores,
    @JsonKey(name: 'events_strongly_correlated')
    @Default(0)
    int eventsStronglyCorrelated,
    @Default(false) bool excluded,
    @JsonKey(name: 'excluded_reason') String? excludedReason,
    String? error,
    @JsonKey(name: 'anchor_grade') @Default(false) bool anchorGrade,
    Map<String, dynamic>? chart,
  }) = _CandidateV3Dto;

  factory CandidateV3Dto.fromJson(Map<String, dynamic> json) =>
      _$CandidateV3DtoFromJson(json);
}

/// Confidence block nested inside [SummaryV3Dto].
@freezed
abstract class ConfidenceAssessmentDto with _$ConfidenceAssessmentDto {
  const factory ConfidenceAssessmentDto({
    @Default('') String level,
    @Default('') String explanation,
    @JsonKey(name: 'gap_ratio') @Default(0.0) double gapRatio,
    @JsonKey(name: 'lift_ratio') @Default(0.0) double liftRatio,
  }) = _ConfidenceAssessmentDto;

  factory ConfidenceAssessmentDto.fromJson(Map<String, dynamic> json) =>
      _$ConfidenceAssessmentDtoFromJson(json);
}

/// Search-level summary returned alongside `candidates`.
///
/// All fields are typed as optional in this DTO even when the spec
/// marks them required, so an additive provider change (a removed
/// field, a renamed nested block) doesn't take the whole response
/// down with a `MalformedResponseFailure`. The mapper consults the
/// fields it understands and ignores the rest.
@freezed
abstract class SummaryV3Dto with _$SummaryV3Dto {
  const factory SummaryV3Dto({
    ConfidenceAssessmentDto? confidence,
    @JsonKey(name: 'peak_time') String? peakTime,
    @JsonKey(name: 'techniques_used')
    @Default(<String>[])
    List<String> techniquesUsed,
    @JsonKey(name: 'step_minutes') int? stepMinutes,
    @JsonKey(name: 'total_candidates_returned') int? totalCandidatesReturned,
    @JsonKey(name: 'quality_advisory') String? qualityAdvisory,
  }) = _SummaryV3Dto;

  factory SummaryV3Dto.fromJson(Map<String, dynamic> json) =>
      _$SummaryV3DtoFromJson(json);
}

/// Inbound response body from `POST /api/v3/rectification/search`.
///
/// `candidates` is the only field this app uses for the result view;
/// `summary` and `computed_at` are kept for diagnostics. Unknown
/// provider extras (`density`, etc.) are dropped silently — the
/// repository still persists the full raw payload in
/// `saved_calculations.rawResponseJson` for support reproductions.
@freezed
abstract class RectificationSearchResponseDto
    with _$RectificationSearchResponseDto {
  const factory RectificationSearchResponseDto({
    required List<CandidateV3Dto> candidates,
    SummaryV3Dto? summary,
    @JsonKey(name: 'computed_at') String? computedAt,
  }) = _RectificationSearchResponseDto;

  factory RectificationSearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RectificationSearchResponseDtoFromJson(json);
}
