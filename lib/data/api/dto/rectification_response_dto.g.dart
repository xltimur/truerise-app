// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventScoreDto _$EventScoreDtoFromJson(Map<String, dynamic> json) =>
    _EventScoreDto(
      eventIndex: (json['event_index'] as num).toInt(),
      eventDate: json['event_date'] as String,
      eventCategory: json['event_category'] as String,
      eventDescription: json['event_description'] as String?,
      totalScore: (json['total_score'] as num?)?.toDouble() ?? 0.0,
      interpretation: json['interpretation'] as String?,
    );

Map<String, dynamic> _$EventScoreDtoToJson(_EventScoreDto instance) =>
    <String, dynamic>{
      'event_index': instance.eventIndex,
      'event_date': instance.eventDate,
      'event_category': instance.eventCategory,
      'event_description': instance.eventDescription,
      'total_score': instance.totalScore,
      'interpretation': instance.interpretation,
    };

_CandidateV3Dto _$CandidateV3DtoFromJson(Map<String, dynamic> json) =>
    _CandidateV3Dto(
      rank: (json['rank'] as num).toInt(),
      time: json['time'] as String,
      aggregateScore: (json['aggregate_score'] as num?)?.toDouble() ?? 0.0,
      normalizedScore: (json['normalized_score'] as num?)?.toDouble() ?? 0.0,
      grade: json['grade'] as String? ?? '',
      eventScores:
          (json['event_scores'] as List<dynamic>?)
              ?.map((e) => EventScoreDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EventScoreDto>[],
      eventsStronglyCorrelated:
          (json['events_strongly_correlated'] as num?)?.toInt() ?? 0,
      excluded: json['excluded'] as bool? ?? false,
      excludedReason: json['excluded_reason'] as String?,
      error: json['error'] as String?,
      anchorGrade: json['anchor_grade'] as bool? ?? false,
      chart: json['chart'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CandidateV3DtoToJson(_CandidateV3Dto instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'time': instance.time,
      'aggregate_score': instance.aggregateScore,
      'normalized_score': instance.normalizedScore,
      'grade': instance.grade,
      'event_scores': instance.eventScores,
      'events_strongly_correlated': instance.eventsStronglyCorrelated,
      'excluded': instance.excluded,
      'excluded_reason': instance.excludedReason,
      'error': instance.error,
      'anchor_grade': instance.anchorGrade,
      'chart': instance.chart,
    };

_ConfidenceAssessmentDto _$ConfidenceAssessmentDtoFromJson(
  Map<String, dynamic> json,
) => _ConfidenceAssessmentDto(
  level: json['level'] as String? ?? '',
  explanation: json['explanation'] as String? ?? '',
  gapRatio: (json['gap_ratio'] as num?)?.toDouble() ?? 0.0,
  liftRatio: (json['lift_ratio'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ConfidenceAssessmentDtoToJson(
  _ConfidenceAssessmentDto instance,
) => <String, dynamic>{
  'level': instance.level,
  'explanation': instance.explanation,
  'gap_ratio': instance.gapRatio,
  'lift_ratio': instance.liftRatio,
};

_SummaryV3Dto _$SummaryV3DtoFromJson(Map<String, dynamic> json) =>
    _SummaryV3Dto(
      confidence: json['confidence'] == null
          ? null
          : ConfidenceAssessmentDto.fromJson(
              json['confidence'] as Map<String, dynamic>,
            ),
      peakTime: json['peak_time'] as String?,
      techniquesUsed:
          (json['techniques_used'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      stepMinutes: (json['step_minutes'] as num?)?.toInt(),
      totalCandidatesReturned: (json['total_candidates_returned'] as num?)
          ?.toInt(),
      qualityAdvisory: json['quality_advisory'] as String?,
    );

Map<String, dynamic> _$SummaryV3DtoToJson(_SummaryV3Dto instance) =>
    <String, dynamic>{
      'confidence': instance.confidence,
      'peak_time': instance.peakTime,
      'techniques_used': instance.techniquesUsed,
      'step_minutes': instance.stepMinutes,
      'total_candidates_returned': instance.totalCandidatesReturned,
      'quality_advisory': instance.qualityAdvisory,
    };

_RectificationSearchResponseDto _$RectificationSearchResponseDtoFromJson(
  Map<String, dynamic> json,
) => _RectificationSearchResponseDto(
  candidates: (json['candidates'] as List<dynamic>)
      .map((e) => CandidateV3Dto.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: json['summary'] == null
      ? null
      : SummaryV3Dto.fromJson(json['summary'] as Map<String, dynamic>),
  computedAt: json['computed_at'] as String?,
);

Map<String, dynamic> _$RectificationSearchResponseDtoToJson(
  _RectificationSearchResponseDto instance,
) => <String, dynamic>{
  'candidates': instance.candidates,
  'summary': instance.summary,
  'computed_at': instance.computedAt,
};
