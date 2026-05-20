import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart' show TimeOfDay;

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/calculation_status.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/models/time_window.dart';
import 'package:rectify/data/models/time_window_mode.dart';

/// Repository contract for the calculation history aggregate
/// (`docs/implementation-plan.md` §8.2 / §8.4).
///
/// Read paths return reactive [Stream]s so the Home / History screen
/// can re-render on swipe-delete or new-result without manual
/// invalidation.
abstract class HistoryRepository {
  Future<Result<void, AppFailure>> save(
    CalculationRequest request,
    CalculationResult result,
  );

  Future<Result<SavedCalculation, AppFailure>> findById(String calculationId);

  Stream<List<SavedCalculation>> watchAll();

  Future<Result<void, AppFailure>> deleteById(String calculationId);

  Future<Result<void, AppFailure>> deleteAll();
}

/// Drift-backed implementation.
///
/// Aggregates are written transactionally: one Calculations row, then
/// LifeEvents / CandidateResults / Evidence inserts. Deletes rely on
/// FK cascade declared in `tables.dart`.
class DriftHistoryRepository implements HistoryRepository {
  DriftHistoryRepository(this._db);

  final AppDatabase _db;

  String _hhmm(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  TimeOfDay _parseHhmm(String input) {
    final parts = input.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  Future<Result<void, AppFailure>> save(
    CalculationRequest request,
    CalculationResult result,
  ) async {
    try {
      await _db.transaction(() async {
        final now = DateTime.now();
        await _db.calculationsDao.insertOrReplace(
          CalculationsCompanion(
            id: Value(request.id),
            label: Value(request.label),
            status: Value(CalculationStatus.complete.tag),
            isDemo: Value(result.isDemo),
            birthDate: Value(request.birthData.birthDate),
            birthCity: Value(request.birthData.birthCity),
            birthLatitude: Value(request.birthData.birthLatitude),
            birthLongitude: Value(request.birthData.birthLongitude),
            timeWindowMode: Value(request.timeWindow.mode.tag),
            approximateTime: Value(
              request.timeWindow.approximateTime == null
                  ? null
                  : _hhmm(request.timeWindow.approximateTime!),
            ),
            windowMinutes: Value(request.timeWindow.windowMinutes),
            apiCalcId: Value(result.apiCalculationId),
            rawResponse: Value(result.rawResponseJson),
            method: Value(result.method),
            createdAt: Value(request.createdAt),
            updatedAt: Value(now),
          ),
        );

        await _db.lifeEventsDao.insertAll(<LifeEventRowsCompanion>[
          for (final event in request.events)
            LifeEventRowsCompanion(
              id: Value(event.id),
              calculationId: Value(request.id),
              category: Value(event.category.tag),
              year: Value(event.year),
              month: Value(event.month),
              description: Value(event.description),
              sortOrder: Value(event.sortOrder),
            ),
        ]);

        await _db.candidateResultsDao.insertAll(<CandidateResultsCompanion>[
          for (final candidate in result.candidates)
            CandidateResultsCompanion(
              id: Value('${request.id}-c${candidate.rank}'),
              calculationId: Value(request.id),
              rank: Value(candidate.rank),
              birthTime: Value(_hhmm(candidate.time)),
              confidence: Value(candidate.confidence),
              ascendant: Value(candidate.ascendant),
            ),
        ]);

        await _db.evidenceDao.insertAll(<EvidenceRowsCompanion>[
          for (var i = 0; i < result.evidence.length; i++)
            EvidenceRowsCompanion(
              id: Value('${request.id}-e$i'),
              calculationId: Value(request.id),
              lifeEventId: Value(result.evidence[i].eventId),
              matchStrength: Value(result.evidence[i].matchStrength.tag),
              explanation: Value(result.evidence[i].explanation),
            ),
        ]);
      });
      return const Result<void, AppFailure>.ok(null);
    } on Object catch (cause) {
      return Result.err(StorageFailure(cause));
    }
  }

  Future<SavedCalculation> _hydrate(CalculationEntity calc) async {
    final events = await _db.lifeEventsDao.forCalculation(calc.id);
    final candidates = await _db.candidateResultsDao.forCalculation(calc.id);
    final evidence = await _db.evidenceDao.forCalculation(calc.id);

    final domainEvents = <LifeEvent>[
      for (final row in events)
        LifeEvent(
          id: row.id,
          category: EventCategory.fromTag(row.category),
          year: row.year,
          month: row.month,
          description: row.description,
          sortOrder: row.sortOrder,
        ),
    ];

    final domainCandidates = <CandidateTime>[
      for (final row in candidates)
        CandidateTime(
          rank: row.rank,
          time: _parseHhmm(row.birthTime),
          confidence: row.confidence,
          ascendant: row.ascendant,
        ),
    ];

    final domainEvidence = <EvidenceItem>[
      for (final row in evidence)
        EvidenceItem(
          eventId: row.lifeEventId,
          matchStrength: MatchStrength.fromTag(row.matchStrength),
          explanation: row.explanation,
        ),
    ];

    final timeWindow = TimeWindow(
      mode: TimeWindowMode.fromTag(calc.timeWindowMode),
      approximateTime: calc.approximateTime == null
          ? null
          : _parseHhmm(calc.approximateTime!),
      windowMinutes: calc.windowMinutes,
    );

    final request = CalculationRequest(
      id: calc.id,
      isDemo: calc.isDemo,
      birthData: BirthData(
        birthDate: calc.birthDate,
        birthCity: calc.birthCity,
        birthLatitude: calc.birthLatitude,
        birthLongitude: calc.birthLongitude,
      ),
      timeWindow: timeWindow,
      events: domainEvents,
      createdAt: calc.createdAt,
      label: calc.label,
    );

    final result = CalculationResult(
      requestId: calc.id,
      candidates: domainCandidates,
      evidence: domainEvidence,
      isDemo: calc.isDemo,
      completedAt: calc.updatedAt,
      apiCalculationId: calc.apiCalcId,
      method: calc.method,
      rawResponseJson: calc.rawResponse,
    );

    return SavedCalculation(request: request, result: result);
  }

  @override
  Future<Result<SavedCalculation, AppFailure>> findById(
    String calculationId,
  ) async {
    try {
      final calc = await _db.calculationsDao.findById(calculationId);
      if (calc == null) {
        return Result.err(
          StorageFailure(
            StateError('Calculation $calculationId not found'),
          ),
        );
      }
      return Result.ok(await _hydrate(calc));
    } on Object catch (cause) {
      return Result.err(StorageFailure(cause));
    }
  }

  @override
  Stream<List<SavedCalculation>> watchAll() {
    return _db.calculationsDao.watchAll().asyncMap((rows) async {
      final hydrated = <SavedCalculation>[];
      for (final row in rows) {
        hydrated.add(await _hydrate(row));
      }
      return hydrated;
    });
  }

  @override
  Future<Result<void, AppFailure>> deleteById(String calculationId) async {
    try {
      await _db.calculationsDao.deleteById(calculationId);
      return const Result<void, AppFailure>.ok(null);
    } on Object catch (cause) {
      return Result.err(StorageFailure(cause));
    }
  }

  @override
  Future<Result<void, AppFailure>> deleteAll() async {
    try {
      await _db.calculationsDao.deleteAll();
      return const Result<void, AppFailure>.ok(null);
    } on Object catch (cause) {
      return Result.err(StorageFailure(cause));
    }
  }
}
