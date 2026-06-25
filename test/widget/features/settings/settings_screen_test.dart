import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/reviews/review_service.dart';
import 'package:rectify/core/sharing/share_service.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/language_preference.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/reviews/review_invitation.dart';
import 'package:rectify/features/settings/delete_all_data_sheet.dart';
import 'package:rectify/features/settings/privacy_policy_link.dart';
import 'package:rectify/features/settings/privacy_policy_screen.dart';
import 'package:rectify/features/settings/settings_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/widgets/buttons/_button_shell.dart';
import 'package:rectify/widgets/inputs/labeled_toggle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/fixtures/sample_calculation.dart';
import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_privacy_policy_launcher.dart';
import '../../../helpers/fake_review_service.dart';
import '../../../helpers/fake_share_service.dart';

Future<SharedPreferences> _prefs({
  Map<String, Object> extra = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    // Skip the onboarding gate so SettingsScreen renders directly.
    'settings.onboarding_done': true,
    ...extra,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _wrap(
  SharedPreferences prefs, {
  InMemorySecureKeyStore? secure,
  FakeHistoryRepository? history,
  FakeShareService? shareService,
  FakeReviewService? reviewService,
  String? privacyPolicyUrl,
  FakePrivacyPolicyLauncher? privacyLauncher,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      // Simulates the owner's --dart-define=TRUERISE_PRIVACY_POLICY_URL
      // without mutating the compile-time environment; the launcher is
      // always faked so no test can reach the platform url_launcher.
      if (privacyPolicyUrl != null)
        privacyPolicyUrlProvider.overrideWithValue(privacyPolicyUrl),
      privacyPolicyLauncherProvider.overrideWithValue(
        privacyLauncher ?? FakePrivacyPolicyLauncher(),
      ),
      secureKeyStoreProvider.overrideWithValue(
        secure ?? InMemorySecureKeyStore(),
      ),
      historyRepositoryProvider.overrideWithValue(
        history ?? FakeHistoryRepository(),
      ),
      shareServiceProvider.overrideWithValue(
        shareService ?? FakeShareService(),
      ),
      reviewServiceProvider.overrideWithValue(
        reviewService ?? FakeReviewService(),
      ),
      // The default `appDatabaseProvider` opens a real Drift file with
      // a platform-specific path that no `sqflite` plugin backs in
      // widget tests. Settings actions still go through the real
      // `DefaultSettingsRepository`, so we hand it an in-memory
      // executor instead.
      appDatabaseProvider.overrideWith((ref) {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        ref.onDispose(db.close);
        return db;
      }),
    ],
    child: const RectifyApp(),
  );
}

Future<ProviderContainer> _pumpOnSettings(
  WidgetTester tester,
  Widget app,
) async {
  // The Settings screen is a tall scrollable; widget tests default to
  // an 800×600 surface where the lower rows (Delete all / Privacy /
  // version) live below the fold and never enter the lazy ListView.
  // Stretch the surface so every row is built and findable without
  // scrolling, then restore on tear-down. The Language section (7 radio
  // rows) pushes the lower rows further down, so the surface is tall
  // enough to build them all.
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(RectifyApp)),
  );
  container.read(routerProvider).go(RoutePaths.settings);
  await tester.pumpAndSettle();
  return container;
}

void main() {
  setUp(() {
    // The version footer reads the platform package info.
    PackageInfo.setMockInitialValues(
      appName: 'rectify',
      packageName: 'app.truerise',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('renders every row described in design-system §10.7', (
    tester,
  ) async {
    final prefs = await _prefs();
    await _pumpOnSettings(tester, _wrap(prefs));

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Demo mode'), findsOneWidget);
    expect(find.text('12-hour  (7:14 AM)'), findsOneWidget);
    expect(find.text('24-hour  (07:14)'), findsOneWidget);
    expect(find.text('Delete all data'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    // Installed version + build now come from package_info_plus.
    expect(find.text('TrueRise  v1.0.0 (1)'), findsOneWidget);
  });

  testWidgets('demo toggle updates settings + persists to prefs', (
    tester,
  ) async {
    final prefs = await _prefs();
    final container = await _pumpOnSettings(tester, _wrap(prefs));

    expect(
      container.read(settingsControllerProvider).demoModeDefault,
      isFalse,
    );

    await tester.tap(find.byType(LabeledToggle));
    await tester.pumpAndSettle();

    expect(
      container.read(settingsControllerProvider).demoModeDefault,
      isTrue,
    );
    expect(prefs.getBool('settings.demo_mode_default'), isTrue);
  });

  testWidgets('time-format radio persists and is consumed by formatters', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());

    final container = await _pumpOnSettings(
      tester,
      _wrap(prefs, history: history),
    );

    // Pick 24-hour from the radio.
    await tester.tap(find.text('24-hour  (07:14)'));
    await tester.pumpAndSettle();

    expect(
      container.read(settingsControllerProvider).timeFormat,
      TimeFormat.h24,
    );
    expect(
      prefs.getString('settings.time_format'),
      TimeFormat.h24.tag,
    );

    // The Home / History list reads the same setting and renders the
    // 24-hour string.
    container.read(routerProvider).go(RoutePaths.home);
    await tester.pumpAndSettle();
    expect(find.textContaining('07:14'), findsOneWidget);
    expect(find.textContaining('7:14 AM'), findsNothing);
  });

  testWidgets('renders the language section with Auto and 6 endonyms', (
    tester,
  ) async {
    final prefs = await _prefs();
    final container = await _pumpOnSettings(tester, _wrap(prefs));

    // `_SectionLabel` renders headings uppercased, like every other section.
    expect(find.text('LANGUAGE'), findsOneWidget);
    expect(find.text('Automatic (device language)'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('Français'), findsOneWidget);
    expect(find.text('Português'), findsOneWidget);
    expect(find.text('Українська'), findsOneWidget);

    // Default is Auto (device-driven) — nothing manual persisted yet.
    expect(
      container.read(settingsControllerProvider).languagePreference,
      LanguagePreference.auto,
    );
    expect(prefs.getString('settings.language_preference'), isNull);
  });

  testWidgets(
    'selecting a language applies immediately and persists across restart',
    (tester) async {
      final prefs = await _prefs();
      final container = await _pumpOnSettings(tester, _wrap(prefs));

      // The endonym row label is constant across locales, so it is
      // tappable regardless of the current UI language.
      await tester.tap(find.text('Deutsch'));
      await tester.pumpAndSettle();

      // Controller state + persisted prefs both hold the manual choice.
      expect(
        container.read(settingsControllerProvider).languagePreference,
        LanguagePreference.german,
      );
      expect(prefs.getString('settings.language_preference'), 'de');

      // MaterialApp.router re-localized live: the translated Auto label
      // switched to German and the English one is gone, while the endonym
      // row label stays constant across locales.
      expect(find.text('Automatisch (Gerätesprache)'), findsOneWidget);
      expect(find.text('Automatic (device language)'), findsNothing);
      expect(find.text('Deutsch'), findsOneWidget);
    },
  );

  testWidgets(
    'API key flow saves trimmed key securely and never echoes it',
    (tester) async {
      final prefs = await _prefs();
      final secure = InMemorySecureKeyStore();
      final container = await _pumpOnSettings(
        tester,
        _wrap(prefs, secure: secure),
      );

      // Store-build safe copy plus the entry action.
      expect(
        find.text('Already have an Astrology API key? Add it here.'),
        findsOneWidget,
      );
      expect(
        find.text('Get a key at ${AppLinks.astrologyApiKeyUrl}'),
        findsOneWidget,
      );
      expect(find.text('Add key'), findsOneWidget);

      await tester.tap(find.text('Add key'));
      await tester.pumpAndSettle();

      expect(find.text('Astrology API key'), findsOneWidget);
      expect(find.text('Save key'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Get a key at ${AppLinks.astrologyApiKeyUrl}'),
        ),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField), '  user-key-123  ');
      await tester.tap(find.text('Save key'));
      await tester.pumpAndSettle();

      // The trimmed key lands in secure storage only; the configured
      // flag mirrors it in the controller and prefs.
      expect(await secure.readProApiKey(), 'user-key-123');
      expect(
        container.read(settingsControllerProvider).proApiKeyConfigured,
        isTrue,
      );
      expect(prefs.getBool('settings.pro_api_key_configured'), isTrue);

      // §9.5 hard rule — the raw key is never echoed back into the UI.
      expect(find.textContaining('user-key-123'), findsNothing);

      expect(find.text('API key added'), findsOneWidget);
      expect(find.text('Remove key'), findsOneWidget);

      await tester.tap(find.text('Remove key'));
      await tester.pumpAndSettle();

      expect(await secure.readProApiKey(), isNull);
      expect(
        container.read(settingsControllerProvider).proApiKeyConfigured,
        isFalse,
      );
      expect(prefs.getBool('settings.pro_api_key_configured'), isFalse);
      expect(find.text('Add key'), findsOneWidget);
    },
  );

  testWidgets('Delete all data wipes stores and routes to onboarding', (
    tester,
  ) async {
    final prefs = await _prefs(
      extra: <String, Object>{
        'settings.demo_mode_default': true,
        'settings.pro_api_key_configured': true,
      },
    );
    final secure = InMemorySecureKeyStore(seed: 'sk-going-away');
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());

    final container = await _pumpOnSettings(
      tester,
      _wrap(prefs, secure: secure, history: history),
    );

    await tester.tap(find.text('Delete all data'));
    await tester.pumpAndSettle();

    expect(find.byType(DeleteAllDataSheet), findsOneWidget);
    expect(find.textContaining('1 calculation'), findsOneWidget);

    // Two "Delete" labels exist: the destructive CTA in the sheet and
    // the row in the underlying settings card. Tap the one inside the
    // sheet.
    final deleteButton = find
        .descendant(
          of: find.byType(DeleteAllDataSheet),
          matching: find.text('Delete'),
        )
        .first;
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Settings model reset to initial — onboardingDone flips false,
    // proApiKeyConfigured false, demoModeDefault false.
    final settings = container.read(settingsControllerProvider);
    expect(settings.onboardingDone, isFalse);
    expect(settings.proApiKeyConfigured, isFalse);
    expect(settings.demoModeDefault, isFalse);

    // Secure storage and prefs wiped.
    expect(await secure.readProApiKey(), isNull);
    expect(prefs.getKeys(), isEmpty);

    // Router redirected to onboarding (the first slide copy renders).
    expect(
      find.textContaining('Your birth chart depends on'),
      findsOneWidget,
    );
  });

  testWidgets('Privacy row pushes the in-app privacy screen', (tester) async {
    // Default build: TRUERISE_PRIVACY_POLICY_URL is empty, so the hosted
    // path is disabled and the bundled screen renders as before.
    final prefs = await _prefs();
    final launcher = FakePrivacyPolicyLauncher();
    await _pumpOnSettings(tester, _wrap(prefs, privacyLauncher: launcher));

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();

    expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    expect(find.text('What TrueRise stores'), findsOneWidget);
    expect(find.text('Deleting your data'), findsOneWidget);
    expect(launcher.opened, isEmpty);
  });

  testWidgets(
    'Privacy row opens a configured hosted policy URL in an in-app '
    'browser view',
    (tester) async {
      final prefs = await _prefs();
      final launcher = FakePrivacyPolicyLauncher();
      await _pumpOnSettings(
        tester,
        _wrap(
          prefs,
          privacyPolicyUrl: 'https://truerise.com.ua/privacy.html',
          privacyLauncher: launcher,
        ),
      );

      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();

      expect(launcher.opened, ['https://truerise.com.ua/privacy.html']);
      expect(find.byType(PrivacyPolicyScreen), findsNothing);
    },
  );

  testWidgets(
    'Privacy row falls back to the in-app screen for an unsafe URL',
    (tester) async {
      // A query string is where tracking params live — the validator
      // rejects it, the launcher is never consulted, and the bundled
      // screen renders instead.
      final prefs = await _prefs();
      final launcher = FakePrivacyPolicyLauncher();
      await _pumpOnSettings(
        tester,
        _wrap(
          prefs,
          privacyPolicyUrl: 'https://truerise.com.ua/privacy.html?utm_source=app',  // query string makes it invalid
          privacyLauncher: launcher,
        ),
      );

      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();

      expect(launcher.opened, isEmpty);
      expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Privacy row falls back to the in-app screen when the launch fails',
    (tester) async {
      final prefs = await _prefs();
      final launcher = FakePrivacyPolicyLauncher(returnsLaunched: false);
      await _pumpOnSettings(
        tester,
        _wrap(
          prefs,
          privacyPolicyUrl: 'https://truerise.com.ua/privacy.html',
          privacyLauncher: launcher,
        ),
      );

      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();

      expect(launcher.opened, ['https://truerise.com.ua/privacy.html']);
      expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    },
  );

  testWidgets(
    'destructive CTA in delete sheet uses the destructive button variant',
    (tester) async {
      final prefs = await _prefs();
      await _pumpOnSettings(tester, _wrap(prefs));

      // Settings card hosts a DestructiveButton too — opening the sheet
      // adds a second one.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RectifyButtonShell &&
              w.variant == RectifyButtonVariant.destructive,
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete all data'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RectifyButtonShell &&
              w.variant == RectifyButtonVariant.destructive,
        ),
        findsNWidgets(2),
      );
    },
  );

  testWidgets('renders an opt-in "Invite a friend" row in the About section', (
    tester,
  ) async {
    final prefs = await _prefs();
    await _pumpOnSettings(tester, _wrap(prefs));

    expect(find.byKey(settingsInviteButtonKey), findsOneWidget);
    expect(find.text('Invite a friend'), findsOneWidget);
  });

  testWidgets(
    'tapping Invite shares a localized, branded, linked, PII-free invite',
    (tester) async {
      final prefs = await _prefs();
      final shareService = FakeShareService();
      // Seed a calculation so any accidental PII leak would have a source.
      final history = FakeHistoryRepository();
      await history.save(sampleRequest(), sampleResult());

      await _pumpOnSettings(
        tester,
        _wrap(prefs, history: history, shareService: shareService),
      );

      await tester.tap(find.byKey(settingsInviteButtonKey));
      await tester.pumpAndSettle();

      expect(shareService.shared, hasLength(1));
      final invite = shareService.shared.first;
      expect(invite, isNotEmpty);
      expect(invite, contains('TrueRise'));
      expect(invite, contains(AppLinks.shareUrl));
      // None of the seeded calculation's data may ride along.
      expect(invite, isNot(contains('Kyiv')));
      expect(invite, isNot(contains('Ukraine')));
      expect(invite, isNot(contains('1990')));
      expect(invite, isNot(contains('marriage')));
      // Not a referral / reward program.
      expect(invite.toLowerCase(), isNot(contains('referral')));
      expect(invite.toLowerCase(), isNot(contains('reward')));
      expect(invite.toLowerCase(), isNot(contains('code')));
    },
  );

  testWidgets(
    'Invite never triggers the review prompt — even when fully eligible',
    (tester) async {
      // Fresh prefs (no prior prompt) + an available review service means
      // the review flow WOULD fire on a result-screen share. The invite
      // must still never chain it.
      final prefs = await _prefs();
      final shareService = FakeShareService();
      final reviewService = FakeReviewService();

      await _pumpOnSettings(
        tester,
        _wrap(
          prefs,
          shareService: shareService,
          reviewService: reviewService,
        ),
      );

      await tester.tap(find.byKey(settingsInviteButtonKey));
      await tester.pumpAndSettle();

      expect(shareService.shared, hasLength(1));
      expect(find.byKey(reviewInvitationDialogKey), findsNothing);
      expect(reviewService.requestReviewCount, 0);
    },
  );

  testWidgets('Invite shows the clipboard SnackBar on the fallback path', (
    tester,
  ) async {
    final prefs = await _prefs();
    // returnsNative: false → clipboard fallback, not the native sheet.
    final shareService = FakeShareService(returnsNative: false);

    await _pumpOnSettings(tester, _wrap(prefs, shareService: shareService));

    await tester.tap(find.byKey(settingsInviteButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Copied to clipboard'), findsOneWidget);
    // A fallback is a degraded path, never a positive review moment.
    expect(find.byKey(reviewInvitationDialogKey), findsNothing);
  });
}
