import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';

part 'saved_calculation.freezed.dart';

/// History aggregate (`docs/implementation-plan.md` §7.1).
///
/// Combines the original [CalculationRequest] with its
/// [CalculationResult] for one shot rendering on the history list.
@freezed
abstract class SavedCalculation with _$SavedCalculation {
  const factory SavedCalculation({
    required CalculationRequest request,
    required CalculationResult result,
  }) = _SavedCalculation;
}
