// Committed raw store screenshot capture harness (Flutter test based).
//
// This re-introduces, as a reusable and reviewable artifact, the throwaway
// `/tmp` harness that produced the canonical `screenshots/store/<locale>` raw
// frames: it renders the SHIPPED `RectifyApp` UI fully offline (Demo mode, no
// network) at the iPhone 6.7" 1290x2796 store geometry and, on explicit opt-in,
// encodes one frame to PNG via `RenderRepaintBoundary.toImage(pixelRatio: 3)`.
//
// Safety / toolchain model:
//  * `RenderRepaintBoundary.toImage` on the full app DOES encode a correct
//    1290x2796 PNG, but on this toolchain the `flutter_tester` shell then hangs
//    at finalization and is reaped by the per-test timeout. So the capture
//    writes its single frame to disk SYNCHRONOUSLY (flush) the instant it is
//    encoded, before that finalization hang, and runs one frame per process.
//  * Because that capture path always ends in a timeout, a normal `flutter
//    test` run must NEVER take it: the default (no-opt-in) run only renders the
//    shipped UI, navigates to the target frame, and asserts the capture surface
//    geometry. It calls no `toImage`, writes nothing, and finishes cleanly.
//  * Real on-disk writes happen ONLY under the explicit env opt-in, one frame
//    per process. By default the target is `screenshots/store/en-current-draft/`;
//    after localization review, `RECTIFY_CAPTURE_LOCALE=<de|fr|es|pt-BR>` may
//    write only the two missing current-plan frames into that canonical pack:
//      RECTIFY_CAPTURE_RAW_SCREENSHOTS=1 RECTIFY_CAPTURE_FRAME=problem-hook \
//        flutter test test/tool/raw_screenshot_capture_test.dart
//      RECTIFY_CAPTURE_RAW_SCREENSHOTS=1 RECTIFY_CAPTURE_FRAME=life-events \
//        flutter test test/tool/raw_screenshot_capture_test.dart
//    Each opt-in run flushes its PNG, then times out (expected); verify the
//    file on disk afterward.
//  * Every write is routed through `captureRawScreenshotPath`, which defaults
//    to the safe draft folder and refuses English canonical overwrites,
//    unsupported locales, and localized files outside the missing-frame plan.

// This harness interleaves calculation-flow controller writes with widget
// navigation taps; cascading across that boundary obscures intent.
// ignore_for_file: cascade_invocations

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/life_events_screen.dart';
import 'package:rectify/features/calculation_flow/screens/time_window_screen.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/l10n/app_localizations.dart';
import 'package:rectify/l10n/app_localizations_de.dart';
import 'package:rectify/l10n/app_localizations_en.dart';
import 'package:rectify/l10n/app_localizations_es.dart';
import 'package:rectify/l10n/app_localizations_fr.dart';
import 'package:rectify/l10n/app_localizations_pt.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_history_repository.dart';
import '../helpers/fake_rectification_repository.dart';
import 'raw_screenshot_capture.dart';
import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_repo_state.dart';

/// PNG file signature (first four bytes).
const List<int> _pngMagic = <int>[0x89, 0x50, 0x4E, 0x47];

/// iPhone 6.7" portrait device pixel ratio used for the store geometry.
const double _devicePixelRatio = 3;

/// Safe-area insets in PHYSICAL pixels, matching the canonical manifests'
/// `device.safeAreaPaddingPhysicalPx` so a draft frame is dimensionally and
/// chrome-wise consistent with the shipped raw set.
const double _safeTopPhysical = 177;
const double _safeBottomPhysical = 102;

/// Big-endian uint32 from a PNG IHDR width/height field. Pure byte math, so
/// verifying dimensions never triggers a second GPU image op.
int _pngUint32(Uint8List bytes, int offset) =>
    (bytes[offset] << 24) |
    (bytes[offset + 1] << 16) |
    (bytes[offset + 2] << 8) |
    bytes[offset + 3];

int _pngWidth(Uint8List bytes) => _pngUint32(bytes, 16);
int _pngHeight(Uint8List bytes) => _pngUint32(bytes, 20);

AppLocalizations _l10nForCaptureLocale(String captureLocale) =>
    switch (captureLocale) {
      'de' => AppLocalizationsDe(),
      'es' => AppLocalizationsEs(),
      'fr' => AppLocalizationsFr(),
      'pt-BR' => AppLocalizationsPt(),
      _ => AppLocalizationsEn(),
    };

/// Loads every family declared in the bundled `FontManifest.json` (product
/// text fonts AND the MaterialIcons / Lucide icon fonts) so the captured frame
/// renders real glyphs and real icons instead of the tofu boxes a plain
/// `flutter test` shows for icon fonts. `flutter_test_config.dart` only loads
/// the three text families; the icon families must be loaded here to match the
/// fidelity of the canonical `screenshots/store/<locale>` pack.
bool _allBundledFontsLoaded = false;
Future<void> _loadAllBundledFonts() async {
  if (_allBundledFontsLoaded) return;
  final manifest =
      jsonDecode(await rootBundle.loadString('FontManifest.json'))
          as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font
        in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
  _allBundledFontsLoaded = true;
}

Future<SharedPreferences> _demoPrefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': true,
  });
  return SharedPreferences.getInstance();
}

/// Pumps the shipped app offline at the 1290x2796 store geometry, drives
/// Demo-mode state through the real calculation-flow controller and go_router
/// to [frame]'s screen, and returns the root [RenderRepaintBoundary] ready to
/// capture. Performs no `toImage` and writes nothing.
Future<RenderRepaintBoundary> _pumpFrame(
  WidgetTester tester,
  RawCaptureFrame frame,
  String captureLocale,
) async {
  await _loadAllBundledFonts();
  if (captureLocale != kRawCaptureDraftDirName) {
    final appLocale = captureLocale == 'pt-BR' ? 'pt' : captureLocale;
    tester.platformDispatcher.localesTestValue = <ui.Locale>[
      ui.Locale(appLocale),
    ];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  }
  tester.view
    ..physicalSize = Size(
      kRawScreenshotWidth.toDouble(),
      kRawScreenshotHeight.toDouble(),
    )
    ..devicePixelRatio = _devicePixelRatio
    ..padding = const FakeViewPadding(
      top: _safeTopPhysical,
      bottom: _safeBottomPhysical,
    );
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPadding);

  final boundaryKey = GlobalKey();
  final history = FakeHistoryRepository();
  final rectifier = FakeRectificationRepository(history: history);
  final drafts = InMemoryDraftRepository();
  addTearDown(drafts.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(await _demoPrefs()),
        secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
        historyRepositoryProvider.overrideWithValue(history),
        rectificationRepositoryProvider.overrideWithValue(rectifier),
        draftRepositoryProvider.overrideWithValue(drafts),
      ],
      child: RepaintBoundary(
        key: boundaryKey,
        child: const RectifyApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await _driveToFrame(tester, frame, captureLocale);
  await tester.pumpAndSettle();

  return boundaryKey.currentContext!.findRenderObject()!
      as RenderRepaintBoundary;
}

/// Navigates the shipped flow to the screen [frame] captures and seeds the
/// realistic Demo-mode state each frame should show.
Future<void> _driveToFrame(
  WidgetTester tester,
  RawCaptureFrame frame,
  String captureLocale,
) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  final l10n = _l10nForCaptureLocale(captureLocale);

  // Home -> birth-data step.
  await tester.tap(find.text(l10n.homeNewCalculation));
  await tester.pumpAndSettle();

  final controller = container.read(
    calculationFlowControllerProvider.notifier,
  );
  controller
    ..setBirthDate(DateTime.utc(1990, 5, 14))
    ..setBirthCityText('Kyiv, Ukraine');
  await tester.pumpAndSettle();

  // Birth -> time-window step (the problem-hook frame stops here).
  await tester.tap(find.text(l10n.commonContinue));
  await tester.pumpAndSettle();

  switch (frame.id) {
    case 'problem-hook':
      expect(find.byType(TimeWindowScreen), findsOneWidget);
    case 'life-events':
      // Window -> life-events step, then seed five remembered events so the
      // screen shows the populated, recommended state (not the empty hint).
      await tester.tap(find.text(l10n.commonContinue));
      await tester.pumpAndSettle();
      controller
        ..addEvent(category: EventCategory.education, year: 2008)
        ..addEvent(category: EventCategory.relocation, year: 2012)
        ..addEvent(category: EventCategory.careerChange, year: 2015, month: 9)
        ..addEvent(category: EventCategory.marriage, year: 2018, month: 6)
        ..addEvent(category: EventCategory.childBirth, year: 2021, month: 3);
      await tester.pumpAndSettle();
      expect(find.byType(LifeEventsScreen), findsOneWidget);
    default:
      throw StateError('No capture route for frame id "${frame.id}".');
  }
}

/// Verifies every canonical pack holds the two current-plan frames that were
/// originally captured in the English draft folder and later localized.
void _expectCanonicalPacksInExpectedState() {
  final finalizedEnglishNames = expectedFinalFrameFiles
      .where(
        (name) => name == '01-problem-hook.png' || name == '02-life-events.png',
      )
      .toSet();
  for (final locale in supportedStoreLocales) {
    final pack = Directory('$kStoreScreenshotsRoot/$locale');
    if (!pack.existsSync()) continue;
    final currentPlanFiles = pack
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last)
        .where(finalizedEnglishNames.contains)
        .toList();
    expect(
      currentPlanFiles,
      unorderedEquals(finalizedEnglishNames),
      reason: '$locale current-plan raw frames',
    );
  }
}

void main() {
  testWidgets(
    'renders the shipped UI at store geometry; captures a draft frame only on '
    'explicit opt-in',
    (tester) async {
      final env = Platform.environment;
      final enabled = captureWritesEnabled(env);

      final frame = enabled
          ? (captureFrameById(requestedCaptureFrameId(env) ?? '') ??
                (throw StateError(
                  '$kCaptureFrameEnv must name a known frame: '
                  '${kMissingCurrentPlanFrames.map((f) => f.id).toList()}',
                )))
          // Default (CI) run renders the first plan frame as a wiring check.
          : kMissingCurrentPlanFrames.first;
      final captureLocale = requestedCaptureLocale(env);

      final boundary = await _pumpFrame(tester, frame, captureLocale);

      // Wiring proof (both modes): the capture surface is the exact store
      // geometry, so a capture would encode at 1290x2796.
      expect(boundary.size.width * _devicePixelRatio, kRawScreenshotWidth);
      expect(boundary.size.height * _devicePixelRatio, kRawScreenshotHeight);

      final relPath = captureRawScreenshotPath(
        locale: captureLocale,
        fileName: frame.fileName,
      );

      if (!enabled) {
        // Default: never run the finalization-hanging toImage, never write.
        _expectCanonicalPacksInExpectedState();
        return;
      }

      // Opt-in only: encode the single frame and flush it to the draft folder
      // synchronously, before the documented finalization hang/timeout.
      final image = await boundary.toImage(pixelRatio: _devicePixelRatio);
      final Uint8List bytes;
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) {
          throw StateError('Raw frame "${frame.id}" encoded to no bytes.');
        }
        bytes = data.buffer.asUint8List();
      } finally {
        image.dispose();
      }

      expect(bytes.sublist(0, 4), _pngMagic);
      expect(_pngWidth(bytes), kRawScreenshotWidth);
      expect(_pngHeight(bytes), kRawScreenshotHeight);

      File(relPath)
        ..parent.createSync(recursive: true)
        ..writeAsBytesSync(bytes, flush: true);
      expect(File(relPath).existsSync(), isTrue);
      _expectCanonicalPacksInExpectedState();
      // Surface the written path to the operator running the opt-in capture.
      // ignore: avoid_print
      print('Captured ${frame.id} -> $relPath (${bytes.length} bytes)');
    },
    timeout: const Timeout(Duration(seconds: 90)),
  );
}
