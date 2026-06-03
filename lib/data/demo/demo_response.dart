import 'package:flutter/material.dart' show TimeOfDay;

import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/l10n/l10n.dart';

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

/// Locale-resolved demo evidence prose.
///
/// `buildDemoResult` runs in the data layer where there is no
/// `BuildContext`, but the explanations it emits are user-visible and
/// must be localizable. The loading screen resolves the strings from
/// [AppLocalizations] and threads this value object down, so the demo
/// path stays offline and free of UI dependencies.
class DemoEvidenceCopy {
  const DemoEvidenceCopy({
    required this.strongVenus,
    required this.strongSaturn,
    required this.moderateJupiter,
    required this.moderateSolarArc,
    required this.weakMercury,
    required this.noMatch,
  });

  DemoEvidenceCopy.fromL10n(AppLocalizations l10n)
    : strongVenus = l10n.demoEvidenceStrongVenus,
      strongSaturn = l10n.demoEvidenceStrongSaturn,
      moderateJupiter = l10n.demoEvidenceModerateJupiter,
      moderateSolarArc = l10n.demoEvidenceModerateSolarArc,
      weakMercury = l10n.demoEvidenceWeakMercury,
      noMatch = l10n.demoEvidenceNoMatch;

  final String strongVenus;
  final String strongSaturn;
  final String moderateJupiter;
  final String moderateSolarArc;
  final String weakMercury;
  final String noMatch;
}

/// Stock explanation pool keyed by [MatchStrength]. Used to fill in
/// evidence when the user submitted fewer than 6 events (trim) or
/// more than 6 (pad with weak/none).
Map<MatchStrength, List<String>> _poolsFor(DemoEvidenceCopy copy) {
  return <MatchStrength, List<String>>{
    MatchStrength.strong: <String>[copy.strongVenus, copy.strongSaturn],
    MatchStrength.moderate: <String>[
      copy.moderateJupiter,
      copy.moderateSolarArc,
    ],
    MatchStrength.weak: <String>[copy.weakMercury],
    MatchStrength.none: <String>[copy.noMatch],
  };
}

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
  required DemoEvidenceCopy copy,
}) {
  final pools = _poolsFor(copy);
  final evidence = <EvidenceItem>[];
  for (var i = 0; i < req.events.length; i++) {
    final event = req.events[i];
    final strength = i < _demoStrengthOrder.length
        ? _demoStrengthOrder[i]
        : (i.isEven ? MatchStrength.weak : MatchStrength.none);
    final pool = pools[strength]!;
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
