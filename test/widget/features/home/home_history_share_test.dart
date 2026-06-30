import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/core/analytics/app_analytics.dart';
import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/reviews/review_service.dart';
import 'package:rectify/core/sharing/share_service.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/home/home_history_screen.dart';
import 'package:rectify/features/reviews/review_invitation.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/cards/history_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/fixtures/sample_calculation.dart';
import '../../../helpers/fake_app_analytics.dart';
import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_review_service.dart';
import '../../../helpers/fake_share_service.dart';

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _wrap(
  SharedPreferences prefs,
  FakeHistoryRepository history, {
  required FakeShareService shareService,
  FakeAppAnalytics? analytics,
  FakeReviewService? reviewService,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    shareServiceProvider.overrideWithValue(shareService),
    if (analytics != null) appAnalyticsProvider.overrideWithValue(analytics),
    if (reviewService != null)
      reviewServiceProvider.overrideWithValue(reviewService),
  ],
  child: const RectifyApp(),
);

void main() {
  Finder historyShareIcons() => find.descendant(
    of: find.byType(HistoryCard),
    matching: find.byIcon(AppIcons.share),
  );

  testWidgets('populated history shows a soft invite banner above results', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult(isDemo: false));
    final shareService = FakeShareService();

    await tester.pumpWidget(_wrap(prefs, history, shareService: shareService));
    await tester.pumpAndSettle();

    expect(
      find.text('Know someone who needs their birth time?'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Share TrueRise without sharing your own birth date, city, '
        'or life events.',
      ),
      findsOneWidget,
    );
    expect(find.text('Invite a friend'), findsOneWidget);
    expect(find.text('Past calculations'), findsOneWidget);
    expect(find.byType(HistoryCard), findsOneWidget);
  });

  testWidgets('home invite shares branded copy without PII or review prompt', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult(isDemo: false));
    final shareService = FakeShareService();
    final reviewService = FakeReviewService();

    await tester.pumpWidget(
      _wrap(
        prefs,
        history,
        shareService: shareService,
        reviewService: reviewService,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invite a friend'));
    await tester.pumpAndSettle();

    expect(shareService.shared, hasLength(1));
    final invite = shareService.shared.first;
    expect(invite, contains('TrueRise'));
    expect(invite, contains(AppLinks.shareUrl));
    expect(invite, isNot(contains('Kyiv')));
    expect(invite, isNot(contains('Ukraine')));
    expect(invite, isNot(contains('1990')));
    expect(invite, isNot(contains('marriage')));
    expect(invite.toLowerCase(), isNot(contains('referral')));
    expect(invite.toLowerCase(), isNot(contains('reward')));
    expect(invite.toLowerCase(), isNot(contains('code')));
    expect(find.byKey(reviewInvitationDialogKey), findsNothing);
    expect(reviewService.requestReviewCount, 0);
  });

  testWidgets('home invite records privacy-safe share analytics', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult(isDemo: false));
    final shareService = FakeShareService();
    final analytics = FakeAppAnalytics();

    await tester.pumpWidget(
      _wrap(
        prefs,
        history,
        shareService: shareService,
        analytics: analytics,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invite a friend'));
    await tester.pumpAndSettle();

    expect(analytics.shareEvents, hasLength(1));
    expect(
      analytics.shareEvents.single.surface,
      ShareAnalyticsSurface.homeInvite,
    );
    expect(
      analytics.shareEvents.single.content,
      ShareAnalyticsContent.inviteText,
    );
    expect(
      analytics.shareEvents.single.outcome,
      ShareAnalyticsOutcome.nativeSheet,
    );
  });

  testWidgets('home invite falls back to a clipboard SnackBar', (tester) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult(isDemo: false));
    final shareService = FakeShareService(returnsNative: false);

    await tester.pumpWidget(_wrap(prefs, history, shareService: shareService));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invite a friend'));
    await tester.pumpAndSettle();

    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  testWidgets('every populated history row shows a share affordance', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());
    await history.save(
      sampleRequest(id: 'req-002').copyWith(label: 'Friend chart'),
      sampleResult(requestId: 'req-002', isDemo: false),
    );
    final shareService = FakeShareService();

    await tester.pumpWidget(_wrap(prefs, history, shareService: shareService));
    await tester.pumpAndSettle();

    expect(find.byType(HistoryCard), findsNWidgets(2));
    expect(historyShareIcons(), findsNWidgets(2));
  });

  testWidgets('tapping a row share affordance shares the PII-free summary', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    // A real (non-demo) saved result — the most sensitive case.
    await history.save(sampleRequest(), sampleResult(isDemo: false));
    final shareService = FakeShareService();

    await tester.pumpWidget(_wrap(prefs, history, shareService: shareService));
    await tester.pumpAndSettle();

    await tester.tap(historyShareIcons().first);
    await tester.pumpAndSettle();

    // The icon consumed the tap — it did not navigate into the result.
    expect(find.byType(HomeHistoryScreen), findsOneWidget);

    expect(shareService.shared, hasLength(1));
    final sharedText = shareService.shared.first;
    expect(sharedText, isNotEmpty);
    // No birth city, birth date, life events, label, or API ids.
    expect(sharedText, isNot(contains('Kyiv')));
    expect(sharedText, isNot(contains('Ukraine')));
    expect(sharedText, isNot(contains('1990')));
    expect(sharedText, isNot(contains('marriage')));
    expect(sharedText, isNot(contains('careerChange')));
    expect(sharedText, isNot(contains('Sample calculation')));
    expect(sharedText, isNot(contains('req-001')));
    // It still carries the privacy-safe payload (brand tagline).
    expect(sharedText, contains('TrueRise'));
  });

  testWidgets('history row share records privacy-safe share analytics', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult(isDemo: false));
    final shareService = FakeShareService();
    final analytics = FakeAppAnalytics();

    await tester.pumpWidget(
      _wrap(
        prefs,
        history,
        shareService: shareService,
        analytics: analytics,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(historyShareIcons().first);
    await tester.pumpAndSettle();

    expect(analytics.shareEvents, hasLength(1));
    expect(
      analytics.shareEvents.single.surface,
      ShareAnalyticsSurface.historyRow,
    );
    expect(
      analytics.shareEvents.single.content,
      ShareAnalyticsContent.resultText,
    );
    expect(
      analytics.shareEvents.single.outcome,
      ShareAnalyticsOutcome.nativeSheet,
    );
  });

  testWidgets('history share falls back to a clipboard SnackBar', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());
    final shareService = FakeShareService(returnsNative: false);

    await tester.pumpWidget(_wrap(prefs, history, shareService: shareService));
    await tester.pumpAndSettle();

    await tester.tap(historyShareIcons().first);
    await tester.pumpAndSettle();

    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  testWidgets('history share never invites a review', (tester) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());
    final shareService = FakeShareService();
    final reviewService = FakeReviewService();

    await tester.pumpWidget(
      _wrap(
        prefs,
        history,
        shareService: shareService,
        reviewService: reviewService,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(historyShareIcons().first);
    await tester.pumpAndSettle();

    expect(find.byKey(reviewInvitationDialogKey), findsNothing);
    expect(reviewService.requestReviewCount, 0);
  });
}
