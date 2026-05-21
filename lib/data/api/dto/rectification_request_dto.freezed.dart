// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rectification_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BirthDataV3Dto {

 int get year; int get month; int get day; int get hour; int get minute; int get second; String? get city;@JsonKey(name: 'country_code') String? get countryCode; double? get latitude; double? get longitude;
/// Create a copy of BirthDataV3Dto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthDataV3DtoCopyWith<BirthDataV3Dto> get copyWith => _$BirthDataV3DtoCopyWithImpl<BirthDataV3Dto>(this as BirthDataV3Dto, _$identity);

  /// Serializes this BirthDataV3Dto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthDataV3Dto&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.day, day) || other.day == day)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.second, second) || other.second == second)&&(identical(other.city, city) || other.city == city)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,day,hour,minute,second,city,countryCode,latitude,longitude);

@override
String toString() {
  return 'BirthDataV3Dto(year: $year, month: $month, day: $day, hour: $hour, minute: $minute, second: $second, city: $city, countryCode: $countryCode, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $BirthDataV3DtoCopyWith<$Res>  {
  factory $BirthDataV3DtoCopyWith(BirthDataV3Dto value, $Res Function(BirthDataV3Dto) _then) = _$BirthDataV3DtoCopyWithImpl;
@useResult
$Res call({
 int year, int month, int day, int hour, int minute, int second, String? city,@JsonKey(name: 'country_code') String? countryCode, double? latitude, double? longitude
});




}
/// @nodoc
class _$BirthDataV3DtoCopyWithImpl<$Res>
    implements $BirthDataV3DtoCopyWith<$Res> {
  _$BirthDataV3DtoCopyWithImpl(this._self, this._then);

  final BirthDataV3Dto _self;
  final $Res Function(BirthDataV3Dto) _then;

/// Create a copy of BirthDataV3Dto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? day = null,Object? hour = null,Object? minute = null,Object? second = null,Object? city = freezed,Object? countryCode = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,second: null == second ? _self.second : second // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BirthDataV3Dto].
extension BirthDataV3DtoPatterns on BirthDataV3Dto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BirthDataV3Dto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BirthDataV3Dto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BirthDataV3Dto value)  $default,){
final _that = this;
switch (_that) {
case _BirthDataV3Dto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BirthDataV3Dto value)?  $default,){
final _that = this;
switch (_that) {
case _BirthDataV3Dto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  int day,  int hour,  int minute,  int second,  String? city, @JsonKey(name: 'country_code')  String? countryCode,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BirthDataV3Dto() when $default != null:
return $default(_that.year,_that.month,_that.day,_that.hour,_that.minute,_that.second,_that.city,_that.countryCode,_that.latitude,_that.longitude);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  int day,  int hour,  int minute,  int second,  String? city, @JsonKey(name: 'country_code')  String? countryCode,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _BirthDataV3Dto():
return $default(_that.year,_that.month,_that.day,_that.hour,_that.minute,_that.second,_that.city,_that.countryCode,_that.latitude,_that.longitude);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  int day,  int hour,  int minute,  int second,  String? city, @JsonKey(name: 'country_code')  String? countryCode,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _BirthDataV3Dto() when $default != null:
return $default(_that.year,_that.month,_that.day,_that.hour,_that.minute,_that.second,_that.city,_that.countryCode,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BirthDataV3Dto implements BirthDataV3Dto {
  const _BirthDataV3Dto({required this.year, required this.month, required this.day, required this.hour, required this.minute, this.second = 0, this.city, @JsonKey(name: 'country_code') this.countryCode, this.latitude, this.longitude});
  factory _BirthDataV3Dto.fromJson(Map<String, dynamic> json) => _$BirthDataV3DtoFromJson(json);

@override final  int year;
@override final  int month;
@override final  int day;
@override final  int hour;
@override final  int minute;
@override@JsonKey() final  int second;
@override final  String? city;
@override@JsonKey(name: 'country_code') final  String? countryCode;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of BirthDataV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BirthDataV3DtoCopyWith<_BirthDataV3Dto> get copyWith => __$BirthDataV3DtoCopyWithImpl<_BirthDataV3Dto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BirthDataV3DtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BirthDataV3Dto&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.day, day) || other.day == day)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.second, second) || other.second == second)&&(identical(other.city, city) || other.city == city)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,day,hour,minute,second,city,countryCode,latitude,longitude);

@override
String toString() {
  return 'BirthDataV3Dto(year: $year, month: $month, day: $day, hour: $hour, minute: $minute, second: $second, city: $city, countryCode: $countryCode, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$BirthDataV3DtoCopyWith<$Res> implements $BirthDataV3DtoCopyWith<$Res> {
  factory _$BirthDataV3DtoCopyWith(_BirthDataV3Dto value, $Res Function(_BirthDataV3Dto) _then) = __$BirthDataV3DtoCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, int day, int hour, int minute, int second, String? city,@JsonKey(name: 'country_code') String? countryCode, double? latitude, double? longitude
});




}
/// @nodoc
class __$BirthDataV3DtoCopyWithImpl<$Res>
    implements _$BirthDataV3DtoCopyWith<$Res> {
  __$BirthDataV3DtoCopyWithImpl(this._self, this._then);

  final _BirthDataV3Dto _self;
  final $Res Function(_BirthDataV3Dto) _then;

/// Create a copy of BirthDataV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? day = null,Object? hour = null,Object? minute = null,Object? second = null,Object? city = freezed,Object? countryCode = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_BirthDataV3Dto(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,second: null == second ? _self.second : second // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$SubjectDto {

@JsonKey(name: 'birth_data') BirthDataV3Dto get birthData;
/// Create a copy of SubjectDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectDtoCopyWith<SubjectDto> get copyWith => _$SubjectDtoCopyWithImpl<SubjectDto>(this as SubjectDto, _$identity);

  /// Serializes this SubjectDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubjectDto&&(identical(other.birthData, birthData) || other.birthData == birthData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,birthData);

@override
String toString() {
  return 'SubjectDto(birthData: $birthData)';
}


}

/// @nodoc
abstract mixin class $SubjectDtoCopyWith<$Res>  {
  factory $SubjectDtoCopyWith(SubjectDto value, $Res Function(SubjectDto) _then) = _$SubjectDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'birth_data') BirthDataV3Dto birthData
});


$BirthDataV3DtoCopyWith<$Res> get birthData;

}
/// @nodoc
class _$SubjectDtoCopyWithImpl<$Res>
    implements $SubjectDtoCopyWith<$Res> {
  _$SubjectDtoCopyWithImpl(this._self, this._then);

  final SubjectDto _self;
  final $Res Function(SubjectDto) _then;

/// Create a copy of SubjectDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? birthData = null,}) {
  return _then(_self.copyWith(
birthData: null == birthData ? _self.birthData : birthData // ignore: cast_nullable_to_non_nullable
as BirthDataV3Dto,
  ));
}
/// Create a copy of SubjectDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthDataV3DtoCopyWith<$Res> get birthData {
  
  return $BirthDataV3DtoCopyWith<$Res>(_self.birthData, (value) {
    return _then(_self.copyWith(birthData: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubjectDto].
extension SubjectDtoPatterns on SubjectDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubjectDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubjectDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubjectDto value)  $default,){
final _that = this;
switch (_that) {
case _SubjectDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubjectDto value)?  $default,){
final _that = this;
switch (_that) {
case _SubjectDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'birth_data')  BirthDataV3Dto birthData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubjectDto() when $default != null:
return $default(_that.birthData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'birth_data')  BirthDataV3Dto birthData)  $default,) {final _that = this;
switch (_that) {
case _SubjectDto():
return $default(_that.birthData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'birth_data')  BirthDataV3Dto birthData)?  $default,) {final _that = this;
switch (_that) {
case _SubjectDto() when $default != null:
return $default(_that.birthData);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SubjectDto implements SubjectDto {
  const _SubjectDto({@JsonKey(name: 'birth_data') required this.birthData});
  factory _SubjectDto.fromJson(Map<String, dynamic> json) => _$SubjectDtoFromJson(json);

@override@JsonKey(name: 'birth_data') final  BirthDataV3Dto birthData;

/// Create a copy of SubjectDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectDtoCopyWith<_SubjectDto> get copyWith => __$SubjectDtoCopyWithImpl<_SubjectDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubjectDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubjectDto&&(identical(other.birthData, birthData) || other.birthData == birthData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,birthData);

@override
String toString() {
  return 'SubjectDto(birthData: $birthData)';
}


}

/// @nodoc
abstract mixin class _$SubjectDtoCopyWith<$Res> implements $SubjectDtoCopyWith<$Res> {
  factory _$SubjectDtoCopyWith(_SubjectDto value, $Res Function(_SubjectDto) _then) = __$SubjectDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'birth_data') BirthDataV3Dto birthData
});


@override $BirthDataV3DtoCopyWith<$Res> get birthData;

}
/// @nodoc
class __$SubjectDtoCopyWithImpl<$Res>
    implements _$SubjectDtoCopyWith<$Res> {
  __$SubjectDtoCopyWithImpl(this._self, this._then);

  final _SubjectDto _self;
  final $Res Function(_SubjectDto) _then;

/// Create a copy of SubjectDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? birthData = null,}) {
  return _then(_SubjectDto(
birthData: null == birthData ? _self.birthData : birthData // ignore: cast_nullable_to_non_nullable
as BirthDataV3Dto,
  ));
}

/// Create a copy of SubjectDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthDataV3DtoCopyWith<$Res> get birthData {
  
  return $BirthDataV3DtoCopyWith<$Res>(_self.birthData, (value) {
    return _then(_self.copyWith(birthData: value));
  });
}
}


/// @nodoc
mixin _$TimeSearchDto {

@JsonKey(name: 'delta_minutes') int? get deltaMinutes;@JsonKey(name: 'step_minutes') int? get stepMinutes; String? get start; String? get end;
/// Create a copy of TimeSearchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSearchDtoCopyWith<TimeSearchDto> get copyWith => _$TimeSearchDtoCopyWithImpl<TimeSearchDto>(this as TimeSearchDto, _$identity);

  /// Serializes this TimeSearchDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSearchDto&&(identical(other.deltaMinutes, deltaMinutes) || other.deltaMinutes == deltaMinutes)&&(identical(other.stepMinutes, stepMinutes) || other.stepMinutes == stepMinutes)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deltaMinutes,stepMinutes,start,end);

@override
String toString() {
  return 'TimeSearchDto(deltaMinutes: $deltaMinutes, stepMinutes: $stepMinutes, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $TimeSearchDtoCopyWith<$Res>  {
  factory $TimeSearchDtoCopyWith(TimeSearchDto value, $Res Function(TimeSearchDto) _then) = _$TimeSearchDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'delta_minutes') int? deltaMinutes,@JsonKey(name: 'step_minutes') int? stepMinutes, String? start, String? end
});




}
/// @nodoc
class _$TimeSearchDtoCopyWithImpl<$Res>
    implements $TimeSearchDtoCopyWith<$Res> {
  _$TimeSearchDtoCopyWithImpl(this._self, this._then);

  final TimeSearchDto _self;
  final $Res Function(TimeSearchDto) _then;

/// Create a copy of TimeSearchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deltaMinutes = freezed,Object? stepMinutes = freezed,Object? start = freezed,Object? end = freezed,}) {
  return _then(_self.copyWith(
deltaMinutes: freezed == deltaMinutes ? _self.deltaMinutes : deltaMinutes // ignore: cast_nullable_to_non_nullable
as int?,stepMinutes: freezed == stepMinutes ? _self.stepMinutes : stepMinutes // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSearchDto].
extension TimeSearchDtoPatterns on TimeSearchDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSearchDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSearchDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSearchDto value)  $default,){
final _that = this;
switch (_that) {
case _TimeSearchDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSearchDto value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSearchDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'delta_minutes')  int? deltaMinutes, @JsonKey(name: 'step_minutes')  int? stepMinutes,  String? start,  String? end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSearchDto() when $default != null:
return $default(_that.deltaMinutes,_that.stepMinutes,_that.start,_that.end);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'delta_minutes')  int? deltaMinutes, @JsonKey(name: 'step_minutes')  int? stepMinutes,  String? start,  String? end)  $default,) {final _that = this;
switch (_that) {
case _TimeSearchDto():
return $default(_that.deltaMinutes,_that.stepMinutes,_that.start,_that.end);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'delta_minutes')  int? deltaMinutes, @JsonKey(name: 'step_minutes')  int? stepMinutes,  String? start,  String? end)?  $default,) {final _that = this;
switch (_that) {
case _TimeSearchDto() when $default != null:
return $default(_that.deltaMinutes,_that.stepMinutes,_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSearchDto implements TimeSearchDto {
  const _TimeSearchDto({@JsonKey(name: 'delta_minutes') this.deltaMinutes, @JsonKey(name: 'step_minutes') this.stepMinutes, this.start, this.end});
  factory _TimeSearchDto.fromJson(Map<String, dynamic> json) => _$TimeSearchDtoFromJson(json);

@override@JsonKey(name: 'delta_minutes') final  int? deltaMinutes;
@override@JsonKey(name: 'step_minutes') final  int? stepMinutes;
@override final  String? start;
@override final  String? end;

/// Create a copy of TimeSearchDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSearchDtoCopyWith<_TimeSearchDto> get copyWith => __$TimeSearchDtoCopyWithImpl<_TimeSearchDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSearchDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSearchDto&&(identical(other.deltaMinutes, deltaMinutes) || other.deltaMinutes == deltaMinutes)&&(identical(other.stepMinutes, stepMinutes) || other.stepMinutes == stepMinutes)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deltaMinutes,stepMinutes,start,end);

@override
String toString() {
  return 'TimeSearchDto(deltaMinutes: $deltaMinutes, stepMinutes: $stepMinutes, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$TimeSearchDtoCopyWith<$Res> implements $TimeSearchDtoCopyWith<$Res> {
  factory _$TimeSearchDtoCopyWith(_TimeSearchDto value, $Res Function(_TimeSearchDto) _then) = __$TimeSearchDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'delta_minutes') int? deltaMinutes,@JsonKey(name: 'step_minutes') int? stepMinutes, String? start, String? end
});




}
/// @nodoc
class __$TimeSearchDtoCopyWithImpl<$Res>
    implements _$TimeSearchDtoCopyWith<$Res> {
  __$TimeSearchDtoCopyWithImpl(this._self, this._then);

  final _TimeSearchDto _self;
  final $Res Function(_TimeSearchDto) _then;

/// Create a copy of TimeSearchDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deltaMinutes = freezed,Object? stepMinutes = freezed,Object? start = freezed,Object? end = freezed,}) {
  return _then(_TimeSearchDto(
deltaMinutes: freezed == deltaMinutes ? _self.deltaMinutes : deltaMinutes // ignore: cast_nullable_to_non_nullable
as int?,stepMinutes: freezed == stepMinutes ? _self.stepMinutes : stepMinutes // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EventV3Dto {

 String get category; String get date;@JsonKey(name: 'date_precision') String? get datePrecision; String? get description;
/// Create a copy of EventV3Dto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventV3DtoCopyWith<EventV3Dto> get copyWith => _$EventV3DtoCopyWithImpl<EventV3Dto>(this as EventV3Dto, _$identity);

  /// Serializes this EventV3Dto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventV3Dto&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date)&&(identical(other.datePrecision, datePrecision) || other.datePrecision == datePrecision)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,date,datePrecision,description);

@override
String toString() {
  return 'EventV3Dto(category: $category, date: $date, datePrecision: $datePrecision, description: $description)';
}


}

/// @nodoc
abstract mixin class $EventV3DtoCopyWith<$Res>  {
  factory $EventV3DtoCopyWith(EventV3Dto value, $Res Function(EventV3Dto) _then) = _$EventV3DtoCopyWithImpl;
@useResult
$Res call({
 String category, String date,@JsonKey(name: 'date_precision') String? datePrecision, String? description
});




}
/// @nodoc
class _$EventV3DtoCopyWithImpl<$Res>
    implements $EventV3DtoCopyWith<$Res> {
  _$EventV3DtoCopyWithImpl(this._self, this._then);

  final EventV3Dto _self;
  final $Res Function(EventV3Dto) _then;

/// Create a copy of EventV3Dto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? date = null,Object? datePrecision = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,datePrecision: freezed == datePrecision ? _self.datePrecision : datePrecision // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventV3Dto].
extension EventV3DtoPatterns on EventV3Dto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventV3Dto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventV3Dto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventV3Dto value)  $default,){
final _that = this;
switch (_that) {
case _EventV3Dto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventV3Dto value)?  $default,){
final _that = this;
switch (_that) {
case _EventV3Dto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  String date, @JsonKey(name: 'date_precision')  String? datePrecision,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventV3Dto() when $default != null:
return $default(_that.category,_that.date,_that.datePrecision,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  String date, @JsonKey(name: 'date_precision')  String? datePrecision,  String? description)  $default,) {final _that = this;
switch (_that) {
case _EventV3Dto():
return $default(_that.category,_that.date,_that.datePrecision,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  String date, @JsonKey(name: 'date_precision')  String? datePrecision,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _EventV3Dto() when $default != null:
return $default(_that.category,_that.date,_that.datePrecision,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventV3Dto implements EventV3Dto {
  const _EventV3Dto({required this.category, required this.date, @JsonKey(name: 'date_precision') this.datePrecision, this.description});
  factory _EventV3Dto.fromJson(Map<String, dynamic> json) => _$EventV3DtoFromJson(json);

@override final  String category;
@override final  String date;
@override@JsonKey(name: 'date_precision') final  String? datePrecision;
@override final  String? description;

/// Create a copy of EventV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventV3DtoCopyWith<_EventV3Dto> get copyWith => __$EventV3DtoCopyWithImpl<_EventV3Dto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventV3DtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventV3Dto&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date)&&(identical(other.datePrecision, datePrecision) || other.datePrecision == datePrecision)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,date,datePrecision,description);

@override
String toString() {
  return 'EventV3Dto(category: $category, date: $date, datePrecision: $datePrecision, description: $description)';
}


}

/// @nodoc
abstract mixin class _$EventV3DtoCopyWith<$Res> implements $EventV3DtoCopyWith<$Res> {
  factory _$EventV3DtoCopyWith(_EventV3Dto value, $Res Function(_EventV3Dto) _then) = __$EventV3DtoCopyWithImpl;
@override @useResult
$Res call({
 String category, String date,@JsonKey(name: 'date_precision') String? datePrecision, String? description
});




}
/// @nodoc
class __$EventV3DtoCopyWithImpl<$Res>
    implements _$EventV3DtoCopyWith<$Res> {
  __$EventV3DtoCopyWithImpl(this._self, this._then);

  final _EventV3Dto _self;
  final $Res Function(_EventV3Dto) _then;

/// Create a copy of EventV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? date = null,Object? datePrecision = freezed,Object? description = freezed,}) {
  return _then(_EventV3Dto(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,datePrecision: freezed == datePrecision ? _self.datePrecision : datePrecision // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RectificationSearchRequestDto {

 SubjectDto get subject;@JsonKey(name: 'time_search') TimeSearchDto get timeSearch; List<EventV3Dto> get events;
/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RectificationSearchRequestDtoCopyWith<RectificationSearchRequestDto> get copyWith => _$RectificationSearchRequestDtoCopyWithImpl<RectificationSearchRequestDto>(this as RectificationSearchRequestDto, _$identity);

  /// Serializes this RectificationSearchRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RectificationSearchRequestDto&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.timeSearch, timeSearch) || other.timeSearch == timeSearch)&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,timeSearch,const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'RectificationSearchRequestDto(subject: $subject, timeSearch: $timeSearch, events: $events)';
}


}

/// @nodoc
abstract mixin class $RectificationSearchRequestDtoCopyWith<$Res>  {
  factory $RectificationSearchRequestDtoCopyWith(RectificationSearchRequestDto value, $Res Function(RectificationSearchRequestDto) _then) = _$RectificationSearchRequestDtoCopyWithImpl;
@useResult
$Res call({
 SubjectDto subject,@JsonKey(name: 'time_search') TimeSearchDto timeSearch, List<EventV3Dto> events
});


$SubjectDtoCopyWith<$Res> get subject;$TimeSearchDtoCopyWith<$Res> get timeSearch;

}
/// @nodoc
class _$RectificationSearchRequestDtoCopyWithImpl<$Res>
    implements $RectificationSearchRequestDtoCopyWith<$Res> {
  _$RectificationSearchRequestDtoCopyWithImpl(this._self, this._then);

  final RectificationSearchRequestDto _self;
  final $Res Function(RectificationSearchRequestDto) _then;

/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? timeSearch = null,Object? events = null,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as SubjectDto,timeSearch: null == timeSearch ? _self.timeSearch : timeSearch // ignore: cast_nullable_to_non_nullable
as TimeSearchDto,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<EventV3Dto>,
  ));
}
/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubjectDtoCopyWith<$Res> get subject {
  
  return $SubjectDtoCopyWith<$Res>(_self.subject, (value) {
    return _then(_self.copyWith(subject: value));
  });
}/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSearchDtoCopyWith<$Res> get timeSearch {
  
  return $TimeSearchDtoCopyWith<$Res>(_self.timeSearch, (value) {
    return _then(_self.copyWith(timeSearch: value));
  });
}
}


/// Adds pattern-matching-related methods to [RectificationSearchRequestDto].
extension RectificationSearchRequestDtoPatterns on RectificationSearchRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RectificationSearchRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RectificationSearchRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RectificationSearchRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _RectificationSearchRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RectificationSearchRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _RectificationSearchRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SubjectDto subject, @JsonKey(name: 'time_search')  TimeSearchDto timeSearch,  List<EventV3Dto> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RectificationSearchRequestDto() when $default != null:
return $default(_that.subject,_that.timeSearch,_that.events);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SubjectDto subject, @JsonKey(name: 'time_search')  TimeSearchDto timeSearch,  List<EventV3Dto> events)  $default,) {final _that = this;
switch (_that) {
case _RectificationSearchRequestDto():
return $default(_that.subject,_that.timeSearch,_that.events);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SubjectDto subject, @JsonKey(name: 'time_search')  TimeSearchDto timeSearch,  List<EventV3Dto> events)?  $default,) {final _that = this;
switch (_that) {
case _RectificationSearchRequestDto() when $default != null:
return $default(_that.subject,_that.timeSearch,_that.events);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RectificationSearchRequestDto implements RectificationSearchRequestDto {
  const _RectificationSearchRequestDto({required this.subject, @JsonKey(name: 'time_search') required this.timeSearch, required final  List<EventV3Dto> events}): _events = events;
  factory _RectificationSearchRequestDto.fromJson(Map<String, dynamic> json) => _$RectificationSearchRequestDtoFromJson(json);

@override final  SubjectDto subject;
@override@JsonKey(name: 'time_search') final  TimeSearchDto timeSearch;
 final  List<EventV3Dto> _events;
@override List<EventV3Dto> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RectificationSearchRequestDtoCopyWith<_RectificationSearchRequestDto> get copyWith => __$RectificationSearchRequestDtoCopyWithImpl<_RectificationSearchRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RectificationSearchRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RectificationSearchRequestDto&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.timeSearch, timeSearch) || other.timeSearch == timeSearch)&&const DeepCollectionEquality().equals(other._events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,timeSearch,const DeepCollectionEquality().hash(_events));

@override
String toString() {
  return 'RectificationSearchRequestDto(subject: $subject, timeSearch: $timeSearch, events: $events)';
}


}

/// @nodoc
abstract mixin class _$RectificationSearchRequestDtoCopyWith<$Res> implements $RectificationSearchRequestDtoCopyWith<$Res> {
  factory _$RectificationSearchRequestDtoCopyWith(_RectificationSearchRequestDto value, $Res Function(_RectificationSearchRequestDto) _then) = __$RectificationSearchRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 SubjectDto subject,@JsonKey(name: 'time_search') TimeSearchDto timeSearch, List<EventV3Dto> events
});


@override $SubjectDtoCopyWith<$Res> get subject;@override $TimeSearchDtoCopyWith<$Res> get timeSearch;

}
/// @nodoc
class __$RectificationSearchRequestDtoCopyWithImpl<$Res>
    implements _$RectificationSearchRequestDtoCopyWith<$Res> {
  __$RectificationSearchRequestDtoCopyWithImpl(this._self, this._then);

  final _RectificationSearchRequestDto _self;
  final $Res Function(_RectificationSearchRequestDto) _then;

/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? timeSearch = null,Object? events = null,}) {
  return _then(_RectificationSearchRequestDto(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as SubjectDto,timeSearch: null == timeSearch ? _self.timeSearch : timeSearch // ignore: cast_nullable_to_non_nullable
as TimeSearchDto,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<EventV3Dto>,
  ));
}

/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubjectDtoCopyWith<$Res> get subject {
  
  return $SubjectDtoCopyWith<$Res>(_self.subject, (value) {
    return _then(_self.copyWith(subject: value));
  });
}/// Create a copy of RectificationSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSearchDtoCopyWith<$Res> get timeSearch {
  
  return $TimeSearchDtoCopyWith<$Res>(_self.timeSearch, (value) {
    return _then(_self.copyWith(timeSearch: value));
  });
}
}

// dart format on
