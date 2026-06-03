import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/core/reviews/review_service.dart';
import 'package:rectify/core/sharing/share_service.dart';
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
import 'package:rectify/features/reviews/review_invitation.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/demo_fixtures.dart';
import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';
import '../../../helpers/fake_review_service.dart';
import '../../../helpers/fake_share_service.dart';

Future<SharedPreferences> _prefs({DateTime? lastReviewPromptAt}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': true,
    if (lastReviewPromptAt != null)
      'review.last_prompt_at_ms': lastReviewPromptAt
          .toUtc()
          .millisecondsSinceEpoch,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _harness({
  required SharedPreferences prefs,
  required FakeHistoryRepository history,
  required FakeRectificationRepository rectifier,
  required InMemoryDraftRepository drafts,
  required FakeShareService shareService,
  required FakeReviewService reviewService,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    rectificationRepositoryProvider.overrideWithValue(rectifier),
    draftRepositoryProvider.overrideWithValue(drafts),
    shareServiceProvider.overrideWithValue(shareService),
    reviewServiceProvider.overrideWithValue(reviewService),
  ],
  child: const RectifyApp(),
);

SavedCalculation _seedDemoCalculation({String id = 'review-demo-1'}) {
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
    ],
    createdAt: DateTime.utc(2026, 5, 22, 10),
    label: 'Review test calc',
  );
  final result = buildDemoResult(
    request,
    now: DateTime.utc(2026, 5, 22, 10),
    copy: testDemoEvidenceCopy,
  );
  return SavedCalculation(request: request, result: result);
}

Future<void> _openResult(WidgetTester tester, String id) async {
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  container.read(routerProvider).go(RoutePaths.calcResultFor(id));
  await tester.pumpAndSettle();
}

Future<void> _waitForImageShare(FakeShareService shareService) async {
  for (var i = 0; i < 40; i += 1) {
    if (shareService.sharedImages.isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxTries = 40,
}) async {
  for (var i = 0; i < maxTries; i += 1) {
    await tester.pump(const Duration(milliseconds: 50));
    if (finder.evaluate().isNotEmpty) return;
  }
}

void main() {
  testWidgets(
    'successful native text share invites a review; confirming hands off '
    'to the native review flow',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      final reviewService = FakeReviewService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
          reviewService: reviewService,
        ),
      );
      await _openResult(tester, seeded.request.id);

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(reviewInvitationDialogKey), findsOneWidget);
      expect(reviewService.requestReviewCount, 0);

      await tester.tap(find.byKey(reviewInvitationConfirmKey));
      await tester.pumpAndSettle();

      expect(find.byKey(reviewInvitationDialogKey), findsNothing);
      expect(reviewService.requestReviewCount, 1);
    },
  );

  testWidgets(
    'declining the invitation never calls the review flow and consumes '
    'the cooldown',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      final reviewService = FakeReviewService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
          reviewService: reviewService,
        ),
      );
      await _openResult(tester, seeded.request.id);

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(reviewInvitationDismissKey));
      await tester.pumpAndSettle();

      expect(reviewService.requestReviewCount, 0);

      // A second successful share must not re-prompt: the cooldown was
      // recorded the moment the first invitation appeared.
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(reviewInvitationDialogKey), findsNothing);
      expect(reviewService.requestReviewCount, 0);
    },
  );

  testWidgets(
    'no review invitation after the clipboard fallback (share not native)',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      // returnsNative: false → the clipboard fallback path, not a win.
      final shareService = FakeShareService(returnsNative: false);
      final reviewService = FakeReviewService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
          reviewService: reviewService,
        ),
      );
      await _openResult(tester, seeded.request.id);

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Copied to clipboard'), findsOneWidget);
      expect(find.byKey(reviewInvitationDialogKey), findsNothing);
      expect(reviewService.requestReviewCount, 0);
    },
  );

  testWidgets(
    'no review invitation when still within the cooldown window',
    (tester) async {
      final seeded = _seedDemoCalculation();
      // A prompt one day ago → ineligible under the default cooldown.
      final prefs = await _prefs(
        lastReviewPromptAt: DateTime.now().toUtc().subtract(
          const Duration(days: 1),
        ),
      );
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      final reviewService = FakeReviewService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
          reviewService: reviewService,
        ),
      );
      await _openResult(tester, seeded.request.id);

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(reviewInvitationDialogKey), findsNothing);
      expect(reviewService.requestReviewCount, 0);
    },
  );

  testWidgets(
    'successful native image share also invites a review',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      final reviewService = FakeReviewService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
          reviewService: reviewService,
        ),
      );
      await _openResult(tester, seeded.request.id);

      await tester.ensureVisible(find.byKey(resultShareImageButtonKey));
      await tester.tap(find.byKey(resultShareImageButtonKey));
      await tester.runAsync(() => _waitForImageShare(shareService));
      await tester.pumpAndSettle();
      await _pumpUntilFound(tester, find.byKey(reviewInvitationDialogKey));

      expect(find.byKey(reviewInvitationDialogKey), findsOneWidget);
    },
  );
}
