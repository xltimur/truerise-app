import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/evidence_item.dart';

part 'calculation_result.freezed.dart';

/// Final result of one rectification submission
/// (`docs/implementation-plan.md` §7.1).
///
/// `rawResponseJson` carries the verbatim provider payload so support
/// can reconstruct edge cases without re-running the calculation.
@freezed
abstract class CalculationResult with _$CalculationResult {
  const factory CalculationResult({
    required String requestId,
    required List<CandidateTime> candidates,
    required List<EvidenceItem> evidence,
    required bool isDemo,
    required DateTime completedAt,
    String? apiCalculationId,
    String? method,
    String? rawResponseJson,
  }) = _CalculationResult;
}
