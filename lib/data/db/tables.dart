import 'package:drift/drift.dart';

/// Drift schema for the rectification storage layer
/// (`docs/implementation-plan.md` §7.3 / §8.2).
///
/// String columns hold tags from the domain enums (`EventCategory.tag`,
/// `MatchStrength.tag`, `CalculationStatus.tag`, `TimeWindowMode.tag`).
/// Conversion is done by the repository — it keeps the schema simple
/// and gives the type system a single chokepoint.

/// One row per rectification (draft, submitted, complete, error).
@DataClassName('CalculationEntity')
class Calculations extends Table {
  TextColumn get id => text()();
  TextColumn get label => text().nullable()();
  TextColumn get status => text()();
  BoolColumn get isDemo => boolean()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn get birthCity => text()();
  RealColumn get birthLatitude => real()();
  RealColumn get birthLongitude => real()();
  TextColumn get timeWindowMode => text()();
  TextColumn get approximateTime => text().nullable()();
  IntColumn get windowMinutes => integer().nullable()();
  TextColumn get apiCalcId => text().nullable()();
  TextColumn get rawResponse => text().nullable()();
  TextColumn get method => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Submitted life events, FK to [Calculations.id]. Cascade delete.
@DataClassName('LifeEventEntity')
class LifeEventRows extends Table {
  TextColumn get id => text()();
  TextColumn get calculationId =>
      text().references(Calculations, #id, onDelete: KeyAction.cascade)();
  TextColumn get category => text()();
  IntColumn get year => integer()();
  IntColumn get month => integer().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Provider candidate rows (up to 3 per result). Cascade delete.
@DataClassName('CandidateResultEntity')
class CandidateResults extends Table {
  TextColumn get id => text()();
  TextColumn get calculationId =>
      text().references(Calculations, #id, onDelete: KeyAction.cascade)();
  IntColumn get rank => integer()();
  TextColumn get birthTime => text()();
  RealColumn get confidence => real()();
  TextColumn get ascendant => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Per-event evidence rows. Cascade delete via both calc and event.
@DataClassName('EvidenceEntity')
class EvidenceRows extends Table {
  TextColumn get id => text()();
  TextColumn get calculationId =>
      text().references(Calculations, #id, onDelete: KeyAction.cascade)();
  TextColumn get lifeEventId =>
      text().references(LifeEventRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get matchStrength => text()();
  TextColumn get explanation => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
