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

import '../../../data/fixtures/sample_calculation.dart';
import '../../../helpers/demo_fixtures.dart';
import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';
import '../../../helpers/fake_review_service.dart';
import '../../../helpers/fake_share_service.dart';

Future<SharedPreferences> _prefs({
  bool demoSharePromptSeen = false,
  bool realResultSharePromptSeen = false,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': true,
    if (demoSharePromptSeen) 'share.demo_prompt_seen': true,
    if (realResultSharePromptSeen) 'share.real_result_prompt_seen': true,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _harness({
  required SharedPreferences prefs,
  required FakeHistoryRepository history,
  required FakeRectificationRepository rectifier,
  required InMemoryDraftRepository drafts,
  required FakeShareService shareService,
  FakeReviewService? reviewService,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    rectificationRepositoryProvider.overrideWithValue(rectifier),
    draftRepositoryProvider.overrideWithValue(drafts),
    shareServiceProvider.overrideWithValue(shareService),
    if (reviewService != null)
      reviewServiceProvider.overrideWithValue(reviewService),
  ],
  child: const RectifyApp(),
);

SavedCalculation _seedDemoCalculation({String id = 'demo-share-1'}) {
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
    label: 'Demo share calc',
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

void main() {
  testWidgets(
    'a fresh demo result shows the one-time share prompt and marks it seen',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
        ),
      );
      await _openResult(tester, seeded.request.id);

      expect(find.byKey(resultDemoSharePromptKey), findsOneWidget);
      expect(find.byKey(resultDemoSharePromptShareKey), findsOneWidget);
      // Shown once: the persisted flag is set so it never reappears.
      expect(prefs.getBool('share.demo_prompt_seen'), isTrue);
    },
  );

  testWidgets('the share prompt does not appear once it has been seen', (
    tester,
  ) async {
    final seeded = _seedDemoCalculation();
    final prefs = await _prefs(demoSharePromptSeen: true);
    final history = FakeHistoryRepository([seeded]);
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    final shareService = FakeShareService();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
        shareService: shareService,
      ),
    );
    await _openResult(tester, seeded.request.id);

    expect(find.byKey(resultDemoSharePromptKey), findsNothing);
  });

  testWidgets('a fresh real result shows the store-safe friend share prompt', (
    tester,
  ) async {
    final saved = SavedCalculation(
      request: sampleRequest(),
      result: sampleResult(isDemo: false),
    );
    final prefs = await _prefs();
    final history = FakeHistoryRepository([saved]);
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    final shareService = FakeShareService();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
        shareService: shareService,
      ),
    );
    await _openResult(tester, saved.request.id);

    const friendShareBody =
        'Share TrueRise with them. Your result share never includes '
        'birth date, birthplace, or life events.';
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.byKey(resultDemoSharePromptKey), findsOneWidget);
    expect(
      find.text("Know someone who doesn't know their birth time?"),
      findsOneWidget,
    );
    expect(find.text(friendShareBody), findsOneWidget);
    expect(find.text('What will be shared'), findsOneWidget);
    expect(
      find.textContaining('My TrueRise rectification result:'),
      findsOneWidget,
    );
    expect(find.textContaining('Find your birth time:'), findsOneWidget);
    expect(find.textContaining('Kyiv'), findsNothing);
    expect(find.textContaining('1990'), findsNothing);
    expect(find.text('Share with a friend'), findsOneWidget);
    expect(prefs.getBool('share.real_result_prompt_seen'), isTrue);
  });

  testWidgets('the real result share prompt does not appear once seen', (
    tester,
  ) async {
    final saved = SavedCalculation(
      request: sampleRequest(),
      result: sampleResult(isDemo: false),
    );
    final prefs = await _prefs(realResultSharePromptSeen: true);
    final history = FakeHistoryRepository([saved]);
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    final shareService = FakeShareService();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
        shareService: shareService,
      ),
    );
    await _openResult(tester, saved.request.id);

    expect(find.byType(ResultScreen), findsOneWidget);
    expect(
      find.text("Know someone who doesn't know their birth time?"),
      findsNothing,
    );
    expect(find.text('Share with a friend'), findsNothing);
  });

  testWidgets('tapping Share sample shares the PII-free summary', (
    tester,
  ) async {
    final seeded = _seedDemoCalculation();
    final prefs = await _prefs();
    final history = FakeHistoryRepository([seeded]);
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    final shareService = FakeShareService();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
        shareService: shareService,
      ),
    );
    await _openResult(tester, seeded.request.id);

    await tester.ensureVisible(find.byKey(resultDemoSharePromptShareKey));
    await tester.tap(find.byKey(resultDemoSharePromptShareKey));
    await tester.pumpAndSettle();

    expect(shareService.shared, hasLength(1));
    final sharedText = shareService.shared.first;
    expect(sharedText, isNotEmpty);
    expect(sharedText, isNot(contains('Kyiv')));
    expect(sharedText, isNot(contains('Ukraine')));
    expect(sharedText, isNot(contains('1990')));
    expect(sharedText, isNot(contains('marriage')));
    expect(sharedText, isNot(contains('Demo share calc')));
    expect(sharedText, contains('TrueRise'));
  });

  testWidgets('Share sample falls back to a clipboard SnackBar', (
    tester,
  ) async {
    final seeded = _seedDemoCalculation();
    final prefs = await _prefs();
    final history = FakeHistoryRepository([seeded]);
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    final shareService = FakeShareService(returnsNative: false);
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
        shareService: shareService,
      ),
    );
    await _openResult(tester, seeded.request.id);

    await tester.ensureVisible(find.byKey(resultDemoSharePromptShareKey));
    await tester.tap(find.byKey(resultDemoSharePromptShareKey));
    await tester.pumpAndSettle();

    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  testWidgets('tapping the real result prompt shares the PII-free summary', (
    tester,
  ) async {
    final saved = SavedCalculation(
      request: sampleRequest(),
      result: sampleResult(isDemo: false),
    );
    final prefs = await _prefs();
    final history = FakeHistoryRepository([saved]);
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    final shareService = FakeShareService();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
        shareService: shareService,
      ),
    );
    await _openResult(tester, saved.request.id);

    await tester.ensureVisible(find.text('Share with a friend'));
    await tester.tap(find.text('Share with a friend'));
    await tester.pumpAndSettle();

    expect(shareService.shared, hasLength(1));
    final sharedText = shareService.shared.first;
    expect(sharedText, isNotEmpty);
    expect(sharedText, isNot(contains('Kyiv')));
    expect(sharedText, isNot(contains('Ukraine')));
    expect(sharedText, isNot(contains('1990')));
    expect(sharedText, isNot(contains('marriage')));
    expect(sharedText, contains('TrueRise'));
  });

  testWidgets('the real result prompt never invites a review', (tester) async {
    final saved = SavedCalculation(
      request: sampleRequest(),
      result: sampleResult(isDemo: false),
    );
    final prefs = await _prefs();
    final history = FakeHistoryRepository([saved]);
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
    await _openResult(tester, saved.request.id);

    await tester.ensureVisible(find.text('Share with a friend'));
    await tester.tap(find.text('Share with a friend'));
    await tester.pumpAndSettle();

    expect(find.byKey(reviewInvitationDialogKey), findsNothing);
    expect(reviewService.requestReviewCount, 0);
  });

  testWidgets('the demo share prompt never invites a review', (tester) async {
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

    await tester.ensureVisible(find.byKey(resultDemoSharePromptShareKey));
    await tester.tap(find.byKey(resultDemoSharePromptShareKey));
    await tester.pumpAndSettle();

    expect(find.byKey(reviewInvitationDialogKey), findsNothing);
    expect(reviewService.requestReviewCount, 0);
  });
}
