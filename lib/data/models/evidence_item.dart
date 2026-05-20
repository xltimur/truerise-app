import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/match_strength.dart';

part 'evidence_item.freezed.dart';

/// One row of evidence keyed to a submitted `LifeEvent`
/// (`docs/implementation-plan.md` §7.1).
@freezed
abstract class EvidenceItem with _$EvidenceItem {
  const factory EvidenceItem({
    required String eventId,
    required MatchStrength matchStrength,
    required String explanation,
  }) = _EvidenceItem;
}
