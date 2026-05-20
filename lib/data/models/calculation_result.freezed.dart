// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalculationResult {

 String get requestId; List<CandidateTime> get candidates; List<EvidenceItem> get evidence; bool get isDemo; DateTime get completedAt; String? get apiCalculationId; String? get method; String? get rawResponseJson;
/// Create a copy of CalculationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalculationResultCopyWith<CalculationResult> get copyWith => _$CalculationResultCopyWithImpl<CalculationResult>(this as CalculationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalculationResult&&(identical(other.requestId, requestId) || other.requestId == requestId)&&const DeepCollectionEquality().equals(other.candidates, candidates)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&(identical(other.isDemo, isDemo) || other.isDemo == isDemo)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.apiCalculationId, apiCalculationId) || other.apiCalculationId == apiCalculationId)&&(identical(other.method, method) || other.method == method)&&(identical(other.rawResponseJson, rawResponseJson) || other.rawResponseJson == rawResponseJson));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,const DeepCollectionEquality().hash(candidates),const DeepCollectionEquality().hash(evidence),isDemo,completedAt,apiCalculationId,method,rawResponseJson);

@override
String toString() {
  return 'CalculationResult(requestId: $requestId, candidates: $candidates, evidence: $evidence, isDemo: $isDemo, completedAt: $completedAt, apiCalculationId: $apiCalculationId, method: $method, rawResponseJson: $rawResponseJson)';
}


}

/// @nodoc
abstract mixin class $CalculationResultCopyWith<$Res>  {
  factory $CalculationResultCopyWith(CalculationResult value, $Res Function(CalculationResult) _then) = _$CalculationResultCopyWithImpl;
@useResult
$Res call({
 String requestId, List<CandidateTime> candidates, List<EvidenceItem> evidence, bool isDemo, DateTime completedAt, String? apiCalculationId, String? method, String? rawResponseJson
});




}
/// @nodoc
class _$CalculationResultCopyWithImpl<$Res>
    implements $CalculationResultCopyWith<$Res> {
  _$CalculationResultCopyWithImpl(this._self, this._then);

  final CalculationResult _self;
  final $Res Function(CalculationResult) _then;

/// Create a copy of CalculationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? candidates = null,Object? evidence = null,Object? isDemo = null,Object? completedAt = null,Object? apiCalculationId = freezed,Object? method = freezed,Object? rawResponseJson = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<CandidateTime>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<EvidenceItem>,isDemo: null == isDemo ? _self.isDemo : isDemo // ignore: cast_nullable_to_non_nullable
as bool,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,apiCalculationId: freezed == apiCalculationId ? _self.apiCalculationId : apiCalculationId // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,rawResponseJson: freezed == rawResponseJson ? _self.rawResponseJson : rawResponseJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalculationResult].
extension CalculationResultPatterns on CalculationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalculationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalculationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalculationResult value)  $default,){
final _that = this;
switch (_that) {
case _CalculationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalculationResult value)?  $default,){
final _that = this;
switch (_that) {
case _CalculationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  List<CandidateTime> candidates,  List<EvidenceItem> evidence,  bool isDemo,  DateTime completedAt,  String? apiCalculationId,  String? method,  String? rawResponseJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalculationResult() when $default != null:
return $default(_that.requestId,_that.candidates,_that.evidence,_that.isDemo,_that.completedAt,_that.apiCalculationId,_that.method,_that.rawResponseJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  List<CandidateTime> candidates,  List<EvidenceItem> evidence,  bool isDemo,  DateTime completedAt,  String? apiCalculationId,  String? method,  String? rawResponseJson)  $default,) {final _that = this;
switch (_that) {
case _CalculationResult():
return $default(_that.requestId,_that.candidates,_that.evidence,_that.isDemo,_that.completedAt,_that.apiCalculationId,_that.method,_that.rawResponseJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  List<CandidateTime> candidates,  List<EvidenceItem> evidence,  bool isDemo,  DateTime completedAt,  String? apiCalculationId,  String? method,  String? rawResponseJson)?  $default,) {final _that = this;
switch (_that) {
case _CalculationResult() when $default != null:
return $default(_that.requestId,_that.candidates,_that.evidence,_that.isDemo,_that.completedAt,_that.apiCalculationId,_that.method,_that.rawResponseJson);case _:
  return null;

}
}

}

/// @nodoc


class _CalculationResult implements CalculationResult {
  const _CalculationResult({required this.requestId, required final  List<CandidateTime> candidates, required final  List<EvidenceItem> evidence, required this.isDemo, required this.completedAt, this.apiCalculationId, this.method, this.rawResponseJson}): _candidates = candidates,_evidence = evidence;
  

@override final  String requestId;
 final  List<CandidateTime> _candidates;
@override List<CandidateTime> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}

 final  List<EvidenceItem> _evidence;
@override List<EvidenceItem> get evidence {
  if (_evidence is EqualUnmodifiableListView) return _evidence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidence);
}

@override final  bool isDemo;
@override final  DateTime completedAt;
@override final  String? apiCalculationId;
@override final  String? method;
@override final  String? rawResponseJson;

/// Create a copy of CalculationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalculationResultCopyWith<_CalculationResult> get copyWith => __$CalculationResultCopyWithImpl<_CalculationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalculationResult&&(identical(other.requestId, requestId) || other.requestId == requestId)&&const DeepCollectionEquality().equals(other._candidates, _candidates)&&const DeepCollectionEquality().equals(other._evidence, _evidence)&&(identical(other.isDemo, isDemo) || other.isDemo == isDemo)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.apiCalculationId, apiCalculationId) || other.apiCalculationId == apiCalculationId)&&(identical(other.method, method) || other.method == method)&&(identical(other.rawResponseJson, rawResponseJson) || other.rawResponseJson == rawResponseJson));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,const DeepCollectionEquality().hash(_candidates),const DeepCollectionEquality().hash(_evidence),isDemo,completedAt,apiCalculationId,method,rawResponseJson);

@override
String toString() {
  return 'CalculationResult(requestId: $requestId, candidates: $candidates, evidence: $evidence, isDemo: $isDemo, completedAt: $completedAt, apiCalculationId: $apiCalculationId, method: $method, rawResponseJson: $rawResponseJson)';
}


}

/// @nodoc
abstract mixin class _$CalculationResultCopyWith<$Res> implements $CalculationResultCopyWith<$Res> {
  factory _$CalculationResultCopyWith(_CalculationResult value, $Res Function(_CalculationResult) _then) = __$CalculationResultCopyWithImpl;
@override @useResult
$Res call({
 String requestId, List<CandidateTime> candidates, List<EvidenceItem> evidence, bool isDemo, DateTime completedAt, String? apiCalculationId, String? method, String? rawResponseJson
});




}
/// @nodoc
class __$CalculationResultCopyWithImpl<$Res>
    implements _$CalculationResultCopyWith<$Res> {
  __$CalculationResultCopyWithImpl(this._self, this._then);

  final _CalculationResult _self;
  final $Res Function(_CalculationResult) _then;

/// Create a copy of CalculationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? candidates = null,Object? evidence = null,Object? isDemo = null,Object? completedAt = null,Object? apiCalculationId = freezed,Object? method = freezed,Object? rawResponseJson = freezed,}) {
  return _then(_CalculationResult(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<CandidateTime>,evidence: null == evidence ? _self._evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<EvidenceItem>,isDemo: null == isDemo ? _self.isDemo : isDemo // ignore: cast_nullable_to_non_nullable
as bool,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,apiCalculationId: freezed == apiCalculationId ? _self.apiCalculationId : apiCalculationId // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,rawResponseJson: freezed == rawResponseJson ? _self.rawResponseJson : rawResponseJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
