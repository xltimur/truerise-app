import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/models/time_window.dart';
import 'package:rectify/data/prefs/result_feedback_store.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/result_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/cards/candidate_card.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:rectify/widgets/result/hero_result_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/demo_fixtures.dart';
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
  final result = buildDemoResult(
    request,
    now: DateTime.utc(2026, 5, 20, 12),
    copy: testDemoEvidenceCopy,
  );
  return SavedCalculation(request: request, result: result);
}

SavedCalculation _seedLiveCalculation({
  String id = 'live-saved-1',
  String label = 'Live result',
}) {
  final request = CalculationRequest(
    id: id,
    isDemo: false,
    birthData: BirthData(
      birthDate: DateTime.utc(1990, 5, 14),
      birthCity: 'Kyiv, Ukraine',
      birthLatitude: 50.4501,
      birthLongitude: 30.5234,
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
  final result = CalculationResult(
    requestId: id,
    candidates: demoCandidates,
    evidence: const <EvidenceItem>[],
    isDemo: false,
    completedAt: DateTime.utc(2026, 5, 20, 12),
    method: 'test_live',
  );
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
    'live result has no DEMO pill, demo share prompt, or demo nudge',
    (tester) async {
      final seeded = _seedLiveCalculation();
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
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.byType(DemoPill), findsNothing);
      expect(find.byKey(resultDemoNudgeKey), findsNothing);
      expect(find.byKey(resultDemoSharePromptKey), findsNothing);

      // Live result still shows the hero card and CTAs.
      expect(find.byType(HeroResultCard), findsOneWidget);
      expect(find.text('See how we got this'), findsOneWidget);
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

  group('low-confidence guidance', () {
    SavedCalculation seedWithTopConfidence(double confidence, {String? id}) {
      final base = _seedDemoCalculation(id: id ?? 'demo-confidence-1');
      final candidates = base.result.candidates;
      return SavedCalculation(
        request: base.request,
        result: base.result.copyWith(
          candidates: <CandidateTime>[
            candidates.first.copyWith(confidence: confidence),
            ...candidates.skip(1),
          ],
        ),
      );
    }

    Future<void> pumpResult(
      WidgetTester tester,
      SavedCalculation seeded,
    ) async {
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
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'top confidence below 40% shows the refine guidance',
      (tester) async {
        await pumpResult(tester, seedWithTopConfidence(0.35));

        expect(find.byKey(resultLowConfidenceNoteKey), findsOneWidget);
        expect(find.text('Low confidence result'), findsOneWidget);
        // The note must spell out concrete next steps, not a generic body.
        expect(
          find.text('Add more dated life events.'),
          findsOneWidget,
        );
        expect(
          find.text(
            'Review your birth date, city, and approximate time.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('Try a wider birth-time window.'),
          findsOneWidget,
        );
        // The rest of the result surface stays intact — this is guidance,
        // not an error state.
        expect(find.byType(HeroResultCard), findsOneWidget);
        expect(find.text('See how we got this'), findsOneWidget);
      },
    );

    testWidgets(
      'top confidence just below the band boundary (39%) still shows it',
      (tester) async {
        await pumpResult(tester, seedWithTopConfidence(0.39));

        expect(find.byKey(resultLowConfidenceNoteKey), findsOneWidget);
      },
    );

    testWidgets(
      'top confidence at the mid band boundary (40%) does not show it',
      (tester) async {
        await pumpResult(tester, seedWithTopConfidence(0.40));

        expect(find.byKey(resultLowConfidenceNoteKey), findsNothing);
        expect(find.text('Low confidence result'), findsNothing);
      },
    );

    testWidgets(
      'high-confidence demo result (78%) does not show it',
      (tester) async {
        await pumpResult(tester, _seedDemoCalculation(id: 'demo-high-1'));

        expect(find.byKey(resultLowConfidenceNoteKey), findsNothing);
        expect(find.text('Low confidence result'), findsNothing);
      },
    );
  });

  group('confidence explainer', () {
    Future<void> pumpResult(
      WidgetTester tester,
      SavedCalculation seeded,
    ) async {
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
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'shows the confidence explanation under the confidence bar for the '
      'seeded demo result without hiding feedback or evidence CTAs',
      (tester) async {
        await pumpResult(tester, _seedDemoCalculation(id: 'demo-explain-1'));

        expect(find.byKey(resultConfidenceExplainerKey), findsOneWidget);
        expect(find.byKey(resultConfidenceExplainerTitleKey), findsOneWidget);
        expect(find.byKey(resultConfidenceExplainerBodyKey), findsOneWidget);
        expect(find.byKey(resultConfidenceExplainerMethodKey), findsOneWidget);
        expect(
          find.text('What does this percent mean?'),
          findsOneWidget,
        );
        // Wording stays probabilistic: estimate, relative support across
        // candidate times in the selected window — no absolute outcome
        // claims.
        final body = tester
            .widget<Text>(find.byKey(resultConfidenceExplainerBodyKey))
            .data!;
        expect(body, contains('estimate'));
        expect(body, contains('dated life events'));
        expect(body, contains('birth-time window'));
        final method = tester
            .widget<Text>(find.byKey(resultConfidenceExplainerMethodKey))
            .data!;
        expect(method, contains('transits'));
        expect(method, contains('progressions'));

        // Existing surfaces stay intact alongside the explainer.
        await tester.ensureVisible(find.byKey(resultFeedbackPromptKey));
        expect(find.byKey(resultFeedbackPromptKey), findsOneWidget);
        await tester.ensureVisible(find.byKey(resultEvidenceButtonKey));
        expect(find.byKey(resultEvidenceButtonKey), findsOneWidget);
        expect(find.byKey(resultShareButtonKey), findsOneWidget);
        expect(find.byKey(resultShareImageButtonKey), findsOneWidget);
      },
    );

    testWidgets(
      'renders below the low-confidence note when that note is present',
      (tester) async {
        final base = _seedDemoCalculation(id: 'demo-explain-2');
        final candidates = base.result.candidates;
        final lowConfidence = SavedCalculation(
          request: base.request,
          result: base.result.copyWith(
            candidates: <CandidateTime>[
              candidates.first.copyWith(confidence: 0.35),
              ...candidates.skip(1),
            ],
          ),
        );
        await pumpResult(tester, lowConfidence);

        expect(find.byKey(resultLowConfidenceNoteKey), findsOneWidget);
        expect(find.byKey(resultConfidenceExplainerKey), findsOneWidget);
        // The explainer sits below the low-confidence note.
        expect(
          tester.getTopLeft(find.byKey(resultConfidenceExplainerKey)).dy,
          greaterThan(
            tester.getBottomLeft(find.byKey(resultLowConfidenceNoteKey)).dy,
          ),
        );
      },
    );
  });

  group('plausibility feedback prompt', () {
    Future<ProviderContainer> pumpResult(
      WidgetTester tester,
      SavedCalculation seeded, {
      ResultFeedbackAnswer? storedAnswer,
    }) async {
      final prefs = await _prefs();
      if (storedAnswer != null) {
        // Seed through the store's public API so the test doesn't
        // couple to the on-disk key format.
        await ResultFeedbackStore(
          prefs,
        ).write(seeded.request.id, storedAnswer);
      }
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
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets(
      'renders on a loaded result with no stored answer and no '
      'saved confirmation',
      (tester) async {
        final seeded = _seedDemoCalculation(id: 'demo-feedback-1');
        final container = await pumpResult(tester, seeded);

        await tester.ensureVisible(find.byKey(resultFeedbackPromptKey));
        expect(find.byKey(resultFeedbackPromptKey), findsOneWidget);
        expect(find.text('Does this time feel plausible?'), findsOneWidget);
        expect(find.byKey(resultFeedbackYesKey), findsOneWidget);
        expect(find.byKey(resultFeedbackNotSureKey), findsOneWidget);
        expect(find.byKey(resultFeedbackNoKey), findsOneWidget);
        // Choices keep an accessible >= 44px hit target.
        expect(
          tester.getSize(find.byKey(resultFeedbackYesKey)).height,
          greaterThanOrEqualTo(44),
        );
        // Nothing answered yet: no confirmation, nothing persisted.
        expect(find.byKey(resultFeedbackSavedKey), findsNothing);
        expect(find.text('Thanks, saved.'), findsNothing);
        expect(
          container.read(resultFeedbackStoreProvider).read(seeded.request.id),
          isNull,
        );
      },
    );

    testWidgets(
      'tapping Not sure persists the answer and shows the confirmation',
      (tester) async {
        final seeded = _seedDemoCalculation(id: 'demo-feedback-2');
        final container = await pumpResult(tester, seeded);

        await tester.ensureVisible(find.byKey(resultFeedbackNotSureKey));
        await tester.tap(find.byKey(resultFeedbackNotSureKey));
        await tester.pumpAndSettle();

        expect(
          container.read(resultFeedbackStoreProvider).read(seeded.request.id),
          ResultFeedbackAnswer.notSure,
        );
        expect(find.byKey(resultFeedbackSavedKey), findsOneWidget);
        expect(find.text('Thanks, saved.'), findsOneWidget);
      },
    );

    testWidgets(
      'a previously saved No answer restores the confirmation on '
      'initial render',
      (tester) async {
        final seeded = _seedDemoCalculation(id: 'demo-feedback-3');
        final container = await pumpResult(
          tester,
          seeded,
          storedAnswer: ResultFeedbackAnswer.no,
        );

        await tester.ensureVisible(find.byKey(resultFeedbackPromptKey));
        expect(find.byKey(resultFeedbackSavedKey), findsOneWidget);
        expect(find.text('Thanks, saved.'), findsOneWidget);
        // The stored answer is untouched by merely rendering the prompt.
        expect(
          container.read(resultFeedbackStoreProvider).read(seeded.request.id),
          ResultFeedbackAnswer.no,
        );
      },
    );
  });
}
