// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RectificationCandidateDto _$RectificationCandidateDtoFromJson(
  Map<String, dynamic> json,
) => _RectificationCandidateDto(
  rank: (json['rank'] as num).toInt(),
  time: json['time'] as String,
  confidence: (json['confidence'] as num).toDouble(),
  ascendant: json['ascendant'] as String?,
);

Map<String, dynamic> _$RectificationCandidateDtoToJson(
  _RectificationCandidateDto instance,
) => <String, dynamic>{
  'rank': instance.rank,
  'time': instance.time,
  'confidence': instance.confidence,
  'ascendant': instance.ascendant,
};

_RectificationEventMatchDto _$RectificationEventMatchDtoFromJson(
  Map<String, dynamic> json,
) => _RectificationEventMatchDto(
  eventId: json['eventId'] as String,
  matchStrength: json['matchStrength'] as String,
  explanation: json['explanation'] as String,
);

Map<String, dynamic> _$RectificationEventMatchDtoToJson(
  _RectificationEventMatchDto instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'matchStrength': instance.matchStrength,
  'explanation': instance.explanation,
};

_RectificationResponseDto _$RectificationResponseDtoFromJson(
  Map<String, dynamic> json,
) => _RectificationResponseDto(
  calculationId: json['calculationId'] as String,
  candidates: (json['candidates'] as List<dynamic>)
      .map((e) => RectificationCandidateDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  evidence: (json['evidence'] as List<dynamic>)
      .map(
        (e) => RectificationEventMatchDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  method: json['method'] as String?,
);

Map<String, dynamic> _$RectificationResponseDtoToJson(
  _RectificationResponseDto instance,
) => <String, dynamic>{
  'calculationId': instance.calculationId,
  'candidates': instance.candidates,
  'evidence': instance.evidence,
  'method': instance.method,
};
