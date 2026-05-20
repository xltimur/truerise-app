import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/time_window.dart';

part 'calculation_request.freezed.dart';

/// Envelope built by the calculation flow and consumed by
/// `RectificationRepository.submit()`
/// (`docs/implementation-plan.md` §7.1).
@freezed
abstract class CalculationRequest with _$CalculationRequest {
  const factory CalculationRequest({
    required String id,
    required bool isDemo,
    required BirthData birthData,
    required TimeWindow timeWindow,
    required List<LifeEvent> events,
    required DateTime createdAt,
    String? label,
  }) = _CalculationRequest;
}
