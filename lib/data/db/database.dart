import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:rectify/data/db/tables.dart';

part 'database.g.dart';

/// Drift database for the rectification storage layer
/// (`docs/implementation-plan.md` §8).
///
/// All long-form CRUD is funnelled through the DAOs below so the
/// repositories can stay shaped around domain models instead of
/// raw [Insertable] rows.
@DriftDatabase(
  tables: <Type>[
    Calculations,
    LifeEventRows,
    CandidateResults,
    EvidenceRows,
  ],
  daos: <Type>[
    CalculationsDao,
    LifeEventsDao,
    CandidateResultsDao,
    EvidenceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'rectify'));

  /// Injection point for tests. Pass an in-memory executor.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Enable FK enforcement so cascade deletes fire.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// CRUD for the [Calculations] table.
@DriftAccessor(tables: <Type>[Calculations])
class CalculationsDao extends DatabaseAccessor<AppDatabase>
    with _$CalculationsDaoMixin {
  CalculationsDao(super.attachedDatabase);

  Future<int> insertOrReplace(CalculationsCompanion row) =>
      into(calculations).insertOnConflictUpdate(row);

  Future<CalculationEntity?> findById(String id) =>
      (select(calculations)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<CalculationEntity>> all() =>
      (select(calculations)..orderBy(<OrderClauseGenerator<Calculations>>[
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
          .get();

  /// Reactive history feed used by the Home screen
  /// (`docs/implementation-plan.md` §8.4).
  Stream<List<CalculationEntity>> watchAll() =>
      (select(calculations)..orderBy(<OrderClauseGenerator<Calculations>>[
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
          .watch();

  Future<int> deleteById(String id) =>
      (delete(calculations)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAll() async {
    await delete(calculations).go();
  }
}

/// CRUD for the [LifeEventRows] table.
@DriftAccessor(tables: <Type>[LifeEventRows])
class LifeEventsDao extends DatabaseAccessor<AppDatabase>
    with _$LifeEventsDaoMixin {
  LifeEventsDao(super.attachedDatabase);

  Future<void> insertAll(List<LifeEventRowsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(lifeEventRows, rows));
  }

  Future<List<LifeEventEntity>> forCalculation(String calculationId) =>
      (select(lifeEventRows)
            ..where((t) => t.calculationId.equals(calculationId))
            ..orderBy(<OrderClauseGenerator<LifeEventRows>>[
              (t) => OrderingTerm.asc(t.sortOrder),
            ]))
          .get();
}

/// CRUD for the [CandidateResults] table.
@DriftAccessor(tables: <Type>[CandidateResults])
class CandidateResultsDao extends DatabaseAccessor<AppDatabase>
    with _$CandidateResultsDaoMixin {
  CandidateResultsDao(super.attachedDatabase);

  Future<void> insertAll(List<CandidateResultsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(candidateResults, rows));
  }

  Future<List<CandidateResultEntity>> forCalculation(String calculationId) =>
      (select(candidateResults)
            ..where((t) => t.calculationId.equals(calculationId))
            ..orderBy(<OrderClauseGenerator<CandidateResults>>[
              (t) => OrderingTerm.asc(t.rank),
            ]))
          .get();
}

/// CRUD for the [EvidenceRows] table.
@DriftAccessor(tables: <Type>[EvidenceRows])
class EvidenceDao extends DatabaseAccessor<AppDatabase>
    with _$EvidenceDaoMixin {
  EvidenceDao(super.attachedDatabase);

  Future<void> insertAll(List<EvidenceRowsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(evidenceRows, rows));
  }

  Future<List<EvidenceEntity>> forCalculation(String calculationId) => (select(
    evidenceRows,
  )..where((t) => t.calculationId.equals(calculationId))).get();
}
