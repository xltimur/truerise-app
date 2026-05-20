// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_window.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimeWindow {

 TimeWindowMode get mode;@TimeOfDayConverter() TimeOfDay? get approximateTime; int? get windowMinutes;
/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<TimeWindow> get copyWith => _$TimeWindowCopyWithImpl<TimeWindow>(this as TimeWindow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeWindow&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.approximateTime, approximateTime) || other.approximateTime == approximateTime)&&(identical(other.windowMinutes, windowMinutes) || other.windowMinutes == windowMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,mode,approximateTime,windowMinutes);

@override
String toString() {
  return 'TimeWindow(mode: $mode, approximateTime: $approximateTime, windowMinutes: $windowMinutes)';
}


}

/// @nodoc
abstract mixin class $TimeWindowCopyWith<$Res>  {
  factory $TimeWindowCopyWith(TimeWindow value, $Res Function(TimeWindow) _then) = _$TimeWindowCopyWithImpl;
@useResult
$Res call({
 TimeWindowMode mode,@TimeOfDayConverter() TimeOfDay? approximateTime, int? windowMinutes
});




}
/// @nodoc
class _$TimeWindowCopyWithImpl<$Res>
    implements $TimeWindowCopyWith<$Res> {
  _$TimeWindowCopyWithImpl(this._self, this._then);

  final TimeWindow _self;
  final $Res Function(TimeWindow) _then;

/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? approximateTime = freezed,Object? windowMinutes = freezed,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TimeWindowMode,approximateTime: freezed == approximateTime ? _self.approximateTime : approximateTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,windowMinutes: freezed == windowMinutes ? _self.windowMinutes : windowMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeWindow].
extension TimeWindowPatterns on TimeWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeWindow value)  $default,){
final _that = this;
switch (_that) {
case _TimeWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeWindow value)?  $default,){
final _that = this;
switch (_that) {
case _TimeWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimeWindowMode mode, @TimeOfDayConverter()  TimeOfDay? approximateTime,  int? windowMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeWindow() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimeWindowMode mode, @TimeOfDayConverter()  TimeOfDay? approximateTime,  int? windowMinutes)  $default,) {final _that = this;
switch (_that) {
case _TimeWindow():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimeWindowMode mode, @TimeOfDayConverter()  TimeOfDay? approximateTime,  int? windowMinutes)?  $default,) {final _that = this;
switch (_that) {
case _TimeWindow() when $default != null:
return $default(_that.mode,_that.approximateTime,_that.windowMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _TimeWindow extends TimeWindow {
  const _TimeWindow({required this.mode, @TimeOfDayConverter() this.approximateTime, this.windowMinutes}): super._();
  

@override final  TimeWindowMode mode;
@override@TimeOfDayConverter() final  TimeOfDay? approximateTime;
@override final  int? windowMinutes;

/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeWindowCopyWith<_TimeWindow> get copyWith => __$TimeWindowCopyWithImpl<_TimeWindow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeWindow&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.approximateTime, approximateTime) || other.approximateTime == approximateTime)&&(identical(other.windowMinutes, windowMinutes) || other.windowMinutes == windowMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,mode,approximateTime,windowMinutes);

@override
String toString() {
  return 'TimeWindow(mode: $mode, approximateTime: $approximateTime, windowMinutes: $windowMinutes)';
}


}

/// @nodoc
abstract mixin class _$TimeWindowCopyWith<$Res> implements $TimeWindowCopyWith<$Res> {
  factory _$TimeWindowCopyWith(_TimeWindow value, $Res Function(_TimeWindow) _then) = __$TimeWindowCopyWithImpl;
@override @useResult
$Res call({
 TimeWindowMode mode,@TimeOfDayConverter() TimeOfDay? approximateTime, int? windowMinutes
});




}
/// @nodoc
class __$TimeWindowCopyWithImpl<$Res>
    implements _$TimeWindowCopyWith<$Res> {
  __$TimeWindowCopyWithImpl(this._self, this._then);

  final _TimeWindow _self;
  final $Res Function(_TimeWindow) _then;

/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? approximateTime = freezed,Object? windowMinutes = freezed,}) {
  return _then(_TimeWindow(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TimeWindowMode,approximateTime: freezed == approximateTime ? _self.approximateTime : approximateTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,windowMinutes: freezed == windowMinutes ? _self.windowMinutes : windowMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
