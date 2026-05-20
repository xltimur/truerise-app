// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candidate_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CandidateTime {

 int get rank;@TimeOfDayConverter() TimeOfDay get time; double get confidence; String? get ascendant;
/// Create a copy of CandidateTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CandidateTimeCopyWith<CandidateTime> get copyWith => _$CandidateTimeCopyWithImpl<CandidateTime>(this as CandidateTime, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CandidateTime&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.time, time) || other.time == time)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.ascendant, ascendant) || other.ascendant == ascendant));
}


@override
int get hashCode => Object.hash(runtimeType,rank,time,confidence,ascendant);

@override
String toString() {
  return 'CandidateTime(rank: $rank, time: $time, confidence: $confidence, ascendant: $ascendant)';
}


}

/// @nodoc
abstract mixin class $CandidateTimeCopyWith<$Res>  {
  factory $CandidateTimeCopyWith(CandidateTime value, $Res Function(CandidateTime) _then) = _$CandidateTimeCopyWithImpl;
@useResult
$Res call({
 int rank,@TimeOfDayConverter() TimeOfDay time, double confidence, String? ascendant
});




}
/// @nodoc
class _$CandidateTimeCopyWithImpl<$Res>
    implements $CandidateTimeCopyWith<$Res> {
  _$CandidateTimeCopyWithImpl(this._self, this._then);

  final CandidateTime _self;
  final $Res Function(CandidateTime) _then;

/// Create a copy of CandidateTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? time = null,Object? confidence = null,Object? ascendant = freezed,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,ascendant: freezed == ascendant ? _self.ascendant : ascendant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CandidateTime].
extension CandidateTimePatterns on CandidateTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CandidateTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CandidateTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CandidateTime value)  $default,){
final _that = this;
switch (_that) {
case _CandidateTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CandidateTime value)?  $default,){
final _that = this;
switch (_that) {
case _CandidateTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank, @TimeOfDayConverter()  TimeOfDay time,  double confidence,  String? ascendant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CandidateTime() when $default != null:
return $default(_that.rank,_that.time,_that.confidence,_that.ascendant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank, @TimeOfDayConverter()  TimeOfDay time,  double confidence,  String? ascendant)  $default,) {final _that = this;
switch (_that) {
case _CandidateTime():
return $default(_that.rank,_that.time,_that.confidence,_that.ascendant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank, @TimeOfDayConverter()  TimeOfDay time,  double confidence,  String? ascendant)?  $default,) {final _that = this;
switch (_that) {
case _CandidateTime() when $default != null:
return $default(_that.rank,_that.time,_that.confidence,_that.ascendant);case _:
  return null;

}
}

}

/// @nodoc


class _CandidateTime implements CandidateTime {
  const _CandidateTime({required this.rank, @TimeOfDayConverter() required this.time, required this.confidence, this.ascendant});
  

@override final  int rank;
@override@TimeOfDayConverter() final  TimeOfDay time;
@override final  double confidence;
@override final  String? ascendant;

/// Create a copy of CandidateTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CandidateTimeCopyWith<_CandidateTime> get copyWith => __$CandidateTimeCopyWithImpl<_CandidateTime>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CandidateTime&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.time, time) || other.time == time)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.ascendant, ascendant) || other.ascendant == ascendant));
}


@override
int get hashCode => Object.hash(runtimeType,rank,time,confidence,ascendant);

@override
String toString() {
  return 'CandidateTime(rank: $rank, time: $time, confidence: $confidence, ascendant: $ascendant)';
}


}

/// @nodoc
abstract mixin class _$CandidateTimeCopyWith<$Res> implements $CandidateTimeCopyWith<$Res> {
  factory _$CandidateTimeCopyWith(_CandidateTime value, $Res Function(_CandidateTime) _then) = __$CandidateTimeCopyWithImpl;
@override @useResult
$Res call({
 int rank,@TimeOfDayConverter() TimeOfDay time, double confidence, String? ascendant
});




}
/// @nodoc
class __$CandidateTimeCopyWithImpl<$Res>
    implements _$CandidateTimeCopyWith<$Res> {
  __$CandidateTimeCopyWithImpl(this._self, this._then);

  final _CandidateTime _self;
  final $Res Function(_CandidateTime) _then;

/// Create a copy of CandidateTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? time = null,Object? confidence = null,Object? ascendant = freezed,}) {
  return _then(_CandidateTime(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,ascendant: freezed == ascendant ? _self.ascendant : ascendant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
