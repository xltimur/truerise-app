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
mixin _$EventScoreDto {

@JsonKey(name: 'event_index') int get eventIndex;@JsonKey(name: 'event_date') String get eventDate;@JsonKey(name: 'event_category') String get eventCategory;@JsonKey(name: 'event_description') String? get eventDescription;@JsonKey(name: 'total_score') double get totalScore; String? get interpretation;
/// Create a copy of EventScoreDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventScoreDtoCopyWith<EventScoreDto> get copyWith => _$EventScoreDtoCopyWithImpl<EventScoreDto>(this as EventScoreDto, _$identity);

  /// Serializes this EventScoreDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventScoreDto&&(identical(other.eventIndex, eventIndex) || other.eventIndex == eventIndex)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.eventCategory, eventCategory) || other.eventCategory == eventCategory)&&(identical(other.eventDescription, eventDescription) || other.eventDescription == eventDescription)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.interpretation, interpretation) || other.interpretation == interpretation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventIndex,eventDate,eventCategory,eventDescription,totalScore,interpretation);

@override
String toString() {
  return 'EventScoreDto(eventIndex: $eventIndex, eventDate: $eventDate, eventCategory: $eventCategory, eventDescription: $eventDescription, totalScore: $totalScore, interpretation: $interpretation)';
}


}

/// @nodoc
abstract mixin class $EventScoreDtoCopyWith<$Res>  {
  factory $EventScoreDtoCopyWith(EventScoreDto value, $Res Function(EventScoreDto) _then) = _$EventScoreDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'event_index') int eventIndex,@JsonKey(name: 'event_date') String eventDate,@JsonKey(name: 'event_category') String eventCategory,@JsonKey(name: 'event_description') String? eventDescription,@JsonKey(name: 'total_score') double totalScore, String? interpretation
});




}
/// @nodoc
class _$EventScoreDtoCopyWithImpl<$Res>
    implements $EventScoreDtoCopyWith<$Res> {
  _$EventScoreDtoCopyWithImpl(this._self, this._then);

  final EventScoreDto _self;
  final $Res Function(EventScoreDto) _then;

/// Create a copy of EventScoreDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventIndex = null,Object? eventDate = null,Object? eventCategory = null,Object? eventDescription = freezed,Object? totalScore = null,Object? interpretation = freezed,}) {
  return _then(_self.copyWith(
eventIndex: null == eventIndex ? _self.eventIndex : eventIndex // ignore: cast_nullable_to_non_nullable
as int,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as String,eventCategory: null == eventCategory ? _self.eventCategory : eventCategory // ignore: cast_nullable_to_non_nullable
as String,eventDescription: freezed == eventDescription ? _self.eventDescription : eventDescription // ignore: cast_nullable_to_non_nullable
as String?,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,interpretation: freezed == interpretation ? _self.interpretation : interpretation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventScoreDto].
extension EventScoreDtoPatterns on EventScoreDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventScoreDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventScoreDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventScoreDto value)  $default,){
final _that = this;
switch (_that) {
case _EventScoreDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventScoreDto value)?  $default,){
final _that = this;
switch (_that) {
case _EventScoreDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'event_index')  int eventIndex, @JsonKey(name: 'event_date')  String eventDate, @JsonKey(name: 'event_category')  String eventCategory, @JsonKey(name: 'event_description')  String? eventDescription, @JsonKey(name: 'total_score')  double totalScore,  String? interpretation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventScoreDto() when $default != null:
return $default(_that.eventIndex,_that.eventDate,_that.eventCategory,_that.eventDescription,_that.totalScore,_that.interpretation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'event_index')  int eventIndex, @JsonKey(name: 'event_date')  String eventDate, @JsonKey(name: 'event_category')  String eventCategory, @JsonKey(name: 'event_description')  String? eventDescription, @JsonKey(name: 'total_score')  double totalScore,  String? interpretation)  $default,) {final _that = this;
switch (_that) {
case _EventScoreDto():
return $default(_that.eventIndex,_that.eventDate,_that.eventCategory,_that.eventDescription,_that.totalScore,_that.interpretation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'event_index')  int eventIndex, @JsonKey(name: 'event_date')  String eventDate, @JsonKey(name: 'event_category')  String eventCategory, @JsonKey(name: 'event_description')  String? eventDescription, @JsonKey(name: 'total_score')  double totalScore,  String? interpretation)?  $default,) {final _that = this;
switch (_that) {
case _EventScoreDto() when $default != null:
return $default(_that.eventIndex,_that.eventDate,_that.eventCategory,_that.eventDescription,_that.totalScore,_that.interpretation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventScoreDto implements EventScoreDto {
  const _EventScoreDto({@JsonKey(name: 'event_index') required this.eventIndex, @JsonKey(name: 'event_date') required this.eventDate, @JsonKey(name: 'event_category') required this.eventCategory, @JsonKey(name: 'event_description') this.eventDescription, @JsonKey(name: 'total_score') this.totalScore = 0.0, this.interpretation});
  factory _EventScoreDto.fromJson(Map<String, dynamic> json) => _$EventScoreDtoFromJson(json);

@override@JsonKey(name: 'event_index') final  int eventIndex;
@override@JsonKey(name: 'event_date') final  String eventDate;
@override@JsonKey(name: 'event_category') final  String eventCategory;
@override@JsonKey(name: 'event_description') final  String? eventDescription;
@override@JsonKey(name: 'total_score') final  double totalScore;
@override final  String? interpretation;

/// Create a copy of EventScoreDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventScoreDtoCopyWith<_EventScoreDto> get copyWith => __$EventScoreDtoCopyWithImpl<_EventScoreDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventScoreDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventScoreDto&&(identical(other.eventIndex, eventIndex) || other.eventIndex == eventIndex)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.eventCategory, eventCategory) || other.eventCategory == eventCategory)&&(identical(other.eventDescription, eventDescription) || other.eventDescription == eventDescription)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.interpretation, interpretation) || other.interpretation == interpretation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventIndex,eventDate,eventCategory,eventDescription,totalScore,interpretation);

@override
String toString() {
  return 'EventScoreDto(eventIndex: $eventIndex, eventDate: $eventDate, eventCategory: $eventCategory, eventDescription: $eventDescription, totalScore: $totalScore, interpretation: $interpretation)';
}


}

/// @nodoc
abstract mixin class _$EventScoreDtoCopyWith<$Res> implements $EventScoreDtoCopyWith<$Res> {
  factory _$EventScoreDtoCopyWith(_EventScoreDto value, $Res Function(_EventScoreDto) _then) = __$EventScoreDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'event_index') int eventIndex,@JsonKey(name: 'event_date') String eventDate,@JsonKey(name: 'event_category') String eventCategory,@JsonKey(name: 'event_description') String? eventDescription,@JsonKey(name: 'total_score') double totalScore, String? interpretation
});




}
/// @nodoc
class __$EventScoreDtoCopyWithImpl<$Res>
    implements _$EventScoreDtoCopyWith<$Res> {
  __$EventScoreDtoCopyWithImpl(this._self, this._then);

  final _EventScoreDto _self;
  final $Res Function(_EventScoreDto) _then;

/// Create a copy of EventScoreDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventIndex = null,Object? eventDate = null,Object? eventCategory = null,Object? eventDescription = freezed,Object? totalScore = null,Object? interpretation = freezed,}) {
  return _then(_EventScoreDto(
eventIndex: null == eventIndex ? _self.eventIndex : eventIndex // ignore: cast_nullable_to_non_nullable
as int,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as String,eventCategory: null == eventCategory ? _self.eventCategory : eventCategory // ignore: cast_nullable_to_non_nullable
as String,eventDescription: freezed == eventDescription ? _self.eventDescription : eventDescription // ignore: cast_nullable_to_non_nullable
as String?,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,interpretation: freezed == interpretation ? _self.interpretation : interpretation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CandidateV3Dto {

 int get rank; String get time;@JsonKey(name: 'aggregate_score') double get aggregateScore;@JsonKey(name: 'normalized_score') double get normalizedScore; String get grade;@JsonKey(name: 'event_scores') List<EventScoreDto> get eventScores;@JsonKey(name: 'events_strongly_correlated') int get eventsStronglyCorrelated; bool get excluded;@JsonKey(name: 'excluded_reason') String? get excludedReason; String? get error;@JsonKey(name: 'anchor_grade') bool get anchorGrade; Map<String, dynamic>? get chart;
/// Create a copy of CandidateV3Dto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CandidateV3DtoCopyWith<CandidateV3Dto> get copyWith => _$CandidateV3DtoCopyWithImpl<CandidateV3Dto>(this as CandidateV3Dto, _$identity);

  /// Serializes this CandidateV3Dto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CandidateV3Dto&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.time, time) || other.time == time)&&(identical(other.aggregateScore, aggregateScore) || other.aggregateScore == aggregateScore)&&(identical(other.normalizedScore, normalizedScore) || other.normalizedScore == normalizedScore)&&(identical(other.grade, grade) || other.grade == grade)&&const DeepCollectionEquality().equals(other.eventScores, eventScores)&&(identical(other.eventsStronglyCorrelated, eventsStronglyCorrelated) || other.eventsStronglyCorrelated == eventsStronglyCorrelated)&&(identical(other.excluded, excluded) || other.excluded == excluded)&&(identical(other.excludedReason, excludedReason) || other.excludedReason == excludedReason)&&(identical(other.error, error) || other.error == error)&&(identical(other.anchorGrade, anchorGrade) || other.anchorGrade == anchorGrade)&&const DeepCollectionEquality().equals(other.chart, chart));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,time,aggregateScore,normalizedScore,grade,const DeepCollectionEquality().hash(eventScores),eventsStronglyCorrelated,excluded,excludedReason,error,anchorGrade,const DeepCollectionEquality().hash(chart));

@override
String toString() {
  return 'CandidateV3Dto(rank: $rank, time: $time, aggregateScore: $aggregateScore, normalizedScore: $normalizedScore, grade: $grade, eventScores: $eventScores, eventsStronglyCorrelated: $eventsStronglyCorrelated, excluded: $excluded, excludedReason: $excludedReason, error: $error, anchorGrade: $anchorGrade, chart: $chart)';
}


}

/// @nodoc
abstract mixin class $CandidateV3DtoCopyWith<$Res>  {
  factory $CandidateV3DtoCopyWith(CandidateV3Dto value, $Res Function(CandidateV3Dto) _then) = _$CandidateV3DtoCopyWithImpl;
@useResult
$Res call({
 int rank, String time,@JsonKey(name: 'aggregate_score') double aggregateScore,@JsonKey(name: 'normalized_score') double normalizedScore, String grade,@JsonKey(name: 'event_scores') List<EventScoreDto> eventScores,@JsonKey(name: 'events_strongly_correlated') int eventsStronglyCorrelated, bool excluded,@JsonKey(name: 'excluded_reason') String? excludedReason, String? error,@JsonKey(name: 'anchor_grade') bool anchorGrade, Map<String, dynamic>? chart
});




}
/// @nodoc
class _$CandidateV3DtoCopyWithImpl<$Res>
    implements $CandidateV3DtoCopyWith<$Res> {
  _$CandidateV3DtoCopyWithImpl(this._self, this._then);

  final CandidateV3Dto _self;
  final $Res Function(CandidateV3Dto) _then;

/// Create a copy of CandidateV3Dto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? time = null,Object? aggregateScore = null,Object? normalizedScore = null,Object? grade = null,Object? eventScores = null,Object? eventsStronglyCorrelated = null,Object? excluded = null,Object? excludedReason = freezed,Object? error = freezed,Object? anchorGrade = null,Object? chart = freezed,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,aggregateScore: null == aggregateScore ? _self.aggregateScore : aggregateScore // ignore: cast_nullable_to_non_nullable
as double,normalizedScore: null == normalizedScore ? _self.normalizedScore : normalizedScore // ignore: cast_nullable_to_non_nullable
as double,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,eventScores: null == eventScores ? _self.eventScores : eventScores // ignore: cast_nullable_to_non_nullable
as List<EventScoreDto>,eventsStronglyCorrelated: null == eventsStronglyCorrelated ? _self.eventsStronglyCorrelated : eventsStronglyCorrelated // ignore: cast_nullable_to_non_nullable
as int,excluded: null == excluded ? _self.excluded : excluded // ignore: cast_nullable_to_non_nullable
as bool,excludedReason: freezed == excludedReason ? _self.excludedReason : excludedReason // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,anchorGrade: null == anchorGrade ? _self.anchorGrade : anchorGrade // ignore: cast_nullable_to_non_nullable
as bool,chart: freezed == chart ? _self.chart : chart // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CandidateV3Dto].
extension CandidateV3DtoPatterns on CandidateV3Dto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CandidateV3Dto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CandidateV3Dto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CandidateV3Dto value)  $default,){
final _that = this;
switch (_that) {
case _CandidateV3Dto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CandidateV3Dto value)?  $default,){
final _that = this;
switch (_that) {
case _CandidateV3Dto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  String time, @JsonKey(name: 'aggregate_score')  double aggregateScore, @JsonKey(name: 'normalized_score')  double normalizedScore,  String grade, @JsonKey(name: 'event_scores')  List<EventScoreDto> eventScores, @JsonKey(name: 'events_strongly_correlated')  int eventsStronglyCorrelated,  bool excluded, @JsonKey(name: 'excluded_reason')  String? excludedReason,  String? error, @JsonKey(name: 'anchor_grade')  bool anchorGrade,  Map<String, dynamic>? chart)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CandidateV3Dto() when $default != null:
return $default(_that.rank,_that.time,_that.aggregateScore,_that.normalizedScore,_that.grade,_that.eventScores,_that.eventsStronglyCorrelated,_that.excluded,_that.excludedReason,_that.error,_that.anchorGrade,_that.chart);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  String time, @JsonKey(name: 'aggregate_score')  double aggregateScore, @JsonKey(name: 'normalized_score')  double normalizedScore,  String grade, @JsonKey(name: 'event_scores')  List<EventScoreDto> eventScores, @JsonKey(name: 'events_strongly_correlated')  int eventsStronglyCorrelated,  bool excluded, @JsonKey(name: 'excluded_reason')  String? excludedReason,  String? error, @JsonKey(name: 'anchor_grade')  bool anchorGrade,  Map<String, dynamic>? chart)  $default,) {final _that = this;
switch (_that) {
case _CandidateV3Dto():
return $default(_that.rank,_that.time,_that.aggregateScore,_that.normalizedScore,_that.grade,_that.eventScores,_that.eventsStronglyCorrelated,_that.excluded,_that.excludedReason,_that.error,_that.anchorGrade,_that.chart);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  String time, @JsonKey(name: 'aggregate_score')  double aggregateScore, @JsonKey(name: 'normalized_score')  double normalizedScore,  String grade, @JsonKey(name: 'event_scores')  List<EventScoreDto> eventScores, @JsonKey(name: 'events_strongly_correlated')  int eventsStronglyCorrelated,  bool excluded, @JsonKey(name: 'excluded_reason')  String? excludedReason,  String? error, @JsonKey(name: 'anchor_grade')  bool anchorGrade,  Map<String, dynamic>? chart)?  $default,) {final _that = this;
switch (_that) {
case _CandidateV3Dto() when $default != null:
return $default(_that.rank,_that.time,_that.aggregateScore,_that.normalizedScore,_that.grade,_that.eventScores,_that.eventsStronglyCorrelated,_that.excluded,_that.excludedReason,_that.error,_that.anchorGrade,_that.chart);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CandidateV3Dto implements CandidateV3Dto {
  const _CandidateV3Dto({required this.rank, required this.time, @JsonKey(name: 'aggregate_score') this.aggregateScore = 0.0, @JsonKey(name: 'normalized_score') this.normalizedScore = 0.0, this.grade = '', @JsonKey(name: 'event_scores') final  List<EventScoreDto> eventScores = const <EventScoreDto>[], @JsonKey(name: 'events_strongly_correlated') this.eventsStronglyCorrelated = 0, this.excluded = false, @JsonKey(name: 'excluded_reason') this.excludedReason, this.error, @JsonKey(name: 'anchor_grade') this.anchorGrade = false, final  Map<String, dynamic>? chart}): _eventScores = eventScores,_chart = chart;
  factory _CandidateV3Dto.fromJson(Map<String, dynamic> json) => _$CandidateV3DtoFromJson(json);

@override final  int rank;
@override final  String time;
@override@JsonKey(name: 'aggregate_score') final  double aggregateScore;
@override@JsonKey(name: 'normalized_score') final  double normalizedScore;
@override@JsonKey() final  String grade;
 final  List<EventScoreDto> _eventScores;
@override@JsonKey(name: 'event_scores') List<EventScoreDto> get eventScores {
  if (_eventScores is EqualUnmodifiableListView) return _eventScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eventScores);
}

@override@JsonKey(name: 'events_strongly_correlated') final  int eventsStronglyCorrelated;
@override@JsonKey() final  bool excluded;
@override@JsonKey(name: 'excluded_reason') final  String? excludedReason;
@override final  String? error;
@override@JsonKey(name: 'anchor_grade') final  bool anchorGrade;
 final  Map<String, dynamic>? _chart;
@override Map<String, dynamic>? get chart {
  final value = _chart;
  if (value == null) return null;
  if (_chart is EqualUnmodifiableMapView) return _chart;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CandidateV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CandidateV3DtoCopyWith<_CandidateV3Dto> get copyWith => __$CandidateV3DtoCopyWithImpl<_CandidateV3Dto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CandidateV3DtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CandidateV3Dto&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.time, time) || other.time == time)&&(identical(other.aggregateScore, aggregateScore) || other.aggregateScore == aggregateScore)&&(identical(other.normalizedScore, normalizedScore) || other.normalizedScore == normalizedScore)&&(identical(other.grade, grade) || other.grade == grade)&&const DeepCollectionEquality().equals(other._eventScores, _eventScores)&&(identical(other.eventsStronglyCorrelated, eventsStronglyCorrelated) || other.eventsStronglyCorrelated == eventsStronglyCorrelated)&&(identical(other.excluded, excluded) || other.excluded == excluded)&&(identical(other.excludedReason, excludedReason) || other.excludedReason == excludedReason)&&(identical(other.error, error) || other.error == error)&&(identical(other.anchorGrade, anchorGrade) || other.anchorGrade == anchorGrade)&&const DeepCollectionEquality().equals(other._chart, _chart));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,time,aggregateScore,normalizedScore,grade,const DeepCollectionEquality().hash(_eventScores),eventsStronglyCorrelated,excluded,excludedReason,error,anchorGrade,const DeepCollectionEquality().hash(_chart));

@override
String toString() {
  return 'CandidateV3Dto(rank: $rank, time: $time, aggregateScore: $aggregateScore, normalizedScore: $normalizedScore, grade: $grade, eventScores: $eventScores, eventsStronglyCorrelated: $eventsStronglyCorrelated, excluded: $excluded, excludedReason: $excludedReason, error: $error, anchorGrade: $anchorGrade, chart: $chart)';
}


}

/// @nodoc
abstract mixin class _$CandidateV3DtoCopyWith<$Res> implements $CandidateV3DtoCopyWith<$Res> {
  factory _$CandidateV3DtoCopyWith(_CandidateV3Dto value, $Res Function(_CandidateV3Dto) _then) = __$CandidateV3DtoCopyWithImpl;
@override @useResult
$Res call({
 int rank, String time,@JsonKey(name: 'aggregate_score') double aggregateScore,@JsonKey(name: 'normalized_score') double normalizedScore, String grade,@JsonKey(name: 'event_scores') List<EventScoreDto> eventScores,@JsonKey(name: 'events_strongly_correlated') int eventsStronglyCorrelated, bool excluded,@JsonKey(name: 'excluded_reason') String? excludedReason, String? error,@JsonKey(name: 'anchor_grade') bool anchorGrade, Map<String, dynamic>? chart
});




}
/// @nodoc
class __$CandidateV3DtoCopyWithImpl<$Res>
    implements _$CandidateV3DtoCopyWith<$Res> {
  __$CandidateV3DtoCopyWithImpl(this._self, this._then);

  final _CandidateV3Dto _self;
  final $Res Function(_CandidateV3Dto) _then;

/// Create a copy of CandidateV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? time = null,Object? aggregateScore = null,Object? normalizedScore = null,Object? grade = null,Object? eventScores = null,Object? eventsStronglyCorrelated = null,Object? excluded = null,Object? excludedReason = freezed,Object? error = freezed,Object? anchorGrade = null,Object? chart = freezed,}) {
  return _then(_CandidateV3Dto(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,aggregateScore: null == aggregateScore ? _self.aggregateScore : aggregateScore // ignore: cast_nullable_to_non_nullable
as double,normalizedScore: null == normalizedScore ? _self.normalizedScore : normalizedScore // ignore: cast_nullable_to_non_nullable
as double,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,eventScores: null == eventScores ? _self._eventScores : eventScores // ignore: cast_nullable_to_non_nullable
as List<EventScoreDto>,eventsStronglyCorrelated: null == eventsStronglyCorrelated ? _self.eventsStronglyCorrelated : eventsStronglyCorrelated // ignore: cast_nullable_to_non_nullable
as int,excluded: null == excluded ? _self.excluded : excluded // ignore: cast_nullable_to_non_nullable
as bool,excludedReason: freezed == excludedReason ? _self.excludedReason : excludedReason // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,anchorGrade: null == anchorGrade ? _self.anchorGrade : anchorGrade // ignore: cast_nullable_to_non_nullable
as bool,chart: freezed == chart ? _self._chart : chart // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$ConfidenceAssessmentDto {

 String get level; String get explanation;@JsonKey(name: 'gap_ratio') double get gapRatio;@JsonKey(name: 'lift_ratio') double get liftRatio;
/// Create a copy of ConfidenceAssessmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfidenceAssessmentDtoCopyWith<ConfidenceAssessmentDto> get copyWith => _$ConfidenceAssessmentDtoCopyWithImpl<ConfidenceAssessmentDto>(this as ConfidenceAssessmentDto, _$identity);

  /// Serializes this ConfidenceAssessmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfidenceAssessmentDto&&(identical(other.level, level) || other.level == level)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.gapRatio, gapRatio) || other.gapRatio == gapRatio)&&(identical(other.liftRatio, liftRatio) || other.liftRatio == liftRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,explanation,gapRatio,liftRatio);

@override
String toString() {
  return 'ConfidenceAssessmentDto(level: $level, explanation: $explanation, gapRatio: $gapRatio, liftRatio: $liftRatio)';
}


}

/// @nodoc
abstract mixin class $ConfidenceAssessmentDtoCopyWith<$Res>  {
  factory $ConfidenceAssessmentDtoCopyWith(ConfidenceAssessmentDto value, $Res Function(ConfidenceAssessmentDto) _then) = _$ConfidenceAssessmentDtoCopyWithImpl;
@useResult
$Res call({
 String level, String explanation,@JsonKey(name: 'gap_ratio') double gapRatio,@JsonKey(name: 'lift_ratio') double liftRatio
});




}
/// @nodoc
class _$ConfidenceAssessmentDtoCopyWithImpl<$Res>
    implements $ConfidenceAssessmentDtoCopyWith<$Res> {
  _$ConfidenceAssessmentDtoCopyWithImpl(this._self, this._then);

  final ConfidenceAssessmentDto _self;
  final $Res Function(ConfidenceAssessmentDto) _then;

/// Create a copy of ConfidenceAssessmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? explanation = null,Object? gapRatio = null,Object? liftRatio = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,gapRatio: null == gapRatio ? _self.gapRatio : gapRatio // ignore: cast_nullable_to_non_nullable
as double,liftRatio: null == liftRatio ? _self.liftRatio : liftRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfidenceAssessmentDto].
extension ConfidenceAssessmentDtoPatterns on ConfidenceAssessmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfidenceAssessmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfidenceAssessmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfidenceAssessmentDto value)  $default,){
final _that = this;
switch (_that) {
case _ConfidenceAssessmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfidenceAssessmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConfidenceAssessmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String level,  String explanation, @JsonKey(name: 'gap_ratio')  double gapRatio, @JsonKey(name: 'lift_ratio')  double liftRatio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfidenceAssessmentDto() when $default != null:
return $default(_that.level,_that.explanation,_that.gapRatio,_that.liftRatio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String level,  String explanation, @JsonKey(name: 'gap_ratio')  double gapRatio, @JsonKey(name: 'lift_ratio')  double liftRatio)  $default,) {final _that = this;
switch (_that) {
case _ConfidenceAssessmentDto():
return $default(_that.level,_that.explanation,_that.gapRatio,_that.liftRatio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String level,  String explanation, @JsonKey(name: 'gap_ratio')  double gapRatio, @JsonKey(name: 'lift_ratio')  double liftRatio)?  $default,) {final _that = this;
switch (_that) {
case _ConfidenceAssessmentDto() when $default != null:
return $default(_that.level,_that.explanation,_that.gapRatio,_that.liftRatio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfidenceAssessmentDto implements ConfidenceAssessmentDto {
  const _ConfidenceAssessmentDto({this.level = '', this.explanation = '', @JsonKey(name: 'gap_ratio') this.gapRatio = 0.0, @JsonKey(name: 'lift_ratio') this.liftRatio = 0.0});
  factory _ConfidenceAssessmentDto.fromJson(Map<String, dynamic> json) => _$ConfidenceAssessmentDtoFromJson(json);

@override@JsonKey() final  String level;
@override@JsonKey() final  String explanation;
@override@JsonKey(name: 'gap_ratio') final  double gapRatio;
@override@JsonKey(name: 'lift_ratio') final  double liftRatio;

/// Create a copy of ConfidenceAssessmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfidenceAssessmentDtoCopyWith<_ConfidenceAssessmentDto> get copyWith => __$ConfidenceAssessmentDtoCopyWithImpl<_ConfidenceAssessmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfidenceAssessmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfidenceAssessmentDto&&(identical(other.level, level) || other.level == level)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.gapRatio, gapRatio) || other.gapRatio == gapRatio)&&(identical(other.liftRatio, liftRatio) || other.liftRatio == liftRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,explanation,gapRatio,liftRatio);

@override
String toString() {
  return 'ConfidenceAssessmentDto(level: $level, explanation: $explanation, gapRatio: $gapRatio, liftRatio: $liftRatio)';
}


}

/// @nodoc
abstract mixin class _$ConfidenceAssessmentDtoCopyWith<$Res> implements $ConfidenceAssessmentDtoCopyWith<$Res> {
  factory _$ConfidenceAssessmentDtoCopyWith(_ConfidenceAssessmentDto value, $Res Function(_ConfidenceAssessmentDto) _then) = __$ConfidenceAssessmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String level, String explanation,@JsonKey(name: 'gap_ratio') double gapRatio,@JsonKey(name: 'lift_ratio') double liftRatio
});




}
/// @nodoc
class __$ConfidenceAssessmentDtoCopyWithImpl<$Res>
    implements _$ConfidenceAssessmentDtoCopyWith<$Res> {
  __$ConfidenceAssessmentDtoCopyWithImpl(this._self, this._then);

  final _ConfidenceAssessmentDto _self;
  final $Res Function(_ConfidenceAssessmentDto) _then;

/// Create a copy of ConfidenceAssessmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? explanation = null,Object? gapRatio = null,Object? liftRatio = null,}) {
  return _then(_ConfidenceAssessmentDto(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,gapRatio: null == gapRatio ? _self.gapRatio : gapRatio // ignore: cast_nullable_to_non_nullable
as double,liftRatio: null == liftRatio ? _self.liftRatio : liftRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SummaryV3Dto {

 ConfidenceAssessmentDto? get confidence;@JsonKey(name: 'peak_time') String? get peakTime;@JsonKey(name: 'techniques_used') List<String> get techniquesUsed;@JsonKey(name: 'step_minutes') int? get stepMinutes;@JsonKey(name: 'total_candidates_returned') int? get totalCandidatesReturned;@JsonKey(name: 'quality_advisory') String? get qualityAdvisory;
/// Create a copy of SummaryV3Dto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SummaryV3DtoCopyWith<SummaryV3Dto> get copyWith => _$SummaryV3DtoCopyWithImpl<SummaryV3Dto>(this as SummaryV3Dto, _$identity);

  /// Serializes this SummaryV3Dto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SummaryV3Dto&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.peakTime, peakTime) || other.peakTime == peakTime)&&const DeepCollectionEquality().equals(other.techniquesUsed, techniquesUsed)&&(identical(other.stepMinutes, stepMinutes) || other.stepMinutes == stepMinutes)&&(identical(other.totalCandidatesReturned, totalCandidatesReturned) || other.totalCandidatesReturned == totalCandidatesReturned)&&(identical(other.qualityAdvisory, qualityAdvisory) || other.qualityAdvisory == qualityAdvisory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,confidence,peakTime,const DeepCollectionEquality().hash(techniquesUsed),stepMinutes,totalCandidatesReturned,qualityAdvisory);

@override
String toString() {
  return 'SummaryV3Dto(confidence: $confidence, peakTime: $peakTime, techniquesUsed: $techniquesUsed, stepMinutes: $stepMinutes, totalCandidatesReturned: $totalCandidatesReturned, qualityAdvisory: $qualityAdvisory)';
}


}

/// @nodoc
abstract mixin class $SummaryV3DtoCopyWith<$Res>  {
  factory $SummaryV3DtoCopyWith(SummaryV3Dto value, $Res Function(SummaryV3Dto) _then) = _$SummaryV3DtoCopyWithImpl;
@useResult
$Res call({
 ConfidenceAssessmentDto? confidence,@JsonKey(name: 'peak_time') String? peakTime,@JsonKey(name: 'techniques_used') List<String> techniquesUsed,@JsonKey(name: 'step_minutes') int? stepMinutes,@JsonKey(name: 'total_candidates_returned') int? totalCandidatesReturned,@JsonKey(name: 'quality_advisory') String? qualityAdvisory
});


$ConfidenceAssessmentDtoCopyWith<$Res>? get confidence;

}
/// @nodoc
class _$SummaryV3DtoCopyWithImpl<$Res>
    implements $SummaryV3DtoCopyWith<$Res> {
  _$SummaryV3DtoCopyWithImpl(this._self, this._then);

  final SummaryV3Dto _self;
  final $Res Function(SummaryV3Dto) _then;

/// Create a copy of SummaryV3Dto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? confidence = freezed,Object? peakTime = freezed,Object? techniquesUsed = null,Object? stepMinutes = freezed,Object? totalCandidatesReturned = freezed,Object? qualityAdvisory = freezed,}) {
  return _then(_self.copyWith(
confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceAssessmentDto?,peakTime: freezed == peakTime ? _self.peakTime : peakTime // ignore: cast_nullable_to_non_nullable
as String?,techniquesUsed: null == techniquesUsed ? _self.techniquesUsed : techniquesUsed // ignore: cast_nullable_to_non_nullable
as List<String>,stepMinutes: freezed == stepMinutes ? _self.stepMinutes : stepMinutes // ignore: cast_nullable_to_non_nullable
as int?,totalCandidatesReturned: freezed == totalCandidatesReturned ? _self.totalCandidatesReturned : totalCandidatesReturned // ignore: cast_nullable_to_non_nullable
as int?,qualityAdvisory: freezed == qualityAdvisory ? _self.qualityAdvisory : qualityAdvisory // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SummaryV3Dto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConfidenceAssessmentDtoCopyWith<$Res>? get confidence {
    if (_self.confidence == null) {
    return null;
  }

  return $ConfidenceAssessmentDtoCopyWith<$Res>(_self.confidence!, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}


/// Adds pattern-matching-related methods to [SummaryV3Dto].
extension SummaryV3DtoPatterns on SummaryV3Dto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SummaryV3Dto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SummaryV3Dto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SummaryV3Dto value)  $default,){
final _that = this;
switch (_that) {
case _SummaryV3Dto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SummaryV3Dto value)?  $default,){
final _that = this;
switch (_that) {
case _SummaryV3Dto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConfidenceAssessmentDto? confidence, @JsonKey(name: 'peak_time')  String? peakTime, @JsonKey(name: 'techniques_used')  List<String> techniquesUsed, @JsonKey(name: 'step_minutes')  int? stepMinutes, @JsonKey(name: 'total_candidates_returned')  int? totalCandidatesReturned, @JsonKey(name: 'quality_advisory')  String? qualityAdvisory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SummaryV3Dto() when $default != null:
return $default(_that.confidence,_that.peakTime,_that.techniquesUsed,_that.stepMinutes,_that.totalCandidatesReturned,_that.qualityAdvisory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConfidenceAssessmentDto? confidence, @JsonKey(name: 'peak_time')  String? peakTime, @JsonKey(name: 'techniques_used')  List<String> techniquesUsed, @JsonKey(name: 'step_minutes')  int? stepMinutes, @JsonKey(name: 'total_candidates_returned')  int? totalCandidatesReturned, @JsonKey(name: 'quality_advisory')  String? qualityAdvisory)  $default,) {final _that = this;
switch (_that) {
case _SummaryV3Dto():
return $default(_that.confidence,_that.peakTime,_that.techniquesUsed,_that.stepMinutes,_that.totalCandidatesReturned,_that.qualityAdvisory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConfidenceAssessmentDto? confidence, @JsonKey(name: 'peak_time')  String? peakTime, @JsonKey(name: 'techniques_used')  List<String> techniquesUsed, @JsonKey(name: 'step_minutes')  int? stepMinutes, @JsonKey(name: 'total_candidates_returned')  int? totalCandidatesReturned, @JsonKey(name: 'quality_advisory')  String? qualityAdvisory)?  $default,) {final _that = this;
switch (_that) {
case _SummaryV3Dto() when $default != null:
return $default(_that.confidence,_that.peakTime,_that.techniquesUsed,_that.stepMinutes,_that.totalCandidatesReturned,_that.qualityAdvisory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SummaryV3Dto implements SummaryV3Dto {
  const _SummaryV3Dto({this.confidence, @JsonKey(name: 'peak_time') this.peakTime, @JsonKey(name: 'techniques_used') final  List<String> techniquesUsed = const <String>[], @JsonKey(name: 'step_minutes') this.stepMinutes, @JsonKey(name: 'total_candidates_returned') this.totalCandidatesReturned, @JsonKey(name: 'quality_advisory') this.qualityAdvisory}): _techniquesUsed = techniquesUsed;
  factory _SummaryV3Dto.fromJson(Map<String, dynamic> json) => _$SummaryV3DtoFromJson(json);

@override final  ConfidenceAssessmentDto? confidence;
@override@JsonKey(name: 'peak_time') final  String? peakTime;
 final  List<String> _techniquesUsed;
@override@JsonKey(name: 'techniques_used') List<String> get techniquesUsed {
  if (_techniquesUsed is EqualUnmodifiableListView) return _techniquesUsed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_techniquesUsed);
}

@override@JsonKey(name: 'step_minutes') final  int? stepMinutes;
@override@JsonKey(name: 'total_candidates_returned') final  int? totalCandidatesReturned;
@override@JsonKey(name: 'quality_advisory') final  String? qualityAdvisory;

/// Create a copy of SummaryV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SummaryV3DtoCopyWith<_SummaryV3Dto> get copyWith => __$SummaryV3DtoCopyWithImpl<_SummaryV3Dto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SummaryV3DtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SummaryV3Dto&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.peakTime, peakTime) || other.peakTime == peakTime)&&const DeepCollectionEquality().equals(other._techniquesUsed, _techniquesUsed)&&(identical(other.stepMinutes, stepMinutes) || other.stepMinutes == stepMinutes)&&(identical(other.totalCandidatesReturned, totalCandidatesReturned) || other.totalCandidatesReturned == totalCandidatesReturned)&&(identical(other.qualityAdvisory, qualityAdvisory) || other.qualityAdvisory == qualityAdvisory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,confidence,peakTime,const DeepCollectionEquality().hash(_techniquesUsed),stepMinutes,totalCandidatesReturned,qualityAdvisory);

@override
String toString() {
  return 'SummaryV3Dto(confidence: $confidence, peakTime: $peakTime, techniquesUsed: $techniquesUsed, stepMinutes: $stepMinutes, totalCandidatesReturned: $totalCandidatesReturned, qualityAdvisory: $qualityAdvisory)';
}


}

/// @nodoc
abstract mixin class _$SummaryV3DtoCopyWith<$Res> implements $SummaryV3DtoCopyWith<$Res> {
  factory _$SummaryV3DtoCopyWith(_SummaryV3Dto value, $Res Function(_SummaryV3Dto) _then) = __$SummaryV3DtoCopyWithImpl;
@override @useResult
$Res call({
 ConfidenceAssessmentDto? confidence,@JsonKey(name: 'peak_time') String? peakTime,@JsonKey(name: 'techniques_used') List<String> techniquesUsed,@JsonKey(name: 'step_minutes') int? stepMinutes,@JsonKey(name: 'total_candidates_returned') int? totalCandidatesReturned,@JsonKey(name: 'quality_advisory') String? qualityAdvisory
});


@override $ConfidenceAssessmentDtoCopyWith<$Res>? get confidence;

}
/// @nodoc
class __$SummaryV3DtoCopyWithImpl<$Res>
    implements _$SummaryV3DtoCopyWith<$Res> {
  __$SummaryV3DtoCopyWithImpl(this._self, this._then);

  final _SummaryV3Dto _self;
  final $Res Function(_SummaryV3Dto) _then;

/// Create a copy of SummaryV3Dto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? confidence = freezed,Object? peakTime = freezed,Object? techniquesUsed = null,Object? stepMinutes = freezed,Object? totalCandidatesReturned = freezed,Object? qualityAdvisory = freezed,}) {
  return _then(_SummaryV3Dto(
confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceAssessmentDto?,peakTime: freezed == peakTime ? _self.peakTime : peakTime // ignore: cast_nullable_to_non_nullable
as String?,techniquesUsed: null == techniquesUsed ? _self._techniquesUsed : techniquesUsed // ignore: cast_nullable_to_non_nullable
as List<String>,stepMinutes: freezed == stepMinutes ? _self.stepMinutes : stepMinutes // ignore: cast_nullable_to_non_nullable
as int?,totalCandidatesReturned: freezed == totalCandidatesReturned ? _self.totalCandidatesReturned : totalCandidatesReturned // ignore: cast_nullable_to_non_nullable
as int?,qualityAdvisory: freezed == qualityAdvisory ? _self.qualityAdvisory : qualityAdvisory // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SummaryV3Dto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConfidenceAssessmentDtoCopyWith<$Res>? get confidence {
    if (_self.confidence == null) {
    return null;
  }

  return $ConfidenceAssessmentDtoCopyWith<$Res>(_self.confidence!, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}


/// @nodoc
mixin _$RectificationSearchResponseDto {

 List<CandidateV3Dto> get candidates; SummaryV3Dto? get summary;@JsonKey(name: 'computed_at') String? get computedAt;
/// Create a copy of RectificationSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RectificationSearchResponseDtoCopyWith<RectificationSearchResponseDto> get copyWith => _$RectificationSearchResponseDtoCopyWithImpl<RectificationSearchResponseDto>(this as RectificationSearchResponseDto, _$identity);

  /// Serializes this RectificationSearchResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RectificationSearchResponseDto&&const DeepCollectionEquality().equals(other.candidates, candidates)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.computedAt, computedAt) || other.computedAt == computedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(candidates),summary,computedAt);

@override
String toString() {
  return 'RectificationSearchResponseDto(candidates: $candidates, summary: $summary, computedAt: $computedAt)';
}


}

/// @nodoc
abstract mixin class $RectificationSearchResponseDtoCopyWith<$Res>  {
  factory $RectificationSearchResponseDtoCopyWith(RectificationSearchResponseDto value, $Res Function(RectificationSearchResponseDto) _then) = _$RectificationSearchResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<CandidateV3Dto> candidates, SummaryV3Dto? summary,@JsonKey(name: 'computed_at') String? computedAt
});


$SummaryV3DtoCopyWith<$Res>? get summary;

}
/// @nodoc
class _$RectificationSearchResponseDtoCopyWithImpl<$Res>
    implements $RectificationSearchResponseDtoCopyWith<$Res> {
  _$RectificationSearchResponseDtoCopyWithImpl(this._self, this._then);

  final RectificationSearchResponseDto _self;
  final $Res Function(RectificationSearchResponseDto) _then;

/// Create a copy of RectificationSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? candidates = null,Object? summary = freezed,Object? computedAt = freezed,}) {
  return _then(_self.copyWith(
candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<CandidateV3Dto>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as SummaryV3Dto?,computedAt: freezed == computedAt ? _self.computedAt : computedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RectificationSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SummaryV3DtoCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $SummaryV3DtoCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [RectificationSearchResponseDto].
extension RectificationSearchResponseDtoPatterns on RectificationSearchResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RectificationSearchResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RectificationSearchResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RectificationSearchResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _RectificationSearchResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RectificationSearchResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _RectificationSearchResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CandidateV3Dto> candidates,  SummaryV3Dto? summary, @JsonKey(name: 'computed_at')  String? computedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RectificationSearchResponseDto() when $default != null:
return $default(_that.candidates,_that.summary,_that.computedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CandidateV3Dto> candidates,  SummaryV3Dto? summary, @JsonKey(name: 'computed_at')  String? computedAt)  $default,) {final _that = this;
switch (_that) {
case _RectificationSearchResponseDto():
return $default(_that.candidates,_that.summary,_that.computedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CandidateV3Dto> candidates,  SummaryV3Dto? summary, @JsonKey(name: 'computed_at')  String? computedAt)?  $default,) {final _that = this;
switch (_that) {
case _RectificationSearchResponseDto() when $default != null:
return $default(_that.candidates,_that.summary,_that.computedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RectificationSearchResponseDto implements RectificationSearchResponseDto {
  const _RectificationSearchResponseDto({required final  List<CandidateV3Dto> candidates, this.summary, @JsonKey(name: 'computed_at') this.computedAt}): _candidates = candidates;
  factory _RectificationSearchResponseDto.fromJson(Map<String, dynamic> json) => _$RectificationSearchResponseDtoFromJson(json);

 final  List<CandidateV3Dto> _candidates;
@override List<CandidateV3Dto> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}

@override final  SummaryV3Dto? summary;
@override@JsonKey(name: 'computed_at') final  String? computedAt;

/// Create a copy of RectificationSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RectificationSearchResponseDtoCopyWith<_RectificationSearchResponseDto> get copyWith => __$RectificationSearchResponseDtoCopyWithImpl<_RectificationSearchResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RectificationSearchResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RectificationSearchResponseDto&&const DeepCollectionEquality().equals(other._candidates, _candidates)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.computedAt, computedAt) || other.computedAt == computedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_candidates),summary,computedAt);

@override
String toString() {
  return 'RectificationSearchResponseDto(candidates: $candidates, summary: $summary, computedAt: $computedAt)';
}


}

/// @nodoc
abstract mixin class _$RectificationSearchResponseDtoCopyWith<$Res> implements $RectificationSearchResponseDtoCopyWith<$Res> {
  factory _$RectificationSearchResponseDtoCopyWith(_RectificationSearchResponseDto value, $Res Function(_RectificationSearchResponseDto) _then) = __$RectificationSearchResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CandidateV3Dto> candidates, SummaryV3Dto? summary,@JsonKey(name: 'computed_at') String? computedAt
});


@override $SummaryV3DtoCopyWith<$Res>? get summary;

}
/// @nodoc
class __$RectificationSearchResponseDtoCopyWithImpl<$Res>
    implements _$RectificationSearchResponseDtoCopyWith<$Res> {
  __$RectificationSearchResponseDtoCopyWithImpl(this._self, this._then);

  final _RectificationSearchResponseDto _self;
  final $Res Function(_RectificationSearchResponseDto) _then;

/// Create a copy of RectificationSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? candidates = null,Object? summary = freezed,Object? computedAt = freezed,}) {
  return _then(_RectificationSearchResponseDto(
candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<CandidateV3Dto>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as SummaryV3Dto?,computedAt: freezed == computedAt ? _self.computedAt : computedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RectificationSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SummaryV3DtoCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $SummaryV3DtoCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
