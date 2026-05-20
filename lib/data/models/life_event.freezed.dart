// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'life_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LifeEvent {

 String get id; EventCategory get category; int get year; int get sortOrder; int? get month; String? get description;
/// Create a copy of LifeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LifeEventCopyWith<LifeEvent> get copyWith => _$LifeEventCopyWithImpl<LifeEvent>(this as LifeEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LifeEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.year, year) || other.year == year)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.month, month) || other.month == month)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,year,sortOrder,month,description);

@override
String toString() {
  return 'LifeEvent(id: $id, category: $category, year: $year, sortOrder: $sortOrder, month: $month, description: $description)';
}


}

/// @nodoc
abstract mixin class $LifeEventCopyWith<$Res>  {
  factory $LifeEventCopyWith(LifeEvent value, $Res Function(LifeEvent) _then) = _$LifeEventCopyWithImpl;
@useResult
$Res call({
 String id, EventCategory category, int year, int sortOrder, int? month, String? description
});




}
/// @nodoc
class _$LifeEventCopyWithImpl<$Res>
    implements $LifeEventCopyWith<$Res> {
  _$LifeEventCopyWithImpl(this._self, this._then);

  final LifeEvent _self;
  final $Res Function(LifeEvent) _then;

/// Create a copy of LifeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? year = null,Object? sortOrder = null,Object? month = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LifeEvent].
extension LifeEventPatterns on LifeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LifeEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LifeEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LifeEvent value)  $default,){
final _that = this;
switch (_that) {
case _LifeEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LifeEvent value)?  $default,){
final _that = this;
switch (_that) {
case _LifeEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EventCategory category,  int year,  int sortOrder,  int? month,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LifeEvent() when $default != null:
return $default(_that.id,_that.category,_that.year,_that.sortOrder,_that.month,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EventCategory category,  int year,  int sortOrder,  int? month,  String? description)  $default,) {final _that = this;
switch (_that) {
case _LifeEvent():
return $default(_that.id,_that.category,_that.year,_that.sortOrder,_that.month,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EventCategory category,  int year,  int sortOrder,  int? month,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _LifeEvent() when $default != null:
return $default(_that.id,_that.category,_that.year,_that.sortOrder,_that.month,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _LifeEvent implements LifeEvent {
  const _LifeEvent({required this.id, required this.category, required this.year, required this.sortOrder, this.month, this.description});
  

@override final  String id;
@override final  EventCategory category;
@override final  int year;
@override final  int sortOrder;
@override final  int? month;
@override final  String? description;

/// Create a copy of LifeEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LifeEventCopyWith<_LifeEvent> get copyWith => __$LifeEventCopyWithImpl<_LifeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LifeEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.year, year) || other.year == year)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.month, month) || other.month == month)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,year,sortOrder,month,description);

@override
String toString() {
  return 'LifeEvent(id: $id, category: $category, year: $year, sortOrder: $sortOrder, month: $month, description: $description)';
}


}

/// @nodoc
abstract mixin class _$LifeEventCopyWith<$Res> implements $LifeEventCopyWith<$Res> {
  factory _$LifeEventCopyWith(_LifeEvent value, $Res Function(_LifeEvent) _then) = __$LifeEventCopyWithImpl;
@override @useResult
$Res call({
 String id, EventCategory category, int year, int sortOrder, int? month, String? description
});




}
/// @nodoc
class __$LifeEventCopyWithImpl<$Res>
    implements _$LifeEventCopyWith<$Res> {
  __$LifeEventCopyWithImpl(this._self, this._then);

  final _LifeEvent _self;
  final $Res Function(_LifeEvent) _then;

/// Create a copy of LifeEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? year = null,Object? sortOrder = null,Object? month = freezed,Object? description = freezed,}) {
  return _then(_LifeEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
