import 'package:flutter/material.dart' show TimeOfDay;

import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/models/time_window.dart';
import 'package:rectify/data/models/time_window_mode.dart';

/// Deterministic [CalculationRequest] used by repository / mapper /
/// demo-response tests. The same instance ships across every test
/// suite so a change to the fixture surfaces as a single batch diff.
CalculationRequest sampleRequest({
  String id = 'req-001',
  bool isDemo = false,
  int eventCount = 5,
}) {
  final events = const <LifeEvent>[
    LifeEvent(
      id: 'evt-1',
      category: EventCategory.marriage,
      year: 2014,
      month: 6,
      sortOrder: 0,
    ),
    LifeEvent(
      id: 'evt-2',
      category: EventCategory.careerChange,
      year: 2019,
      month: 9,
      sortOrder: 1,
    ),
    LifeEvent(
      id: 'evt-3',
      category: EventCategory.relocation,
      year: 2021,
      sortOrder: 2,
    ),
    LifeEvent(
      id: 'evt-4',
      category: EventCategory.education,
      year: 2009,
      month: 5,
      description: 'University graduation',
      sortOrder: 3,
    ),
    LifeEvent(
      id: 'evt-5',
      category: EventCategory.childBirth,
      year: 2017,
      month: 1,
      sortOrder: 4,
    ),
    LifeEvent(
      id: 'evt-6',
      category: EventCategory.financial,
      year: 2022,
      month: 11,
      sortOrder: 5,
    ),
  ].take(eventCount).toList();

  return CalculationRequest(
    id: id,
    isDemo: isDemo,
    birthData: BirthData(
      birthDate: DateTime.utc(1990, 5, 14),
      birthCity: 'Kyiv, Ukraine',
      birthLatitude: 50.4501,
      birthLongitude: 30.5234,
    ),
    timeWindow: const TimeWindow(
      mode: TimeWindowMode.approximate,
      approximateTime: TimeOfDay(hour: 7, minute: 14),
      windowMinutes: 60,
    ),
    events: events,
    createdAt: DateTime.utc(2026, 5, 20, 11),
    label: 'Sample calculation',
  );
}

/// Deterministic [CalculationResult] paired with [sampleRequest] for
/// history / read-path tests. Two candidates, two evidence items,
/// flagged as demo so the DEMO pill is exercised.
CalculationResult sampleResult({
  String requestId = 'req-001',
  bool isDemo = true,
}) {
  return CalculationResult(
    requestId: requestId,
    candidates: const <CandidateTime>[
      CandidateTime(
        rank: 1,
        time: TimeOfDay(hour: 7, minute: 14),
        confidence: 0.78,
        ascendant: 'Gemini',
      ),
      CandidateTime(
        rank: 2,
        time: TimeOfDay(hour: 7, minute: 32),
        confidence: 0.61,
        ascendant: 'Gemini',
      ),
    ],
    evidence: const <EvidenceItem>[
      EvidenceItem(
        eventId: 'evt-1',
        matchStrength: MatchStrength.strong,
        explanation: 'Marriage timing aligns with the 7th-house transit.',
      ),
      EvidenceItem(
        eventId: 'evt-2',
        matchStrength: MatchStrength.moderate,
        explanation: 'Career change matches the 10th-house cusp.',
      ),
    ],
    isDemo: isDemo,
    completedAt: DateTime.utc(2026, 5, 15, 12),
  );
}
