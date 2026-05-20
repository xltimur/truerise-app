// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evidence_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EvidenceItem {

 String get eventId; MatchStrength get matchStrength; String get explanation;
/// Create a copy of EvidenceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvidenceItemCopyWith<EvidenceItem> get copyWith => _$EvidenceItemCopyWithImpl<EvidenceItem>(this as EvidenceItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvidenceItem&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.matchStrength, matchStrength) || other.matchStrength == matchStrength)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}


@override
int get hashCode => Object.hash(runtimeType,eventId,matchStrength,explanation);

@override
String toString() {
  return 'EvidenceItem(eventId: $eventId, matchStrength: $matchStrength, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $EvidenceItemCopyWith<$Res>  {
  factory $EvidenceItemCopyWith(EvidenceItem value, $Res Function(EvidenceItem) _then) = _$EvidenceItemCopyWithImpl;
@useResult
$Res call({
 String eventId, MatchStrength matchStrength, String explanation
});




}
/// @nodoc
class _$EvidenceItemCopyWithImpl<$Res>
    implements $EvidenceItemCopyWith<$Res> {
  _$EvidenceItemCopyWithImpl(this._self, this._then);

  final EvidenceItem _self;
  final $Res Function(EvidenceItem) _then;

/// Create a copy of EvidenceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? matchStrength = null,Object? explanation = null,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,matchStrength: null == matchStrength ? _self.matchStrength : matchStrength // ignore: cast_nullable_to_non_nullable
as MatchStrength,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EvidenceItem].
extension EvidenceItemPatterns on EvidenceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvidenceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvidenceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvidenceItem value)  $default,){
final _that = this;
switch (_that) {
case _EvidenceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvidenceItem value)?  $default,){
final _that = this;
switch (_that) {
case _EvidenceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  MatchStrength matchStrength,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvidenceItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  MatchStrength matchStrength,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _EvidenceItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  MatchStrength matchStrength,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _EvidenceItem() when $default != null:
return $default(_that.eventId,_that.matchStrength,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc


class _EvidenceItem implements EvidenceItem {
  const _EvidenceItem({required this.eventId, required this.matchStrength, required this.explanation});
  

@override final  String eventId;
@override final  MatchStrength matchStrength;
@override final  String explanation;

/// Create a copy of EvidenceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvidenceItemCopyWith<_EvidenceItem> get copyWith => __$EvidenceItemCopyWithImpl<_EvidenceItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvidenceItem&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.matchStrength, matchStrength) || other.matchStrength == matchStrength)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}


@override
int get hashCode => Object.hash(runtimeType,eventId,matchStrength,explanation);

@override
String toString() {
  return 'EvidenceItem(eventId: $eventId, matchStrength: $matchStrength, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$EvidenceItemCopyWith<$Res> implements $EvidenceItemCopyWith<$Res> {
  factory _$EvidenceItemCopyWith(_EvidenceItem value, $Res Function(_EvidenceItem) _then) = __$EvidenceItemCopyWithImpl;
@override @useResult
$Res call({
 String eventId, MatchStrength matchStrength, String explanation
});




}
/// @nodoc
class __$EvidenceItemCopyWithImpl<$Res>
    implements _$EvidenceItemCopyWith<$Res> {
  __$EvidenceItemCopyWithImpl(this._self, this._then);

  final _EvidenceItem _self;
  final $Res Function(_EvidenceItem) _then;

/// Create a copy of EvidenceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? matchStrength = null,Object? explanation = null,}) {
  return _then(_EvidenceItem(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,matchStrength: null == matchStrength ? _self.matchStrength : matchStrength // ignore: cast_nullable_to_non_nullable
as MatchStrength,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
