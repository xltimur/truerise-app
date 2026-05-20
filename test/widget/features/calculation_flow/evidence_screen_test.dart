import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/models/time_window.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/evidence_screen.dart';
import 'package:rectify/features/calculation_flow/screens/result_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/cards/evidence_card.dart';
import 'package:rectify/widgets/result/match_strength_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': true,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _harness({
  required SharedPreferences prefs,
  required FakeHistoryRepository history,
  required FakeRectificationRepository rectifier,
  required InMemoryDraftRepository drafts,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    rectificationRepositoryProvider.overrideWithValue(rectifier),
    draftRepositoryProvider.overrideWithValue(drafts),
  ],
  child: const RectifyApp(),
);

SavedCalculation _seedDemoCalculation({String id = 'demo-evidence-1'}) {
  final request = CalculationRequest(
    id: id,
    isDemo: true,
    birthData: BirthData(
      birthDate: DateTime.utc(1990, 5, 14),
      birthCity: 'Kyiv, Ukraine',
      birthLatitude: 0,
      birthLongitude: 0,
    ),
    timeWindow: TimeWindow.approximate(
      time: const TimeOfDay(hour: 7, minute: 0),
      windowMinutes: 120,
    ),
    events: <LifeEvent>[
      const LifeEvent(
        id: 'evt-1',
        category: EventCategory.marriage,
        year: 2018,
        month: 6,
        sortOrder: 0,
      ),
      const LifeEvent(
        id: 'evt-2',
        category: EventCategory.careerChange,
        year: 2015,
        month: 9,
        sortOrder: 1,
      ),
      const LifeEvent(
        id: 'evt-3',
        category: EventCategory.relocation,
        year: 2012,
        month: 3,
        sortOrder: 2,
      ),
    ],
    createdAt: DateTime.utc(2026, 5, 20, 12),
    label: 'Demo result',
  );
  final result = buildDemoResult(request, now: DateTime.utc(2026, 5, 20, 12));
  return SavedCalculation(request: request, result: result);
}

void main() {
  testWidgets(
    'renders summary line, one card per submitted event, and the '
    'match-strength dots + explanation',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      container
          .read(routerProvider)
          .go(
            RoutePaths.calcEvidenceFor(seeded.request.id),
          );
      await tester.pumpAndSettle();

      expect(find.byType(EvidenceScreen), findsOneWidget);
      // Summary line wired to the top demo candidate (7:14 AM).
      expect(find.byKey(evidenceSummaryKey), findsOneWidget);
      expect(find.textContaining('Why 7:14 AM'), findsOneWidget);

      // One evidence card per submitted event (demo seed: 3 events).
      expect(find.byType(EvidenceCard), findsNWidgets(3));

      // The demo seed produces 2 strong / 1 moderate matches for the
      // first three events (`lib/data/demo/demo_response.dart` §DM2);
      // both strong cards are expanded by default and render their
      // explanation text plus the STRONG / MODERATE labels.
      expect(find.byType(MatchStrengthDots), findsNWidgets(3));
      expect(find.text('STRONG'), findsNWidgets(2));
      expect(find.text('MODERATE'), findsOneWidget);
    },
  );

  testWidgets(
    'evidence screen back arrow returns to the result screen',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      // Walk the same path a user would: home → result → evidence.
      container
          .read(routerProvider)
          .go(
            RoutePaths.calcResultFor(seeded.request.id),
          );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(resultEvidenceButtonKey));
      await tester.tap(find.byKey(resultEvidenceButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(EvidenceScreen), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      final location = container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .toString();
      expect(location, '/calc/result/${seeded.request.id}');
      expect(find.byType(ResultScreen), findsOneWidget);
    },
  );

  testWidgets(
    "shows a not-found state when the result id can't be resolved",
    (tester) async {
      final prefs = await _prefs();
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      container
          .read(routerProvider)
          .go(
            RoutePaths.calcEvidenceFor('unknown-id'),
          );
      await tester.pumpAndSettle();

      expect(find.byType(EvidenceScreen), findsOneWidget);
      expect(
        find.text("We couldn't find that evidence."),
        findsOneWidget,
      );
    },
  );
}
