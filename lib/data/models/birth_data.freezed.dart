// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BirthData {

 DateTime get birthDate; String get birthCity; double get birthLatitude; double get birthLongitude; String? get label;
/// Create a copy of BirthData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthDataCopyWith<BirthData> get copyWith => _$BirthDataCopyWithImpl<BirthData>(this as BirthData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthData&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthCity, birthCity) || other.birthCity == birthCity)&&(identical(other.birthLatitude, birthLatitude) || other.birthLatitude == birthLatitude)&&(identical(other.birthLongitude, birthLongitude) || other.birthLongitude == birthLongitude)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,birthDate,birthCity,birthLatitude,birthLongitude,label);

@override
String toString() {
  return 'BirthData(birthDate: $birthDate, birthCity: $birthCity, birthLatitude: $birthLatitude, birthLongitude: $birthLongitude, label: $label)';
}


}

/// @nodoc
abstract mixin class $BirthDataCopyWith<$Res>  {
  factory $BirthDataCopyWith(BirthData value, $Res Function(BirthData) _then) = _$BirthDataCopyWithImpl;
@useResult
$Res call({
 DateTime birthDate, String birthCity, double birthLatitude, double birthLongitude, String? label
});




}
/// @nodoc
class _$BirthDataCopyWithImpl<$Res>
    implements $BirthDataCopyWith<$Res> {
  _$BirthDataCopyWithImpl(this._self, this._then);

  final BirthData _self;
  final $Res Function(BirthData) _then;

/// Create a copy of BirthData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? birthDate = null,Object? birthCity = null,Object? birthLatitude = null,Object? birthLongitude = null,Object? label = freezed,}) {
  return _then(_self.copyWith(
birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,birthCity: null == birthCity ? _self.birthCity : birthCity // ignore: cast_nullable_to_non_nullable
as String,birthLatitude: null == birthLatitude ? _self.birthLatitude : birthLatitude // ignore: cast_nullable_to_non_nullable
as double,birthLongitude: null == birthLongitude ? _self.birthLongitude : birthLongitude // ignore: cast_nullable_to_non_nullable
as double,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BirthData].
extension BirthDataPatterns on BirthData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BirthData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BirthData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BirthData value)  $default,){
final _that = this;
switch (_that) {
case _BirthData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BirthData value)?  $default,){
final _that = this;
switch (_that) {
case _BirthData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime birthDate,  String birthCity,  double birthLatitude,  double birthLongitude,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BirthData() when $default != null:
return $default(_that.birthDate,_that.birthCity,_that.birthLatitude,_that.birthLongitude,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime birthDate,  String birthCity,  double birthLatitude,  double birthLongitude,  String? label)  $default,) {final _that = this;
switch (_that) {
case _BirthData():
return $default(_that.birthDate,_that.birthCity,_that.birthLatitude,_that.birthLongitude,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime birthDate,  String birthCity,  double birthLatitude,  double birthLongitude,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _BirthData() when $default != null:
return $default(_that.birthDate,_that.birthCity,_that.birthLatitude,_that.birthLongitude,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _BirthData implements BirthData {
  const _BirthData({required this.birthDate, required this.birthCity, required this.birthLatitude, required this.birthLongitude, this.label});
  

@override final  DateTime birthDate;
@override final  String birthCity;
@override final  double birthLatitude;
@override final  double birthLongitude;
@override final  String? label;

/// Create a copy of BirthData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BirthDataCopyWith<_BirthData> get copyWith => __$BirthDataCopyWithImpl<_BirthData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BirthData&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthCity, birthCity) || other.birthCity == birthCity)&&(identical(other.birthLatitude, birthLatitude) || other.birthLatitude == birthLatitude)&&(identical(other.birthLongitude, birthLongitude) || other.birthLongitude == birthLongitude)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,birthDate,birthCity,birthLatitude,birthLongitude,label);

@override
String toString() {
  return 'BirthData(birthDate: $birthDate, birthCity: $birthCity, birthLatitude: $birthLatitude, birthLongitude: $birthLongitude, label: $label)';
}


}

/// @nodoc
abstract mixin class _$BirthDataCopyWith<$Res> implements $BirthDataCopyWith<$Res> {
  factory _$BirthDataCopyWith(_BirthData value, $Res Function(_BirthData) _then) = __$BirthDataCopyWithImpl;
@override @useResult
$Res call({
 DateTime birthDate, String birthCity, double birthLatitude, double birthLongitude, String? label
});




}
/// @nodoc
class __$BirthDataCopyWithImpl<$Res>
    implements _$BirthDataCopyWith<$Res> {
  __$BirthDataCopyWithImpl(this._self, this._then);

  final _BirthData _self;
  final $Res Function(_BirthData) _then;

/// Create a copy of BirthData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? birthDate = null,Object? birthCity = null,Object? birthLatitude = null,Object? birthLongitude = null,Object? label = freezed,}) {
  return _then(_BirthData(
birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,birthCity: null == birthCity ? _self.birthCity : birthCity // ignore: cast_nullable_to_non_nullable
as String,birthLatitude: null == birthLatitude ? _self.birthLatitude : birthLatitude // ignore: cast_nullable_to_non_nullable
as double,birthLongitude: null == birthLongitude ? _self.birthLongitude : birthLongitude // ignore: cast_nullable_to_non_nullable
as double,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
