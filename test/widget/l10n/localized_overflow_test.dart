import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/calculation_flow/widgets/add_event_sheet.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/widgets/cards/evidence_card.dart';
import 'package:rectify/widgets/feedback/error_scaffold.dart';
import 'package:rectify/widgets/inputs/inputs.dart' hide RadioGroup;
import 'package:rectify/widgets/inputs/radio_group.dart' as rectify;
import 'package:rectify/widgets/nav/bottom_tab_bar.dart';
import 'package:rectify/widgets/nav/stepper_header.dart';
import 'package:rectify/widgets/result/match_strength_dots.dart';

import '../../helpers/widget_test_harness.dart';

/// Localized UI overflow QA (D.2 — follow-up to the Tier 1 in-app
/// translations in 25063df).
///
/// German strings run ~20–35% longer than English, so every fixed or
/// tightly-constrained affordance is re-rendered here under German plus
/// a Romance locale (French) at the baseline scale and at Dynamic Type
/// ×1.3. Flutter throws `RenderFlex`/`RenderConstrainedBox` overflow
/// exceptions in test mode, and `tester.takeException()` surfaces them —
/// so a clean run proves the longer copy still fits the chrome.
///
/// Locales chosen per surface:
///   • de  — worst-case length for Germanic compounds.
///   • fr  — Romance check (article-heavy phrasing, e.g. "la clé").

/// The locales every surface must survive. `pt` shares Brazilian content
/// and tracks close to `es`/`fr` in length; `de` + `fr` bound the risk.
const _locales = <Locale>[Locale('de'), Locale('fr')];

/// Baseline plus the Dynamic Type step the design system commits to
/// (`docs/design-system.md` §15 — onboarding polish gate uses ×1.3).
const _scales = <TextScaler>[
  TextScaler.noScaling,
  TextScaler.linear(1.3),
];

/// Pump a widget under every (locale × scale) combination and assert the
/// frame raised no layout-overflow exception. The `build` callback
/// receives the localized [AppLocalizations] so tests can feed real
/// translated labels into label-taking widgets instead of hardcoding
/// strings that drift.
Future<void> _expectNoOverflow(
  WidgetTester tester, {
  required String surface,
  required Widget Function(BuildContext context, AppLocalizations l10n) build,
  Size size = const Size(360, 760),
}) async {
  for (final locale in _locales) {
    for (final scaler in _scales) {
      await tester.pumpWidget(
        wrapInRectifyApp(
          Builder(builder: (context) => build(context, context.l10n)),
          size: size,
          locale: locale,
          textScaler: scaler,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: '$surface overflowed in '
            '${locale.languageCode} @ scale '
            '${scaler == TextScaler.noScaling ? '1.0' : '1.3'}.',
      );
    }
  }
}

void main() {
  group('Bottom tab bar', () {
    testWidgets('three localized labels fit the 56pt slot', (tester) async {
      // Pin to a realistic phone width so the three Expanded slots are
      // ~120pt each — the constraint that makes "EINSTELLUNGEN" risky.
      for (final current in BottomTabDestination.values) {
        await _expectNoOverflow(
          tester,
          surface: 'BottomTabBar (${current.name})',
          build: (context, l10n) => Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 360,
              child: BottomTabBar(current: current, onSelect: (_) {}),
            ),
          ),
        );
      }
    });
  });

  group('Stepper header', () {
    testWidgets('STEP X OF N localized eyebrow fits one line', (tester) async {
      await _expectNoOverflow(
        tester,
        surface: 'StepperHeader',
        build: (context, l10n) => const SizedBox(
          width: 360,
          child: StepperHeader(currentStep: 2, totalSteps: 4),
        ),
      );
    });
  });

  group('Time-format radio group', () {
    testWidgets('12h / 24h option labels do not overflow', (tester) async {
      await _expectNoOverflow(
        tester,
        surface: 'RadioGroup (time format)',
        build: (context, l10n) => SizedBox(
          width: 360,
          child: rectify.RadioGroup<int>(
            value: 0,
            onChanged: (_) {},
            options: <rectify.RadioOption<int>>[
              rectify.RadioOption<int>(
                value: 0,
                label: l10n.settingsTimeFormat12,
              ),
              rectify.RadioOption<int>(
                value: 1,
                label: l10n.settingsTimeFormat24,
              ),
            ],
          ),
        ),
      );
    });
  });

  group('Date picker field', () {
    testWidgets('long localized category value stays in the chrome', (
      tester,
    ) async {
      await _expectNoOverflow(
        tester,
        surface: 'DatePickerField (category value)',
        build: (context, l10n) => SizedBox(
          width: 360,
          child: DatePickerField(
            label: l10n.addEventCategoryLabel,
            // Longest German category ("Schwere Krankheit / Operation").
            formattedValue: eventCategoryLabel(l10n, EventCategory.illness),
            placeholder: l10n.addEventChooseCategory,
            onTap: () {},
          ),
        ),
      );
    });

    testWidgets('side-by-side month/year pickers do not overflow', (
      tester,
    ) async {
      await _expectNoOverflow(
        tester,
        surface: 'DatePickerField (month/year row)',
        build: (context, l10n) => SizedBox(
          width: 360,
          child: Row(
            children: <Widget>[
              Expanded(
                child: DatePickerField(
                  label: l10n.addEventMonth,
                  placeholder: l10n.addEventMonth,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DatePickerField(
                  label: l10n.addEventYear,
                  placeholder: l10n.addEventYear,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      );
    });
  });

  group('Evidence card', () {
    testWidgets('long localized category + strength dots fit one row', (
      tester,
    ) async {
      await _expectNoOverflow(
        tester,
        surface: 'EvidenceCard',
        build: (context, l10n) => SizedBox(
          width: 360,
          child: EvidenceCard(
            icon: Icons.favorite,
            category: eventCategoryLabel(l10n, EventCategory.illness),
            date: 'Jan 2019',
            strength: MatchStrength.strong,
            explanation: l10n.evidenceNoEvidence,
          ),
        ),
      );
    });
  });

  group('Error scaffold', () {
    testWidgets('long German title + body fit the centered column', (
      tester,
    ) async {
      await _expectNoOverflow(
        tester,
        surface: 'ErrorScaffold (timeout)',
        build: (context, l10n) => ErrorScaffold(
          icon: Icons.error_outline,
          title: l10n.errorTimeoutTitle,
          description: l10n.errorTimeoutBody,
          primaryAction: PrimaryButtonStub(label: l10n.errorTryAgain),
          secondaryAction: PrimaryButtonStub(label: l10n.commonCancel),
        ),
      );
    });

    testWidgets('no-internet copy fits the centered column', (tester) async {
      await _expectNoOverflow(
        tester,
        surface: 'ErrorScaffold (no internet)',
        build: (context, l10n) => ErrorScaffold(
          icon: Icons.wifi_off,
          title: l10n.errorNoInternetTitle,
          description: l10n.errorNoInternetBody,
          primaryAction: PrimaryButtonStub(label: l10n.errorTryAgain),
        ),
      );
    });
  });

  group('Add-event sheet', () {
    testWidgets('localized add-event form renders without overflow', (
      tester,
    ) async {
      await _expectNoOverflow(
        tester,
        surface: 'AddEventSheet',
        build: (context, l10n) => const SizedBox(
          width: 360,
          child: AddEventSheet(),
        ),
      );
    });
  });
}

/// Minimal stand-in for a CTA so the ErrorScaffold tests don't depend on
/// the live button + its tap wiring — only its width behaviour matters
/// for overflow.
class PrimaryButtonStub extends StatelessWidget {
  const PrimaryButtonStub({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Center(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
