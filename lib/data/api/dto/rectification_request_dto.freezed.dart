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
mixin _$BirthPlaceDto {

 String get city; double get latitude; double get longitude;
/// Create a copy of BirthPlaceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthPlaceDtoCopyWith<BirthPlaceDto> get copyWith => _$BirthPlaceDtoCopyWithImpl<BirthPlaceDto>(this as BirthPlaceDto, _$identity);

  /// Serializes this BirthPlaceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthPlaceDto&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,city,latitude,longitude);

@override
String toString() {
  return 'BirthPlaceDto(city: $city, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $BirthPlaceDtoCopyWith<$Res>  {
  factory $BirthPlaceDtoCopyWith(BirthPlaceDto value, $Res Function(BirthPlaceDto) _then) = _$BirthPlaceDtoCopyWithImpl;
@useResult
$Res call({
 String city, double latitude, double longitude
});




}
/// @nodoc
class _$BirthPlaceDtoCopyWithImpl<$Res>
    implements $BirthPlaceDtoCopyWith<$Res> {
  _$BirthPlaceDtoCopyWithImpl(this._self, this._then);

  final BirthPlaceDto _self;
  final $Res Function(BirthPlaceDto) _then;

/// Create a copy of BirthPlaceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? city = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BirthPlaceDto].
extension BirthPlaceDtoPatterns on BirthPlaceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BirthPlaceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BirthPlaceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BirthPlaceDto value)  $default,){
final _that = this;
switch (_that) {
case _BirthPlaceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BirthPlaceDto value)?  $default,){
final _that = this;
switch (_that) {
case _BirthPlaceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String city,  double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BirthPlaceDto() when $default != null:
return $default(_that.city,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String city,  double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _BirthPlaceDto():
return $default(_that.city,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String city,  double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _BirthPlaceDto() when $default != null:
return $default(_that.city,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BirthPlaceDto implements BirthPlaceDto {
  const _BirthPlaceDto({required this.city, required this.latitude, required this.longitude});
  factory _BirthPlaceDto.fromJson(Map<String, dynamic> json) => _$BirthPlaceDtoFromJson(json);

@override final  String city;
@override final  double latitude;
@override final  double longitude;

/// Create a copy of BirthPlaceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BirthPlaceDtoCopyWith<_BirthPlaceDto> get copyWith => __$BirthPlaceDtoCopyWithImpl<_BirthPlaceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BirthPlaceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BirthPlaceDto&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,city,latitude,longitude);

@override
String toString() {
  return 'BirthPlaceDto(city: $city, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$BirthPlaceDtoCopyWith<$Res> implements $BirthPlaceDtoCopyWith<$Res> {
  factory _$BirthPlaceDtoCopyWith(_BirthPlaceDto value, $Res Function(_BirthPlaceDto) _then) = __$BirthPlaceDtoCopyWithImpl;
@override @useResult
$Res call({
 String city, double latitude, double longitude
});




}
/// @nodoc
class __$BirthPlaceDtoCopyWithImpl<$Res>
    implements _$BirthPlaceDtoCopyWith<$Res> {
  __$BirthPlaceDtoCopyWithImpl(this._self, this._then);

  final _BirthPlaceDto _self;
  final $Res Function(_BirthPlaceDto) _then;

/// Create a copy of BirthPlaceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_BirthPlaceDto(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TimeWindowDto {

 String get mode; String? get approximateTime; int? get windowMinutes;
/// Create a copy of TimeWindowDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeWindowDtoCopyWith<TimeWindowDto> get copyWith => _$TimeWindowDtoCopyWithImpl<TimeWindowDto>(this as TimeWindowDto, _$identity);

  /// Serializes this TimeWindowDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeWindowDto&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.approximateTime, approximateTime) || other.approximateTime == approximateTime)&&(identical(other.windowMinutes, windowMinutes) || other.windowMinutes == windowMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,approximateTime,windowMinutes);

@override
String toString() {
  return 'TimeWindowDto(mode: $mode, approximateTime: $approximateTime, windowMinutes: $windowMinutes)';
}


}

/// @nodoc
abstract mixin class $TimeWindowDtoCopyWith<$Res>  {
  factory $TimeWindowDtoCopyWith(TimeWindowDto value, $Res Function(TimeWindowDto) _then) = _$TimeWindowDtoCopyWithImpl;
@useResult
$Res call({
 String mode, String? approximateTime, int? windowMinutes
});




}
/// @nodoc
class _$TimeWindowDtoCopyWithImpl<$Res>
    implements $TimeWindowDtoCopyWith<$Res> {
  _$TimeWindowDtoCopyWithImpl(this._self, this._then);

  final TimeWindowDto _self;
  final $Res Function(TimeWindowDto) _then;

/// Create a copy of TimeWindowDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? approximateTime = freezed,Object? windowMinutes = freezed,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,approximateTime: freezed == approximateTime ? _self.approximateTime : approximateTime // ignore: cast_nullable_to_non_nullable
as String?,windowMinutes: freezed == windowMinutes ? _self.windowMinutes : windowMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeWindowDto].
extension TimeWindowDtoPatterns on TimeWindowDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeWindowDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeWindowDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeWindowDto value)  $default,){
final _that = this;
switch (_that) {
case _TimeWindowDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeWindowDto value)?  $default,){
final _that = this;
switch (_that) {
case _TimeWindowDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  String? approximateTime,  int? windowMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeWindowDto() when $default != null:
return $default(_that.mode,_that.approximateTime,_that.windowMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  String? approximateTime,  int? windowMinutes)  $default,) {final _that = this;
switch (_that) {
case _TimeWindowDto():
return $default(_that.mode,_that.approximateTime,_that.windowMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  String? approximateTime,  int? windowMinutes)?  $default,) {final _that = this;
switch (_that) {
case _TimeWindowDto() when $default != null:
return $default(_that.mode,_that.approximateTime,_that.windowMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeWindowDto implements TimeWindowDto {
  const _TimeWindowDto({required this.mode, this.approximateTime, this.windowMinutes});
  factory _TimeWindowDto.fromJson(Map<String, dynamic> json) => _$TimeWindowDtoFromJson(json);

@override final  String mode;
@override final  String? approximateTime;
@override final  int? windowMinutes;

/// Create a copy of TimeWindowDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeWindowDtoCopyWith<_TimeWindowDto> get copyWith => __$TimeWindowDtoCopyWithImpl<_TimeWindowDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeWindowDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeWindowDto&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.approximateTime, approximateTime) || other.approximateTime == approximateTime)&&(identical(other.windowMinutes, windowMinutes) || other.windowMinutes == windowMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,approximateTime,windowMinutes);

@override
String toString() {
  return 'TimeWindowDto(mode: $mode, approximateTime: $approximateTime, windowMinutes: $windowMinutes)';
}


}

/// @nodoc
abstract mixin class _$TimeWindowDtoCopyWith<$Res> implements $TimeWindowDtoCopyWith<$Res> {
  factory _$TimeWindowDtoCopyWith(_TimeWindowDto value, $Res Function(_TimeWindowDto) _then) = __$TimeWindowDtoCopyWithImpl;
@override @useResult
$Res call({
 String mode, String? approximateTime, int? windowMinutes
});




}
/// @nodoc
class __$TimeWindowDtoCopyWithImpl<$Res>
    implements _$TimeWindowDtoCopyWith<$Res> {
  __$TimeWindowDtoCopyWithImpl(this._self, this._then);

  final _TimeWindowDto _self;
  final $Res Function(_TimeWindowDto) _then;

/// Create a copy of TimeWindowDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? approximateTime = freezed,Object? windowMinutes = freezed,}) {
  return _then(_TimeWindowDto(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,approximateTime: freezed == approximateTime ? _self.approximateTime : approximateTime // ignore: cast_nullable_to_non_nullable
as String?,windowMinutes: freezed == windowMinutes ? _self.windowMinutes : windowMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LifeEventDto {

 String get id; String get category; int get year; int? get month; String? get description;
/// Create a copy of LifeEventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LifeEventDtoCopyWith<LifeEventDto> get copyWith => _$LifeEventDtoCopyWithImpl<LifeEventDto>(this as LifeEventDto, _$identity);

  /// Serializes this LifeEventDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LifeEventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,year,month,description);

@override
String toString() {
  return 'LifeEventDto(id: $id, category: $category, year: $year, month: $month, description: $description)';
}


}

/// @nodoc
abstract mixin class $LifeEventDtoCopyWith<$Res>  {
  factory $LifeEventDtoCopyWith(LifeEventDto value, $Res Function(LifeEventDto) _then) = _$LifeEventDtoCopyWithImpl;
@useResult
$Res call({
 String id, String category, int year, int? month, String? description
});




}
/// @nodoc
class _$LifeEventDtoCopyWithImpl<$Res>
    implements $LifeEventDtoCopyWith<$Res> {
  _$LifeEventDtoCopyWithImpl(this._self, this._then);

  final LifeEventDto _self;
  final $Res Function(LifeEventDto) _then;

/// Create a copy of LifeEventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? year = null,Object? month = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LifeEventDto].
extension LifeEventDtoPatterns on LifeEventDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LifeEventDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LifeEventDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LifeEventDto value)  $default,){
final _that = this;
switch (_that) {
case _LifeEventDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LifeEventDto value)?  $default,){
final _that = this;
switch (_that) {
case _LifeEventDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  int year,  int? month,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LifeEventDto() when $default != null:
return $default(_that.id,_that.category,_that.year,_that.month,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  int year,  int? month,  String? description)  $default,) {final _that = this;
switch (_that) {
case _LifeEventDto():
return $default(_that.id,_that.category,_that.year,_that.month,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  int year,  int? month,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _LifeEventDto() when $default != null:
return $default(_that.id,_that.category,_that.year,_that.month,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LifeEventDto implements LifeEventDto {
  const _LifeEventDto({required this.id, required this.category, required this.year, this.month, this.description});
  factory _LifeEventDto.fromJson(Map<String, dynamic> json) => _$LifeEventDtoFromJson(json);

@override final  String id;
@override final  String category;
@override final  int year;
@override final  int? month;
@override final  String? description;

/// Create a copy of LifeEventDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LifeEventDtoCopyWith<_LifeEventDto> get copyWith => __$LifeEventDtoCopyWithImpl<_LifeEventDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LifeEventDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LifeEventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,year,month,description);

@override
String toString() {
  return 'LifeEventDto(id: $id, category: $category, year: $year, month: $month, description: $description)';
}


}

/// @nodoc
abstract mixin class _$LifeEventDtoCopyWith<$Res> implements $LifeEventDtoCopyWith<$Res> {
  factory _$LifeEventDtoCopyWith(_LifeEventDto value, $Res Function(_LifeEventDto) _then) = __$LifeEventDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, int year, int? month, String? description
});




}
/// @nodoc
class __$LifeEventDtoCopyWithImpl<$Res>
    implements _$LifeEventDtoCopyWith<$Res> {
  __$LifeEventDtoCopyWithImpl(this._self, this._then);

  final _LifeEventDto _self;
  final $Res Function(_LifeEventDto) _then;

/// Create a copy of LifeEventDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? year = null,Object? month = freezed,Object? description = freezed,}) {
  return _then(_LifeEventDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RectificationRequestDto {

 String get requestId; String get birthDate; BirthPlaceDto get birthPlace; TimeWindowDto get timeWindow; List<LifeEventDto> get lifeEvents;
/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RectificationRequestDtoCopyWith<RectificationRequestDto> get copyWith => _$RectificationRequestDtoCopyWithImpl<RectificationRequestDto>(this as RectificationRequestDto, _$identity);

  /// Serializes this RectificationRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RectificationRequestDto&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow)&&const DeepCollectionEquality().equals(other.lifeEvents, lifeEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,birthDate,birthPlace,timeWindow,const DeepCollectionEquality().hash(lifeEvents));

@override
String toString() {
  return 'RectificationRequestDto(requestId: $requestId, birthDate: $birthDate, birthPlace: $birthPlace, timeWindow: $timeWindow, lifeEvents: $lifeEvents)';
}


}

/// @nodoc
abstract mixin class $RectificationRequestDtoCopyWith<$Res>  {
  factory $RectificationRequestDtoCopyWith(RectificationRequestDto value, $Res Function(RectificationRequestDto) _then) = _$RectificationRequestDtoCopyWithImpl;
@useResult
$Res call({
 String requestId, String birthDate, BirthPlaceDto birthPlace, TimeWindowDto timeWindow, List<LifeEventDto> lifeEvents
});


$BirthPlaceDtoCopyWith<$Res> get birthPlace;$TimeWindowDtoCopyWith<$Res> get timeWindow;

}
/// @nodoc
class _$RectificationRequestDtoCopyWithImpl<$Res>
    implements $RectificationRequestDtoCopyWith<$Res> {
  _$RectificationRequestDtoCopyWithImpl(this._self, this._then);

  final RectificationRequestDto _self;
  final $Res Function(RectificationRequestDto) _then;

/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? birthDate = null,Object? birthPlace = null,Object? timeWindow = null,Object? lifeEvents = null,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,birthPlace: null == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlaceDto,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as TimeWindowDto,lifeEvents: null == lifeEvents ? _self.lifeEvents : lifeEvents // ignore: cast_nullable_to_non_nullable
as List<LifeEventDto>,
  ));
}
/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthPlaceDtoCopyWith<$Res> get birthPlace {
  
  return $BirthPlaceDtoCopyWith<$Res>(_self.birthPlace, (value) {
    return _then(_self.copyWith(birthPlace: value));
  });
}/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowDtoCopyWith<$Res> get timeWindow {
  
  return $TimeWindowDtoCopyWith<$Res>(_self.timeWindow, (value) {
    return _then(_self.copyWith(timeWindow: value));
  });
}
}


/// Adds pattern-matching-related methods to [RectificationRequestDto].
extension RectificationRequestDtoPatterns on RectificationRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RectificationRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RectificationRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RectificationRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _RectificationRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RectificationRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _RectificationRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  String birthDate,  BirthPlaceDto birthPlace,  TimeWindowDto timeWindow,  List<LifeEventDto> lifeEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RectificationRequestDto() when $default != null:
return $default(_that.requestId,_that.birthDate,_that.birthPlace,_that.timeWindow,_that.lifeEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  String birthDate,  BirthPlaceDto birthPlace,  TimeWindowDto timeWindow,  List<LifeEventDto> lifeEvents)  $default,) {final _that = this;
switch (_that) {
case _RectificationRequestDto():
return $default(_that.requestId,_that.birthDate,_that.birthPlace,_that.timeWindow,_that.lifeEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  String birthDate,  BirthPlaceDto birthPlace,  TimeWindowDto timeWindow,  List<LifeEventDto> lifeEvents)?  $default,) {final _that = this;
switch (_that) {
case _RectificationRequestDto() when $default != null:
return $default(_that.requestId,_that.birthDate,_that.birthPlace,_that.timeWindow,_that.lifeEvents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RectificationRequestDto implements RectificationRequestDto {
  const _RectificationRequestDto({required this.requestId, required this.birthDate, required this.birthPlace, required this.timeWindow, required final  List<LifeEventDto> lifeEvents}): _lifeEvents = lifeEvents;
  factory _RectificationRequestDto.fromJson(Map<String, dynamic> json) => _$RectificationRequestDtoFromJson(json);

@override final  String requestId;
@override final  String birthDate;
@override final  BirthPlaceDto birthPlace;
@override final  TimeWindowDto timeWindow;
 final  List<LifeEventDto> _lifeEvents;
@override List<LifeEventDto> get lifeEvents {
  if (_lifeEvents is EqualUnmodifiableListView) return _lifeEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lifeEvents);
}


/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RectificationRequestDtoCopyWith<_RectificationRequestDto> get copyWith => __$RectificationRequestDtoCopyWithImpl<_RectificationRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RectificationRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RectificationRequestDto&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow)&&const DeepCollectionEquality().equals(other._lifeEvents, _lifeEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,birthDate,birthPlace,timeWindow,const DeepCollectionEquality().hash(_lifeEvents));

@override
String toString() {
  return 'RectificationRequestDto(requestId: $requestId, birthDate: $birthDate, birthPlace: $birthPlace, timeWindow: $timeWindow, lifeEvents: $lifeEvents)';
}


}

/// @nodoc
abstract mixin class _$RectificationRequestDtoCopyWith<$Res> implements $RectificationRequestDtoCopyWith<$Res> {
  factory _$RectificationRequestDtoCopyWith(_RectificationRequestDto value, $Res Function(_RectificationRequestDto) _then) = __$RectificationRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String requestId, String birthDate, BirthPlaceDto birthPlace, TimeWindowDto timeWindow, List<LifeEventDto> lifeEvents
});


@override $BirthPlaceDtoCopyWith<$Res> get birthPlace;@override $TimeWindowDtoCopyWith<$Res> get timeWindow;

}
/// @nodoc
class __$RectificationRequestDtoCopyWithImpl<$Res>
    implements _$RectificationRequestDtoCopyWith<$Res> {
  __$RectificationRequestDtoCopyWithImpl(this._self, this._then);

  final _RectificationRequestDto _self;
  final $Res Function(_RectificationRequestDto) _then;

/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? birthDate = null,Object? birthPlace = null,Object? timeWindow = null,Object? lifeEvents = null,}) {
  return _then(_RectificationRequestDto(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,birthPlace: null == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlaceDto,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as TimeWindowDto,lifeEvents: null == lifeEvents ? _self._lifeEvents : lifeEvents // ignore: cast_nullable_to_non_nullable
as List<LifeEventDto>,
  ));
}

/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthPlaceDtoCopyWith<$Res> get birthPlace {
  
  return $BirthPlaceDtoCopyWith<$Res>(_self.birthPlace, (value) {
    return _then(_self.copyWith(birthPlace: value));
  });
}/// Create a copy of RectificationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowDtoCopyWith<$Res> get timeWindow {
  
  return $TimeWindowDtoCopyWith<$Res>(_self.timeWindow, (value) {
    return _then(_self.copyWith(timeWindow: value));
  });
}
}

// dart format on
