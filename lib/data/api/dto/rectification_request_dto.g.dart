// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectification_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BirthPlaceDto _$BirthPlaceDtoFromJson(Map<String, dynamic> json) =>
    _BirthPlaceDto(
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$BirthPlaceDtoToJson(_BirthPlaceDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_TimeWindowDto _$TimeWindowDtoFromJson(Map<String, dynamic> json) =>
    _TimeWindowDto(
      mode: json['mode'] as String,
      approximateTime: json['approximateTime'] as String?,
      windowMinutes: (json['windowMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TimeWindowDtoToJson(_TimeWindowDto instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'approximateTime': instance.approximateTime,
      'windowMinutes': instance.windowMinutes,
    };

_LifeEventDto _$LifeEventDtoFromJson(Map<String, dynamic> json) =>
    _LifeEventDto(
      id: json['id'] as String,
      category: json['category'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$LifeEventDtoToJson(_LifeEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'year': instance.year,
      'month': instance.month,
      'description': instance.description,
    };

_RectificationRequestDto _$RectificationRequestDtoFromJson(
  Map<String, dynamic> json,
) => _RectificationRequestDto(
  requestId: json['requestId'] as String,
  birthDate: json['birthDate'] as String,
  birthPlace: BirthPlaceDto.fromJson(
    json['birthPlace'] as Map<String, dynamic>,
  ),
  timeWindow: TimeWindowDto.fromJson(
    json['timeWindow'] as Map<String, dynamic>,
  ),
  lifeEvents: (json['lifeEvents'] as List<dynamic>)
      .map((e) => LifeEventDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RectificationRequestDtoToJson(
  _RectificationRequestDto instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'birthDate': instance.birthDate,
  'birthPlace': instance.birthPlace,
  'timeWindow': instance.timeWindow,
  'lifeEvents': instance.lifeEvents,
};
