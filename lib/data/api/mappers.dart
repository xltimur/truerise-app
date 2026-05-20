import 'package:flutter/material.dart' show TimeOfDay;

import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/dto/rectification_response_dto.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/models/time_window.dart';

/// Pure-function mappers between domain models and provider DTOs.
///
/// Confined to this file so a future provider schema change (Phase 6)
/// is a one-file diff (`docs/implementation-plan.md` §7.2 / §9.3).

String _twoDigit(int value) => value.toString().padLeft(2, '0');

String _isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${_twoDigit(date.month)}-'
    '${_twoDigit(date.day)}';

String _timeOfDay(TimeOfDay t) => '${_twoDigit(t.hour)}:${_twoDigit(t.minute)}';

TimeOfDay _parseTimeOfDay(String input) {
  final parts = input.split(':');
  if (parts.length < 2) {
    throw FormatException('Malformed HH:MM time: "$input"');
  }
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

/// Convert a domain [CalculationRequest] to the outbound provider DTO.
RectificationRequestDto requestToDto(CalculationRequest req) {
  return RectificationRequestDto(
    requestId: req.id,
    birthDate: _isoDate(req.birthData.birthDate),
    birthPlace: BirthPlaceDto(
      city: req.birthData.birthCity,
      latitude: req.birthData.birthLatitude,
      longitude: req.birthData.birthLongitude,
    ),
    timeWindow: TimeWindowDto(
      mode: req.timeWindow.mode.tag,
      approximateTime: req.timeWindow.approximateTime == null
          ? null
          : _timeOfDay(req.timeWindow.approximateTime!),
      windowMinutes: req.timeWindow.windowMinutes,
    ),
    lifeEvents: <LifeEventDto>[
      for (final event in req.events)
        LifeEventDto(
          id: event.id,
          category: event.category.tag,
          year: event.year,
          month: event.month,
          description: event.description,
        ),
    ],
  );
}

/// Convert an inbound provider response to a domain [CalculationResult].
///
/// [rawResponseJson] is the verbatim payload to persist for support
/// reproductions (see §7.1 `rawResponseJson`). [completedAt] is
/// injected by the caller so tests stay deterministic.
CalculationResult responseToResult({
  required String requestId,
  required RectificationResponseDto dto,
  required DateTime completedAt,
  String? rawResponseJson,
  bool isDemo = false,
}) {
  return CalculationResult(
    requestId: requestId,
    apiCalculationId: dto.calculationId,
    method: dto.method,
    candidates: <CandidateTime>[
      for (final candidate in dto.candidates)
        CandidateTime(
          rank: candidate.rank,
          time: _parseTimeOfDay(candidate.time),
          confidence: candidate.confidence,
          ascendant: candidate.ascendant,
        ),
    ],
    evidence: <EvidenceItem>[
      for (final match in dto.evidence)
        EvidenceItem(
          eventId: match.eventId,
          matchStrength: MatchStrength.fromTag(match.matchStrength),
          explanation: match.explanation,
        ),
    ],
    isDemo: isDemo,
    completedAt: completedAt,
    rawResponseJson: rawResponseJson,
  );
}

/// Convert a single domain [LifeEvent] to its DTO. Exposed for tests
/// and future ad-hoc use; the request mapper already inlines it.
LifeEventDto lifeEventToDto(LifeEvent event) => LifeEventDto(
  id: event.id,
  category: event.category.tag,
  year: event.year,
  month: event.month,
  description: event.description,
);

/// Convert a single inbound candidate DTO to a domain [CandidateTime].
CandidateTime candidateFromDto(RectificationCandidateDto dto) => CandidateTime(
  rank: dto.rank,
  time: _parseTimeOfDay(dto.time),
  confidence: dto.confidence,
  ascendant: dto.ascendant,
);

/// Convert a single evidence DTO into a domain [EvidenceItem].
EvidenceItem evidenceFromDto(RectificationEventMatchDto dto) => EvidenceItem(
  eventId: dto.eventId,
  matchStrength: MatchStrength.fromTag(dto.matchStrength),
  explanation: dto.explanation,
);

/// Convert the freshly-built [TimeWindow] domain object back into a
/// human-readable HH:MM string for tests / inspections.
String formatTimeOfDay(TimeOfDay time) => _timeOfDay(time);
