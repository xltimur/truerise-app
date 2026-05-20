// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalculationRequest {

 String get id; bool get isDemo; BirthData get birthData; TimeWindow get timeWindow; List<LifeEvent> get events; DateTime get createdAt; String? get label;
/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalculationRequestCopyWith<CalculationRequest> get copyWith => _$CalculationRequestCopyWithImpl<CalculationRequest>(this as CalculationRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalculationRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.isDemo, isDemo) || other.isDemo == isDemo)&&(identical(other.birthData, birthData) || other.birthData == birthData)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,isDemo,birthData,timeWindow,const DeepCollectionEquality().hash(events),createdAt,label);

@override
String toString() {
  return 'CalculationRequest(id: $id, isDemo: $isDemo, birthData: $birthData, timeWindow: $timeWindow, events: $events, createdAt: $createdAt, label: $label)';
}


}

/// @nodoc
abstract mixin class $CalculationRequestCopyWith<$Res>  {
  factory $CalculationRequestCopyWith(CalculationRequest value, $Res Function(CalculationRequest) _then) = _$CalculationRequestCopyWithImpl;
@useResult
$Res call({
 String id, bool isDemo, BirthData birthData, TimeWindow timeWindow, List<LifeEvent> events, DateTime createdAt, String? label
});


$BirthDataCopyWith<$Res> get birthData;$TimeWindowCopyWith<$Res> get timeWindow;

}
/// @nodoc
class _$CalculationRequestCopyWithImpl<$Res>
    implements $CalculationRequestCopyWith<$Res> {
  _$CalculationRequestCopyWithImpl(this._self, this._then);

  final CalculationRequest _self;
  final $Res Function(CalculationRequest) _then;

/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isDemo = null,Object? birthData = null,Object? timeWindow = null,Object? events = null,Object? createdAt = null,Object? label = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isDemo: null == isDemo ? _self.isDemo : isDemo // ignore: cast_nullable_to_non_nullable
as bool,birthData: null == birthData ? _self.birthData : birthData // ignore: cast_nullable_to_non_nullable
as BirthData,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as TimeWindow,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<LifeEvent>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthDataCopyWith<$Res> get birthData {
  
  return $BirthDataCopyWith<$Res>(_self.birthData, (value) {
    return _then(_self.copyWith(birthData: value));
  });
}/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get timeWindow {
  
  return $TimeWindowCopyWith<$Res>(_self.timeWindow, (value) {
    return _then(_self.copyWith(timeWindow: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalculationRequest].
extension CalculationRequestPatterns on CalculationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalculationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalculationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalculationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CalculationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalculationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CalculationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool isDemo,  BirthData birthData,  TimeWindow timeWindow,  List<LifeEvent> events,  DateTime createdAt,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalculationRequest() when $default != null:
return $default(_that.id,_that.isDemo,_that.birthData,_that.timeWindow,_that.events,_that.createdAt,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool isDemo,  BirthData birthData,  TimeWindow timeWindow,  List<LifeEvent> events,  DateTime createdAt,  String? label)  $default,) {final _that = this;
switch (_that) {
case _CalculationRequest():
return $default(_that.id,_that.isDemo,_that.birthData,_that.timeWindow,_that.events,_that.createdAt,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool isDemo,  BirthData birthData,  TimeWindow timeWindow,  List<LifeEvent> events,  DateTime createdAt,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _CalculationRequest() when $default != null:
return $default(_that.id,_that.isDemo,_that.birthData,_that.timeWindow,_that.events,_that.createdAt,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _CalculationRequest implements CalculationRequest {
  const _CalculationRequest({required this.id, required this.isDemo, required this.birthData, required this.timeWindow, required final  List<LifeEvent> events, required this.createdAt, this.label}): _events = events;
  

@override final  String id;
@override final  bool isDemo;
@override final  BirthData birthData;
@override final  TimeWindow timeWindow;
 final  List<LifeEvent> _events;
@override List<LifeEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  DateTime createdAt;
@override final  String? label;

/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalculationRequestCopyWith<_CalculationRequest> get copyWith => __$CalculationRequestCopyWithImpl<_CalculationRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalculationRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.isDemo, isDemo) || other.isDemo == isDemo)&&(identical(other.birthData, birthData) || other.birthData == birthData)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,isDemo,birthData,timeWindow,const DeepCollectionEquality().hash(_events),createdAt,label);

@override
String toString() {
  return 'CalculationRequest(id: $id, isDemo: $isDemo, birthData: $birthData, timeWindow: $timeWindow, events: $events, createdAt: $createdAt, label: $label)';
}


}

/// @nodoc
abstract mixin class _$CalculationRequestCopyWith<$Res> implements $CalculationRequestCopyWith<$Res> {
  factory _$CalculationRequestCopyWith(_CalculationRequest value, $Res Function(_CalculationRequest) _then) = __$CalculationRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, bool isDemo, BirthData birthData, TimeWindow timeWindow, List<LifeEvent> events, DateTime createdAt, String? label
});


@override $BirthDataCopyWith<$Res> get birthData;@override $TimeWindowCopyWith<$Res> get timeWindow;

}
/// @nodoc
class __$CalculationRequestCopyWithImpl<$Res>
    implements _$CalculationRequestCopyWith<$Res> {
  __$CalculationRequestCopyWithImpl(this._self, this._then);

  final _CalculationRequest _self;
  final $Res Function(_CalculationRequest) _then;

/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isDemo = null,Object? birthData = null,Object? timeWindow = null,Object? events = null,Object? createdAt = null,Object? label = freezed,}) {
  return _then(_CalculationRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isDemo: null == isDemo ? _self.isDemo : isDemo // ignore: cast_nullable_to_non_nullable
as bool,birthData: null == birthData ? _self.birthData : birthData // ignore: cast_nullable_to_non_nullable
as BirthData,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as TimeWindow,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<LifeEvent>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthDataCopyWith<$Res> get birthData {
  
  return $BirthDataCopyWith<$Res>(_self.birthData, (value) {
    return _then(_self.copyWith(birthData: value));
  });
}/// Create a copy of CalculationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get timeWindow {
  
  return $TimeWindowCopyWith<$Res>(_self.timeWindow, (value) {
    return _then(_self.copyWith(timeWindow: value));
  });
}
}

// dart format on
