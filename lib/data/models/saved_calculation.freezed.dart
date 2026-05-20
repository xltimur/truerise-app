// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_calculation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedCalculation {

 CalculationRequest get request; CalculationResult get result;
/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedCalculationCopyWith<SavedCalculation> get copyWith => _$SavedCalculationCopyWithImpl<SavedCalculation>(this as SavedCalculation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedCalculation&&(identical(other.request, request) || other.request == request)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,request,result);

@override
String toString() {
  return 'SavedCalculation(request: $request, result: $result)';
}


}

/// @nodoc
abstract mixin class $SavedCalculationCopyWith<$Res>  {
  factory $SavedCalculationCopyWith(SavedCalculation value, $Res Function(SavedCalculation) _then) = _$SavedCalculationCopyWithImpl;
@useResult
$Res call({
 CalculationRequest request, CalculationResult result
});


$CalculationRequestCopyWith<$Res> get request;$CalculationResultCopyWith<$Res> get result;

}
/// @nodoc
class _$SavedCalculationCopyWithImpl<$Res>
    implements $SavedCalculationCopyWith<$Res> {
  _$SavedCalculationCopyWithImpl(this._self, this._then);

  final SavedCalculation _self;
  final $Res Function(SavedCalculation) _then;

/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? request = null,Object? result = null,}) {
  return _then(_self.copyWith(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as CalculationRequest,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as CalculationResult,
  ));
}
/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalculationRequestCopyWith<$Res> get request {
  
  return $CalculationRequestCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalculationResultCopyWith<$Res> get result {
  
  return $CalculationResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedCalculation].
extension SavedCalculationPatterns on SavedCalculation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedCalculation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedCalculation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedCalculation value)  $default,){
final _that = this;
switch (_that) {
case _SavedCalculation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedCalculation value)?  $default,){
final _that = this;
switch (_that) {
case _SavedCalculation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalculationRequest request,  CalculationResult result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedCalculation() when $default != null:
return $default(_that.request,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalculationRequest request,  CalculationResult result)  $default,) {final _that = this;
switch (_that) {
case _SavedCalculation():
return $default(_that.request,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalculationRequest request,  CalculationResult result)?  $default,) {final _that = this;
switch (_that) {
case _SavedCalculation() when $default != null:
return $default(_that.request,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _SavedCalculation implements SavedCalculation {
  const _SavedCalculation({required this.request, required this.result});
  

@override final  CalculationRequest request;
@override final  CalculationResult result;

/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedCalculationCopyWith<_SavedCalculation> get copyWith => __$SavedCalculationCopyWithImpl<_SavedCalculation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedCalculation&&(identical(other.request, request) || other.request == request)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,request,result);

@override
String toString() {
  return 'SavedCalculation(request: $request, result: $result)';
}


}

/// @nodoc
abstract mixin class _$SavedCalculationCopyWith<$Res> implements $SavedCalculationCopyWith<$Res> {
  factory _$SavedCalculationCopyWith(_SavedCalculation value, $Res Function(_SavedCalculation) _then) = __$SavedCalculationCopyWithImpl;
@override @useResult
$Res call({
 CalculationRequest request, CalculationResult result
});


@override $CalculationRequestCopyWith<$Res> get request;@override $CalculationResultCopyWith<$Res> get result;

}
/// @nodoc
class __$SavedCalculationCopyWithImpl<$Res>
    implements _$SavedCalculationCopyWith<$Res> {
  __$SavedCalculationCopyWithImpl(this._self, this._then);

  final _SavedCalculation _self;
  final $Res Function(_SavedCalculation) _then;

/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? request = null,Object? result = null,}) {
  return _then(_SavedCalculation(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as CalculationRequest,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as CalculationResult,
  ));
}

/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalculationRequestCopyWith<$Res> get request {
  
  return $CalculationRequestCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}/// Create a copy of SavedCalculation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalculationResultCopyWith<$Res> get result {
  
  return $CalculationResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
