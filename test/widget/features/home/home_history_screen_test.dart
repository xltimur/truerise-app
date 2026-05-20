import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/home/home_history_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/cards/history_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/fixtures/sample_calculation.dart';
import '../../../helpers/fake_history_repository.dart';

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    // Skip the onboarding gate so HomeHistoryScreen renders directly.
    'settings.onboarding_done': true,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _wrap(
  SharedPreferences prefs,
  FakeHistoryRepository history,
) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
  ],
  child: const RectifyApp(),
);

void main() {
  testWidgets('empty state renders title, body, and the New Calculation CTA', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();

    await tester.pumpWidget(_wrap(prefs, history));
    await tester.pumpAndSettle();

    expect(find.byType(HomeHistoryScreen), findsOneWidget);
    expect(find.text('No calculations yet.'), findsOneWidget);
    expect(
      find.text('Run your first one to see results here.'),
      findsOneWidget,
    );
    expect(find.text('New Calculation'), findsWidgets);
    expect(find.byType(HistoryCard), findsNothing);
  });

  testWidgets('populated state renders one HistoryCard per saved row', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());
    await history.save(
      sampleRequest(id: 'req-002').copyWith(label: 'Friend chart'),
      sampleResult(requestId: 'req-002', isDemo: false),
    );

    await tester.pumpWidget(_wrap(prefs, history));
    await tester.pumpAndSettle();

    expect(find.text('Past calculations'), findsOneWidget);
    expect(find.byType(HistoryCard), findsNWidgets(2));
    expect(find.text('Sample calculation'), findsOneWidget);
    expect(find.text('Friend chart'), findsOneWidget);
    // Top-candidate time + meridiem (78% confidence → labelled high).
    // HistoryCard uses Text.rich, so the rendered text is `7:14 AM`
    // — `find.text` needs the full concatenated value.
    expect(find.text('7:14 AM'), findsNWidgets(2));
    // Confidence percent from `sampleResult()` (0.78 → "78%").
    expect(find.text('78%'), findsNWidgets(2));
    // Demo row gets the DEMO pill, real row does not.
    expect(find.text('DEMO'), findsOneWidget);
  });

  testWidgets(
    'swipe-to-delete with confirmation removes the row and toasts',
    (tester) async {
      final prefs = await _prefs();
      final history = FakeHistoryRepository();
      await history.save(sampleRequest(), sampleResult());

      await tester.pumpWidget(_wrap(prefs, history));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryCard), findsOneWidget);

      await tester.drag(find.byType(HistoryCard), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Delete this calculation?'), findsOneWidget);

      // Two "Delete" texts exist post-swipe: the dismiss-background label
      // and the AlertDialog action. Target the action button explicitly.
      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryCard), findsNothing);
      expect(find.text('No calculations yet.'), findsOneWidget);
      expect(find.textContaining('deleted.'), findsOneWidget);
    },
  );

  testWidgets('cancelling the delete dialog keeps the row', (tester) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());

    await tester.pumpWidget(_wrap(prefs, history));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(HistoryCard), const Offset(-500, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(HistoryCard), findsOneWidget);
    expect(find.text('No calculations yet.'), findsNothing);
  });
}
