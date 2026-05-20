import 'package:flutter/material.dart' show TimeOfDay;

import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/match_strength.dart';

/// Canonical mock response for demo mode (`docs/mvp-scope.md` §DM2,
/// `docs/implementation-plan.md` §10.2).
///
/// Strict shape — three candidates with distinct confidence levels,
/// "Gemini Rising" on the top candidate, and six evidence items with
/// a 2-strong / 2-moderate / 1-weak / 1-no-match distribution.
const demoCandidates = <CandidateTime>[
  CandidateTime(
    rank: 1,
    time: TimeOfDay(hour: 7, minute: 14),
    confidence: 0.78,
    ascendant: 'Gemini',
  ),
  CandidateTime(
    rank: 2,
    time: TimeOfDay(hour: 7, minute: 42),
    confidence: 0.61,
    ascendant: 'Cancer',
  ),
  CandidateTime(
    rank: 3,
    time: TimeOfDay(hour: 8, minute: 3),
    confidence: 0.44,
    ascendant: 'Cancer',
  ),
];

/// Stock explanation pool keyed by [MatchStrength]. Used to fill in
/// evidence when the user submitted fewer than 6 events (trim) or
/// more than 6 (pad with weak/none).
// ignore_for_file: lines_longer_than_80_chars
// Demo explanation copy is intentionally readable as prose; wrapping
// it inside the 80-col gutter splinters the sentences and makes the
// strings harder to proof-read. Suppress the rule for this file only.
const _demoExplanations = <MatchStrength, List<String>>{
  MatchStrength.strong: <String>[
    'A timed Venus return aligned with the candidate window, consistent with a partnership event.',
    'Saturn crossed the 10th-house cusp inside the window — a classic timing signature for a career pivot.',
  ],
  MatchStrength.moderate: <String>[
    'Jupiter passed near the 4th-house cusp; moderate support for a home / relocation event in this window.',
    'A solar arc to Mars sat within tolerance of the window, plausible for the reported event but not exclusive to it.',
  ],
  MatchStrength.weak: <String>[
    'Mercury was within wide orb of the relevant cusp; insufficient to confirm timing on its own.',
  ],
  MatchStrength.none: <String>[
    'No primary aspect within tolerance of the candidate window. This event neither supports nor contradicts the result.',
  ],
};

/// Distribution per §DM2: 2 strong, 2 moderate, 1 weak, 1 no match.
const _demoStrengthOrder = <MatchStrength>[
  MatchStrength.strong,
  MatchStrength.strong,
  MatchStrength.moderate,
  MatchStrength.moderate,
  MatchStrength.weak,
  MatchStrength.none,
];

/// Build a deterministic [CalculationResult] for [req] following
/// §DM2 — three candidates, "Gemini Rising" top candidate, six
/// evidence rows.
///
/// Trim/pad rules (§10.2):
///   - User submitted fewer than 6 events → trim distribution to
///     match the submitted count.
///   - User submitted more than 6 events → keep the canonical 6
///     pattern for the first 6 and tag the rest as `weak` or `none`
///     with stock copy so every submitted event maps to one
///     evidence row.
CalculationResult buildDemoResult(
  CalculationRequest req, {
  required DateTime now,
}) {
  final evidence = <EvidenceItem>[];
  for (var i = 0; i < req.events.length; i++) {
    final event = req.events[i];
    final strength = i < _demoStrengthOrder.length
        ? _demoStrengthOrder[i]
        : (i.isEven ? MatchStrength.weak : MatchStrength.none);
    final pool = _demoExplanations[strength]!;
    final explanation = pool[i % pool.length];
    evidence.add(
      EvidenceItem(
        eventId: event.id,
        matchStrength: strength,
        explanation: explanation,
      ),
    );
  }

  return CalculationResult(
    requestId: req.id,
    candidates: demoCandidates,
    evidence: evidence,
    isDemo: true,
    completedAt: now,
    method: 'demo_canonical',
  );
}
