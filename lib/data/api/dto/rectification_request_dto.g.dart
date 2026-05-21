// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectification_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BirthDataV3Dto _$BirthDataV3DtoFromJson(Map<String, dynamic> json) =>
    _BirthDataV3Dto(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
      second: (json['second'] as num?)?.toInt() ?? 0,
      city: json['city'] as String?,
      countryCode: json['country_code'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BirthDataV3DtoToJson(_BirthDataV3Dto instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'city': instance.city,
      'country_code': instance.countryCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_SubjectDto _$SubjectDtoFromJson(Map<String, dynamic> json) => _SubjectDto(
  birthData: BirthDataV3Dto.fromJson(
    json['birth_data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SubjectDtoToJson(_SubjectDto instance) =>
    <String, dynamic>{'birth_data': instance.birthData.toJson()};

_TimeSearchDto _$TimeSearchDtoFromJson(Map<String, dynamic> json) =>
    _TimeSearchDto(
      deltaMinutes: (json['delta_minutes'] as num?)?.toInt(),
      stepMinutes: (json['step_minutes'] as num?)?.toInt(),
      start: json['start'] as String?,
      end: json['end'] as String?,
    );

Map<String, dynamic> _$TimeSearchDtoToJson(_TimeSearchDto instance) =>
    <String, dynamic>{
      'delta_minutes': instance.deltaMinutes,
      'step_minutes': instance.stepMinutes,
      'start': instance.start,
      'end': instance.end,
    };

_EventV3Dto _$EventV3DtoFromJson(Map<String, dynamic> json) => _EventV3Dto(
  category: json['category'] as String,
  date: json['date'] as String,
  datePrecision: json['date_precision'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$EventV3DtoToJson(_EventV3Dto instance) =>
    <String, dynamic>{
      'category': instance.category,
      'date': instance.date,
      'date_precision': instance.datePrecision,
      'description': instance.description,
    };

_RectificationSearchRequestDto _$RectificationSearchRequestDtoFromJson(
  Map<String, dynamic> json,
) => _RectificationSearchRequestDto(
  subject: SubjectDto.fromJson(json['subject'] as Map<String, dynamic>),
  timeSearch: TimeSearchDto.fromJson(
    json['time_search'] as Map<String, dynamic>,
  ),
  events: (json['events'] as List<dynamic>)
      .map((e) => EventV3Dto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RectificationSearchRequestDtoToJson(
  _RectificationSearchRequestDto instance,
) => <String, dynamic>{
  'subject': instance.subject.toJson(),
  'time_search': instance.timeSearch.toJson(),
  'events': instance.events.map((e) => e.toJson()).toList(),
};
