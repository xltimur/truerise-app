import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/time_window.dart' show TimeOfDayConverter;

part 'candidate_time.freezed.dart';

/// One rectification candidate returned by the provider
/// (`docs/implementation-plan.md` §7.1).
@freezed
abstract class CandidateTime with _$CandidateTime {
  const factory CandidateTime({
    required int rank,
    @TimeOfDayConverter() required TimeOfDay time,
    required double confidence,
    String? ascendant,
  }) = _CandidateTime;
}
