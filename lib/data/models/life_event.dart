import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/event_category.dart';

part 'life_event.freezed.dart';

/// One life event the user submits alongside their birth data
/// (`docs/implementation-plan.md` §7.1).
@freezed
abstract class LifeEvent with _$LifeEvent {
  const factory LifeEvent({
    required String id,
    required EventCategory category,
    required int year,
    required int sortOrder,
    int? month,
    String? description,
  }) = _LifeEvent;
}
