import 'package:flutter/material.dart' show TimeOfDay;

import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/dto/rectification_response_dto.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/models/time_window.dart';
import 'package:rectify/data/models/time_window_mode.dart';

/// Pure-function mappers between domain models and astrology-api.io v3 DTOs.
///
/// Confined to this file so a future provider schema change is a one-file diff
/// (docs/implementation-plan.md §7.2 / §9.3).

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _twoDigit(int value) => value.toString().padLeft(2, '0');

/// Parse HH:MM or HH:MM:SS — seconds are discarded.
TimeOfDay _parseTimeOfDay(String input) {
  final parts = input.split(':');
  if (parts.length < 2) {
    throw FormatException('Malformed HH:MM time: "$input"');
  }
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}

String _formatTimeOfDay(TimeOfDay t) =>
    '${_twoDigit(t.hour)}:${_twoDigit(t.minute)}';

/// Build the event date string and optional date_precision field.
///
/// Rules:
///   - year + month available → YYYY-MM, precision = "month"
///   - year only              → YYYY,    precision = "year"
(String date, String? precision) _eventDate(LifeEvent event) {
  if (event.month != null) {
    return (
      '${event.year.toString().padLeft(4, '0')}-${_twoDigit(event.month!)}',
      'month',
    );
  }
  return (event.year.toString().padLeft(4, '0'), 'year');
}

// ---------------------------------------------------------------------------
// Event category mapping: domain EventCategory → provider string
// ---------------------------------------------------------------------------
//
// Verified against the live OpenAPI spec
// (https://api.astrology-api.io/api/v3/openapi.json — EventCategory enum,
// 2026-05-20). Domain tags differ from the provider enum in 4 places —
// see inline comments. The provider also accepts six additional values
// the domain doesn't surface yet: career_promotion, surgery,
// relationship_start, relationship_end, financial_loss, spiritual.

const Map<EventCategory, String> _providerCategoryMap = {
  EventCategory.marriage: 'marriage',
  EventCategory.divorce: 'divorce',
  EventCategory.careerChange: 'career_change',
  EventCategory.jobLoss: 'job_loss',
  // 'relocation' → 'move' (provider enum differs from domain tag)
  EventCategory.relocation: 'move',
  EventCategory.childBirth: 'child_birth',
  // 'family_death' → 'death_family' (reversed word order in provider)
  EventCategory.familyDeath: 'death_family',
  // no 'illness' in provider enum; 'health_diagnosis' is nearest safe default
  EventCategory.illness: 'health_diagnosis',
  EventCategory.accident: 'accident',
  EventCategory.education: 'education',
  // no 'financial' in provider enum; 'financial_gain' is safer default
  EventCategory.financial: 'financial_gain',
  EventCategory.other: 'other',
};

String _providerCategory(EventCategory category) =>
    _providerCategoryMap[category] ?? category.tag;

// ---------------------------------------------------------------------------
// Request mapping: domain → DTO
// ---------------------------------------------------------------------------

/// Convert a domain [CalculationRequest] to the astrology-api.io v3 wire DTO.
///
/// In approximate mode the user's best-guess time is sent as
/// `subject.birth_data.hour:minute` because the provider treats that
/// value as the anchor for `time_search.delta_minutes` (±N around the
/// anchor). Sending 00:00 would have anchored the search to midnight,
/// silently discarding the user's input.
RectificationSearchRequestDto requestToDto(CalculationRequest req) {
  final birth = req.birthData;
  final (anchorHour, anchorMinute) = _birthAnchor(req.timeWindow);

  return RectificationSearchRequestDto(
    subject: SubjectDto(
      birthData: BirthDataV3Dto(
        year: birth.birthDate.year,
        month: birth.birthDate.month,
        day: birth.birthDate.day,
        hour: anchorHour,
        minute: anchorMinute,
        city: birth.birthCity.isNotEmpty ? birth.birthCity : null,
        latitude: birth.birthLatitude,
        longitude: birth.birthLongitude,
      ),
    ),
    timeSearch: _buildTimeSearch(req.timeWindow),
    events: <EventV3Dto>[
      for (final event in req.events) _eventToDto(event),
    ],
  );
}

/// Pick the anchor (hour, minute) sent in `subject.birth_data`.
///
/// Approximate mode → user's best-guess time. Unknown mode → 12:00,
/// the spec's documented default for unknown birth times — picked so
/// the anchor sits in the middle of the day-long search window and
/// has no special meaning for the provider.
(int hour, int minute) _birthAnchor(TimeWindow window) {
  if (window.mode == TimeWindowMode.approximate &&
      window.approximateTime != null) {
    return (window.approximateTime!.hour, window.approximateTime!.minute);
  }
  return (12, 0);
}

/// Candidate-grid resolution sent as `time_search.step_minutes`.
///
/// astrology-api.io v3 rejects any rectification search that resolves
/// to more than 500 candidate times. The widest window the app builds
/// is the unknown / 24h range (~1439 minutes); the largest approximate
/// window is ±360 minutes (720-minute span). A 4-minute grid caps
/// those at ~360 and ~180 candidates respectively — both well under
/// the 500 limit — and 4 is the provider's own documented default. A
/// 2-minute grid produced ~719 candidates on the 24h range, so the
/// provider rejected the request outright.
const int kRectificationStepMinutes = 4;

TimeSearchDto _buildTimeSearch(TimeWindow window) {
  if (window.mode == TimeWindowMode.approximate &&
      window.approximateTime != null &&
      window.windowMinutes != null) {
    return TimeSearchDto(
      deltaMinutes: window.windowMinutes,
      stepMinutes: kRectificationStepMinutes,
    );
  }
  // unknown / 24h mode — full-day search
  return const TimeSearchDto(
    start: '00:00',
    end: '23:59',
    stepMinutes: kRectificationStepMinutes,
  );
}

EventV3Dto _eventToDto(LifeEvent event) {
  final (date, precision) = _eventDate(event);
  return EventV3Dto(
    category: _providerCategory(event.category),
    date: date,
    datePrecision: precision,
    description: event.description,
  );
}

// ---------------------------------------------------------------------------
// Response mapping: DTO → domain
// ---------------------------------------------------------------------------

/// Convert an inbound provider response to a domain [CalculationResult].
///
/// [rawResponseJson] is the verbatim payload for support reproductions (§7.1).
/// [completedAt] is injected by the caller so tests stay deterministic.
/// [requestEvents] is the ordered list submitted in the request — used
/// to translate `event_scores[].event_index` back into the user's
/// `LifeEvent.id` for the domain `EvidenceItem.eventId`.
CalculationResult responseToResult({
  required String requestId,
  required RectificationSearchResponseDto dto,
  required DateTime completedAt,
  String? rawResponseJson,
  bool isDemo = false,
  List<LifeEvent> requestEvents = const <LifeEvent>[],
}) {
  final primary = _primaryCandidate(dto.candidates);
  // CalculationResult.apiCalculationId stays null — v3's response has
  // no calculation_id field. We carry the rawResponseJson for support
  // reproductions instead.
  return CalculationResult(
    requestId: requestId,
    method: _methodLabel(dto.summary),
    candidates: <CandidateTime>[
      for (final c in dto.candidates) _candidateFromDto(c),
    ],
    evidence: primary == null
        ? const <EvidenceItem>[]
        : <EvidenceItem>[
            for (final s in primary.eventScores)
              _evidenceFromScore(s, requestEvents, primary),
          ],
    isDemo: isDemo,
    completedAt: completedAt,
    rawResponseJson: rawResponseJson,
  );
}

/// Pick the candidate whose `event_scores` populate the domain's flat
/// `evidence` list. Prefers the rank-1 candidate that isn't excluded or
/// errored; falls back to the first listed candidate, then null.
CandidateV3Dto? _primaryCandidate(List<CandidateV3Dto> candidates) {
  if (candidates.isEmpty) return null;
  for (final c in candidates) {
    if (c.rank == 1 && !c.excluded && c.error == null) return c;
  }
  return candidates.first;
}

/// Build a human-readable `method` label from the techniques the
/// provider applied; used only for display, the underlying data is in
/// `rawResponseJson` if support needs more.
String? _methodLabel(SummaryV3Dto? summary) {
  if (summary == null || summary.techniquesUsed.isEmpty) return null;
  return summary.techniquesUsed.join('+');
}

CandidateTime _candidateFromDto(CandidateV3Dto dto) {
  final clamped = dto.normalizedScore.clamp(0.0, 100.0);
  return CandidateTime(
    rank: dto.rank,
    time: _parseTimeOfDay(dto.time),
    confidence: clamped / 100.0,
    ascendant: _ascendantFromChart(dto.chart),
  );
}

EvidenceItem _evidenceFromScore(
  EventScoreDto score,
  List<LifeEvent> events,
  CandidateV3Dto candidate,
) {
  final eventId = (score.eventIndex >= 0 && score.eventIndex < events.length)
      ? events[score.eventIndex].id
      : 'event_${score.eventIndex}';
  return EvidenceItem(
    eventId: eventId,
    matchStrength: _strengthFromScore(score, candidate),
    explanation: score.interpretation ?? _fallbackExplanation(score),
  );
}

String _fallbackExplanation(EventScoreDto score) {
  return 'Score ${score.totalScore.toStringAsFixed(1)} '
      'for ${score.eventCategory} event on ${score.eventDate}.';
}

/// Map a candidate's per-event score into the four-bucket domain enum.
///
/// The provider doesn't return a categorical strength — the only public
/// signal is `EventScore.total_score` (raw points, scale depends on the
/// category's theoretical max). The bucket thresholds are heuristic:
/// the candidate's local maximum is the reference, and the ratio
/// against that max drives the strong/moderate/weak boundaries. This
/// roughly tracks the provider's own `events_strongly_correlated`
/// counter (defined as score ≥ 70% of the theoretical max).
MatchStrength _strengthFromScore(
  EventScoreDto score,
  CandidateV3Dto candidate,
) {
  if (score.totalScore <= 0) return MatchStrength.none;
  var localMax = 0.0;
  for (final s in candidate.eventScores) {
    if (s.totalScore > localMax) localMax = s.totalScore;
  }
  if (localMax <= 0) return MatchStrength.none;
  final ratio = score.totalScore / localMax;
  if (ratio >= 0.7) return MatchStrength.strong;
  if (ratio >= 0.4) return MatchStrength.moderate;
  return MatchStrength.weak;
}

// ---------------------------------------------------------------------------
// Ascendant extraction from the embedded chart payload
// ---------------------------------------------------------------------------

const Map<String, String> _zodiacAbbreviations = <String, String>{
  'Ari': 'Aries',
  'Tau': 'Taurus',
  'Gem': 'Gemini',
  'Can': 'Cancer',
  'Leo': 'Leo',
  'Vir': 'Virgo',
  'Lib': 'Libra',
  'Sco': 'Scorpio',
  'Sag': 'Sagittarius',
  'Cap': 'Capricorn',
  'Aqu': 'Aquarius',
  'Pis': 'Pisces',
};

/// Extract the candidate's Ascendant sign as a full word (e.g. "Gemini").
///
/// The provider returns the Ascendant in two places: the
/// `planetary_positions` array (entry where `name == "Ascendant"`) and
/// the first house cusp (`house_cusps[house==1]`). We prefer the
/// planetary positions because they include the exact degree if a
/// future caller needs it; the house-cusp lookup is a fallback for
/// chart types where the Ascendant isn't surfaced as a body. Returns
/// null when the chart payload is absent or neither source is parseable.
String? _ascendantFromChart(Map<String, dynamic>? chart) {
  if (chart == null) return null;
  final positions = chart['planetary_positions'];
  if (positions is List) {
    for (final entry in positions) {
      if (entry is Map && entry['name'] == 'Ascendant') {
        final sign = entry['sign'];
        if (sign is String && sign.isNotEmpty) {
          return _zodiacAbbreviations[sign] ?? sign;
        }
      }
    }
  }
  final houses = chart['house_cusps'];
  if (houses is List) {
    for (final entry in houses) {
      if (entry is Map && entry['house'] == 1) {
        final sign = entry['sign'];
        if (sign is String && sign.isNotEmpty) {
          return _zodiacAbbreviations[sign] ?? sign;
        }
      }
    }
  }
  return null;
}

// ---------------------------------------------------------------------------
// Public single-object helpers (used by tests and ad-hoc callers)
// ---------------------------------------------------------------------------

/// Convert a single domain [LifeEvent] to its DTO.
EventV3Dto lifeEventToDto(LifeEvent event) => _eventToDto(event);

/// Convert a single inbound candidate DTO to a domain [CandidateTime].
CandidateTime candidateFromDto(CandidateV3Dto dto) => _candidateFromDto(dto);

/// Render a [TimeOfDay] as HH:MM string.
String formatTimeOfDay(TimeOfDay time) => _formatTimeOfDay(time);
