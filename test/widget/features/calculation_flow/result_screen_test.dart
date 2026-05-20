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
import 'package:rectify/features/calculation_flow/screens/result_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/cards/candidate_card.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:rectify/widgets/result/hero_result_card.dart';
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

SavedCalculation _seedDemoCalculation({
  String id = 'demo-saved-1',
  String label = 'Demo result',
}) {
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
    label: label,
  );
  final result = buildDemoResult(request, now: DateTime.utc(2026, 5, 20, 12));
  return SavedCalculation(request: request, result: result);
}

void main() {
  testWidgets(
    'renders hero time, confidence, DEMO pill, secondary candidates, '
    'and the evidence + save CTAs for a demo result',
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
            RoutePaths.calcResultFor(seeded.request.id),
          );
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      // Hero card shows the top demo candidate (7:14 AM, Gemini Rising,
      // 78% — `lib/data/demo/demo_response.dart`). The time + meridiem
      // render as a single `Text.rich`, so we inspect the keyed
      // hero-time widget's plain text rather than chasing find.text.
      final heroTime = tester.widget<Text>(find.byKey(heroTimeKey));
      expect(heroTime.textSpan?.toPlainText(), contains('7:14'));
      expect(heroTime.textSpan?.toPlainText(), contains('AM'));
      expect(find.text('Gemini Rising'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);

      // DEMO pill rendered for a demo result.
      expect(find.byType(DemoPill), findsOneWidget);

      // Up to 2 secondary candidate cards.
      expect(find.byType(CandidateCard), findsNWidgets(2));

      // CTA pair present.
      expect(find.text('See how we got this'), findsOneWidget);
      expect(find.text('Save to history'), findsOneWidget);

      // Demo upgrade nudge appears at the bottom of demo results.
      expect(find.byKey(resultDemoNudgeKey), findsOneWidget);
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
            RoutePaths.calcResultFor('unknown-id'),
          );
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text("We couldn't find that result."), findsOneWidget);
      expect(find.text('Back to history'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping a history card opens the result screen for that calculation',
    (tester) async {
      final seeded = _seedDemoCalculation(label: 'My demo calc');
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

      // Home / History list shows the saved row; tap it.
      expect(find.text('My demo calc'), findsOneWidget);
      await tester.tap(find.text('My demo calc'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
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
    'tapping "See how we got this" navigates to the evidence screen',
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
            RoutePaths.calcResultFor(seeded.request.id),
          );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(resultEvidenceButtonKey));
      await tester.tap(find.byKey(resultEvidenceButtonKey));
      await tester.pumpAndSettle();

      final location = container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .toString();
      expect(
        location,
        '/calc/result/${seeded.request.id}/evidence',
      );
    },
  );

  testWidgets(
    'no real API call fires when the demo result lands on the result screen',
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
            RoutePaths.calcResultFor(seeded.request.id),
          );
      await tester.pumpAndSettle();

      // The result screen is a pure read path; it must not retrigger
      // any submission against the rectification API. Phase 6 will
      // wire the real path — this guard catches regressions early.
      expect(rectifier.submissions, isEmpty);
    },
  );
}
