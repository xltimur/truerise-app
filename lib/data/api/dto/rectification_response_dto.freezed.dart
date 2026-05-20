// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rectification_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RectificationCandidateDto {

 int get rank; String get time; double get confidence; String? get ascendant;
/// Create a copy of RectificationCandidateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RectificationCandidateDtoCopyWith<RectificationCandidateDto> get copyWith => _$RectificationCandidateDtoCopyWithImpl<RectificationCandidateDto>(this as RectificationCandidateDto, _$identity);

  /// Serializes this RectificationCandidateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RectificationCandidateDto&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.time, time) || other.time == time)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.ascendant, ascendant) || other.ascendant == ascendant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,time,confidence,ascendant);

@override
String toString() {
  return 'RectificationCandidateDto(rank: $rank, time: $time, confidence: $confidence, ascendant: $ascendant)';
}


}

/// @nodoc
abstract mixin class $RectificationCandidateDtoCopyWith<$Res>  {
  factory $RectificationCandidateDtoCopyWith(RectificationCandidateDto value, $Res Function(RectificationCandidateDto) _then) = _$RectificationCandidateDtoCopyWithImpl;
@useResult
$Res call({
 int rank, String time, double confidence, String? ascendant
});




}
/// @nodoc
class _$RectificationCandidateDtoCopyWithImpl<$Res>
    implements $RectificationCandidateDtoCopyWith<$Res> {
  _$RectificationCandidateDtoCopyWithImpl(this._self, this._then);

  final RectificationCandidateDto _self;
  final $Res Function(RectificationCandidateDto) _then;

/// Create a copy of RectificationCandidateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? time = null,Object? confidence = null,Object? ascendant = freezed,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,ascendant: freezed == ascendant ? _self.ascendant : ascendant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RectificationCandidateDto].
extension RectificationCandidateDtoPatterns on RectificationCandidateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RectificationCandidateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RectificationCandidateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RectificationCandidateDto value)  $default,){
final _that = this;
switch (_that) {
case _RectificationCandidateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RectificationCandidateDto value)?  $default,){
final _that = this;
switch (_that) {
case _RectificationCandidateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  String time,  double confidence,  String? ascendant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RectificationCandidateDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  String time,  double confidence,  String? ascendant)  $default,) {final _that = this;
switch (_that) {
case _RectificationCandidateDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  String time,  double confidence,  String? ascendant)?  $default,) {final _that = this;
switch (_that) {
case _RectificationCandidateDto() when $default != null:
return $default(_that.rank,_that.time,_that.confidence,_that.ascendant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RectificationCandidateDto implements RectificationCandidateDto {
  const _RectificationCandidateDto({required this.rank, required this.time, required this.confidence, this.ascendant});
  factory _RectificationCandidateDto.fromJson(Map<String, dynamic> json) => _$RectificationCandidateDtoFromJson(json);

@override final  int rank;
@override final  String time;
@override final  double confidence;
@override final  String? ascendant;

/// Create a copy of RectificationCandidateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RectificationCandidateDtoCopyWith<_RectificationCandidateDto> get copyWith => __$RectificationCandidateDtoCopyWithImpl<_RectificationCandidateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RectificationCandidateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RectificationCandidateDto&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.time, time) || other.time == time)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.ascendant, ascendant) || other.ascendant == ascendant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,time,confidence,ascendant);

@override
String toString() {
  return 'RectificationCandidateDto(rank: $rank, time: $time, confidence: $confidence, ascendant: $ascendant)';
}


}

/// @nodoc
abstract mixin class _$RectificationCandidateDtoCopyWith<$Res> implements $RectificationCandidateDtoCopyWith<$Res> {
  factory _$RectificationCandidateDtoCopyWith(_RectificationCandidateDto value, $Res Function(_RectificationCandidateDto) _then) = __$RectificationCandidateDtoCopyWithImpl;
@override @useResult
$Res call({
 int rank, String time, double confidence, String? ascendant
});




}
/// @nodoc
class __$RectificationCandidateDtoCopyWithImpl<$Res>
    implements _$RectificationCandidateDtoCopyWith<$Res> {
  __$RectificationCandidateDtoCopyWithImpl(this._self, this._then);

  final _RectificationCandidateDto _self;
  final $Res Function(_RectificationCandidateDto) _then;

/// Create a copy of RectificationCandidateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? time = null,Object? confidence = null,Object? ascendant = freezed,}) {
  return _then(_RectificationCandidateDto(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,ascendant: freezed == ascendant ? _self.ascendant : ascendant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RectificationEventMatchDto {

 String get eventId; String get matchStrength; String get explanation;
/// Create a copy of RectificationEventMatchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RectificationEventMatchDtoCopyWith<RectificationEventMatchDto> get copyWith => _$RectificationEventMatchDtoCopyWithImpl<RectificationEventMatchDto>(this as RectificationEventMatchDto, _$identity);

  /// Serializes this RectificationEventMatchDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RectificationEventMatchDto&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.matchStrength, matchStrength) || other.matchStrength == matchStrength)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,matchStrength,explanation);

@override
String toString() {
  return 'RectificationEventMatchDto(eventId: $eventId, matchStrength: $matchStrength, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $RectificationEventMatchDtoCopyWith<$Res>  {
  factory $RectificationEventMatchDtoCopyWith(RectificationEventMatchDto value, $Res Function(RectificationEventMatchDto) _then) = _$RectificationEventMatchDtoCopyWithImpl;
@useResult
$Res call({
 String eventId, String matchStrength, String explanation
});




}
/// @nodoc
class _$RectificationEventMatchDtoCopyWithImpl<$Res>
    implements $RectificationEventMatchDtoCopyWith<$Res> {
  _$RectificationEventMatchDtoCopyWithImpl(this._self, this._then);

  final RectificationEventMatchDto _self;
  final $Res Function(RectificationEventMatchDto) _then;

/// Create a copy of RectificationEventMatchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? matchStrength = null,Object? explanation = null,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,matchStrength: null == matchStrength ? _self.matchStrength : matchStrength // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RectificationEventMatchDto].
extension RectificationEventMatchDtoPatterns on RectificationEventMatchDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RectificationEventMatchDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RectificationEventMatchDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RectificationEventMatchDto value)  $default,){
final _that = this;
switch (_that) {
case _RectificationEventMatchDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RectificationEventMatchDto value)?  $default,){
final _that = this;
switch (_that) {
case _RectificationEventMatchDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String matchStrength,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RectificationEventMatchDto() when $default != null:
return $default(_that.eventId,_that.matchStrength,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String matchStrength,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _RectificationEventMatchDto():
return $default(_that.eventId,_that.matchStrength,_that.explanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String matchStrength,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _RectificationEventMatchDto() when $default != null:
return $default(_that.eventId,_that.matchStrength,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RectificationEventMatchDto implements RectificationEventMatchDto {
  const _RectificationEventMatchDto({required this.eventId, required this.matchStrength, required this.explanation});
  factory _RectificationEventMatchDto.fromJson(Map<String, dynamic> json) => _$RectificationEventMatchDtoFromJson(json);

@override final  String eventId;
@override final  String matchStrength;
@override final  String explanation;

/// Create a copy of RectificationEventMatchDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RectificationEventMatchDtoCopyWith<_RectificationEventMatchDto> get copyWith => __$RectificationEventMatchDtoCopyWithImpl<_RectificationEventMatchDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RectificationEventMatchDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RectificationEventMatchDto&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.matchStrength, matchStrength) || other.matchStrength == matchStrength)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,matchStrength,explanation);

@override
String toString() {
  return 'RectificationEventMatchDto(eventId: $eventId, matchStrength: $matchStrength, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$RectificationEventMatchDtoCopyWith<$Res> implements $RectificationEventMatchDtoCopyWith<$Res> {
  factory _$RectificationEventMatchDtoCopyWith(_RectificationEventMatchDto value, $Res Function(_RectificationEventMatchDto) _then) = __$RectificationEventMatchDtoCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String matchStrength, String explanation
});




}
/// @nodoc
class __$RectificationEventMatchDtoCopyWithImpl<$Res>
    implements _$RectificationEventMatchDtoCopyWith<$Res> {
  __$RectificationEventMatchDtoCopyWithImpl(this._self, this._then);

  final _RectificationEventMatchDto _self;
  final $Res Function(_RectificationEventMatchDto) _then;

/// Create a copy of RectificationEventMatchDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? matchStrength = null,Object? explanation = null,}) {
  return _then(_RectificationEventMatchDto(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,matchStrength: null == matchStrength ? _self.matchStrength : matchStrength // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RectificationResponseDto {

 String get calculationId; List<RectificationCandidateDto> get candidates; List<RectificationEventMatchDto> get evidence; String? get method;
/// Create a copy of RectificationResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RectificationResponseDtoCopyWith<RectificationResponseDto> get copyWith => _$RectificationResponseDtoCopyWithImpl<RectificationResponseDto>(this as RectificationResponseDto, _$identity);

  /// Serializes this RectificationResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RectificationResponseDto&&(identical(other.calculationId, calculationId) || other.calculationId == calculationId)&&const DeepCollectionEquality().equals(other.candidates, candidates)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&(identical(other.method, method) || other.method == method));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calculationId,const DeepCollectionEquality().hash(candidates),const DeepCollectionEquality().hash(evidence),method);

@override
String toString() {
  return 'RectificationResponseDto(calculationId: $calculationId, candidates: $candidates, evidence: $evidence, method: $method)';
}


}

/// @nodoc
abstract mixin class $RectificationResponseDtoCopyWith<$Res>  {
  factory $RectificationResponseDtoCopyWith(RectificationResponseDto value, $Res Function(RectificationResponseDto) _then) = _$RectificationResponseDtoCopyWithImpl;
@useResult
$Res call({
 String calculationId, List<RectificationCandidateDto> candidates, List<RectificationEventMatchDto> evidence, String? method
});




}
/// @nodoc
class _$RectificationResponseDtoCopyWithImpl<$Res>
    implements $RectificationResponseDtoCopyWith<$Res> {
  _$RectificationResponseDtoCopyWithImpl(this._self, this._then);

  final RectificationResponseDto _self;
  final $Res Function(RectificationResponseDto) _then;

/// Create a copy of RectificationResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calculationId = null,Object? candidates = null,Object? evidence = null,Object? method = freezed,}) {
  return _then(_self.copyWith(
calculationId: null == calculationId ? _self.calculationId : calculationId // ignore: cast_nullable_to_non_nullable
as String,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<RectificationCandidateDto>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<RectificationEventMatchDto>,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RectificationResponseDto].
extension RectificationResponseDtoPatterns on RectificationResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RectificationResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RectificationResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RectificationResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _RectificationResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RectificationResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _RectificationResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String calculationId,  List<RectificationCandidateDto> candidates,  List<RectificationEventMatchDto> evidence,  String? method)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RectificationResponseDto() when $default != null:
return $default(_that.calculationId,_that.candidates,_that.evidence,_that.method);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String calculationId,  List<RectificationCandidateDto> candidates,  List<RectificationEventMatchDto> evidence,  String? method)  $default,) {final _that = this;
switch (_that) {
case _RectificationResponseDto():
return $default(_that.calculationId,_that.candidates,_that.evidence,_that.method);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String calculationId,  List<RectificationCandidateDto> candidates,  List<RectificationEventMatchDto> evidence,  String? method)?  $default,) {final _that = this;
switch (_that) {
case _RectificationResponseDto() when $default != null:
return $default(_that.calculationId,_that.candidates,_that.evidence,_that.method);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RectificationResponseDto implements RectificationResponseDto {
  const _RectificationResponseDto({required this.calculationId, required final  List<RectificationCandidateDto> candidates, required final  List<RectificationEventMatchDto> evidence, this.method}): _candidates = candidates,_evidence = evidence;
  factory _RectificationResponseDto.fromJson(Map<String, dynamic> json) => _$RectificationResponseDtoFromJson(json);

@override final  String calculationId;
 final  List<RectificationCandidateDto> _candidates;
@override List<RectificationCandidateDto> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}

 final  List<RectificationEventMatchDto> _evidence;
@override List<RectificationEventMatchDto> get evidence {
  if (_evidence is EqualUnmodifiableListView) return _evidence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidence);
}

@override final  String? method;

/// Create a copy of RectificationResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RectificationResponseDtoCopyWith<_RectificationResponseDto> get copyWith => __$RectificationResponseDtoCopyWithImpl<_RectificationResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RectificationResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RectificationResponseDto&&(identical(other.calculationId, calculationId) || other.calculationId == calculationId)&&const DeepCollectionEquality().equals(other._candidates, _candidates)&&const DeepCollectionEquality().equals(other._evidence, _evidence)&&(identical(other.method, method) || other.method == method));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calculationId,const DeepCollectionEquality().hash(_candidates),const DeepCollectionEquality().hash(_evidence),method);

@override
String toString() {
  return 'RectificationResponseDto(calculationId: $calculationId, candidates: $candidates, evidence: $evidence, method: $method)';
}


}

/// @nodoc
abstract mixin class _$RectificationResponseDtoCopyWith<$Res> implements $RectificationResponseDtoCopyWith<$Res> {
  factory _$RectificationResponseDtoCopyWith(_RectificationResponseDto value, $Res Function(_RectificationResponseDto) _then) = __$RectificationResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String calculationId, List<RectificationCandidateDto> candidates, List<RectificationEventMatchDto> evidence, String? method
});




}
/// @nodoc
class __$RectificationResponseDtoCopyWithImpl<$Res>
    implements _$RectificationResponseDtoCopyWith<$Res> {
  __$RectificationResponseDtoCopyWithImpl(this._self, this._then);

  final _RectificationResponseDto _self;
  final $Res Function(_RectificationResponseDto) _then;

/// Create a copy of RectificationResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calculationId = null,Object? candidates = null,Object? evidence = null,Object? method = freezed,}) {
  return _then(_RectificationResponseDto(
calculationId: null == calculationId ? _self.calculationId : calculationId // ignore: cast_nullable_to_non_nullable
as String,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<RectificationCandidateDto>,evidence: null == evidence ? _self._evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<RectificationEventMatchDto>,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
