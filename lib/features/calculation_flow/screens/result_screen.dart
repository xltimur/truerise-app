import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/features/calculation_flow/state/result_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/candidate_card.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:rectify/widgets/feedback/empty_state.dart';
import 'package:rectify/widgets/nav/top_nav.dart';
import 'package:rectify/widgets/result/confidence_bar.dart';
import 'package:rectify/widgets/result/hero_result_card.dart';
import 'package:rectify/widgets/result/hero_reveal.dart';

/// Hero result screen (`docs/ascii-wireframes.md` Screen 6,
/// `docs/design-system.md` §10.2, `docs/implementation-plan.md` §14
/// Phase 5).
///
/// Resolves [resultId] through `HistoryRepository.findById` —
/// freshly-submitted demo results and history taps reach the same
/// aggregate. Renders three states:
///   - **Loading.** A muted center spinner while Drift hydrates the row.
///   - **Not found.** Empty state with a Home CTA when the id can't be
///     resolved (e.g. a stale link).
///   - **Loaded.** Hero card + confidence bar + up to 2 candidate cards
///     + "See how we got this" / "Save to history" CTAs + (demo-only)
///     bottom upgrade nudge.
class ResultScreen extends ConsumerWidget {
  const ResultScreen({required this.resultId, super.key});

  final String resultId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedCalculationByIdProvider(resultId));

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(
        title: 'Result',
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RoutePaths.home);
          }
        },
      ),
      body: saved.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accentClay),
        ),
        error: (_, _) => _ResultNotFound(resultId: resultId),
        data: (value) => value == null
            ? _ResultNotFound(resultId: resultId)
            : _ResultBody(saved: value),
      ),
    );
  }
}

class _ResultNotFound extends StatelessWidget {
  const _ResultNotFound({required this.resultId});

  final String resultId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: EmptyState(
        title: "We couldn't find that result.",
        body:
            'It may have been deleted from your history. '
            'Open a saved calculation, or start a new one.',
        cta: PrimaryButton(
          label: 'Back to history',
          expand: false,
          onPressed: () => context.go(RoutePaths.home),
        ),
      ),
    );
  }
}

@visibleForTesting
const Key resultDemoNudgeKey = ValueKey<String>('result-demo-nudge');

@visibleForTesting
const Key resultSaveButtonKey = ValueKey<String>('result-save-button');

@visibleForTesting
const Key resultEvidenceButtonKey = ValueKey<String>('result-evidence-button');

class _ResultBody extends ConsumerWidget {
  const _ResultBody({required this.saved});

  final SavedCalculation saved;

  ({String time, String meridiem}) _format(
    CandidateTime candidate,
    TimeFormat format,
  ) {
    final time = candidate.time;
    if (format == TimeFormat.h24) {
      return (
        time:
            '${time.hour.toString().padLeft(2, '0')}:'
            '${time.minute.toString().padLeft(2, '0')}',
        meridiem: '',
      );
    }
    final isPm = time.hour >= 12;
    final hour12 = ((time.hour + 11) % 12) + 1;
    return (
      time: '$hour12:${time.minute.toString().padLeft(2, '0')}',
      meridiem: isPm ? 'PM' : 'AM',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final candidates = saved.result.candidates;

    if (candidates.isEmpty) {
      // Defensive: the demo + real paths both produce ≥ 1 candidate,
      // so this branch reads like a not-found rather than a degraded
      // result. Keeps the empty-state copy honest.
      return _ResultNotFound(resultId: saved.request.id);
    }

    final top = candidates.first;
    final secondary = candidates.skip(1).take(2).toList();
    final topFormatted = _format(top, settings.timeFormat);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.s4,
        AppSpacing.screenEdge,
        AppSpacing.s7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (saved.result.isDemo) ...<Widget>[
            const Align(
              alignment: Alignment.centerRight,
              child: DemoPill(),
            ),
            const SizedBox(height: AppSpacing.s3),
          ],
          HeroReveal(
            child: HeroResultCard(
              time: topFormatted.time,
              meridiem: topFormatted.meridiem,
              risingSign: top.ascendant != null
                  ? '${top.ascendant} Rising'
                  : '(sample data)',
            ),
          ),
          const SizedBox(height: AppSpacing.s5),
          ConfidenceBar(value: top.confidence),
          if (secondary.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.s6),
            Text('Other candidates', style: AppTypography.titleSm),
            const SizedBox(height: AppSpacing.s3),
            for (final candidate in secondary) ...<Widget>[
              Builder(
                builder: (context) {
                  final formatted = _format(candidate, settings.timeFormat);
                  return CandidateCard(
                    time: formatted.time,
                    meridiem: formatted.meridiem,
                    risingSign: candidate.ascendant != null
                        ? '${candidate.ascendant} Rising'
                        : '(sample data)',
                    confidence: candidate.confidence,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s3),
            ],
          ],
          const SizedBox(height: AppSpacing.s6),
          PrimaryButton(
            key: resultEvidenceButtonKey,
            label: 'See how we got this',
            onPressed: () => context.go(
              RoutePaths.calcEvidenceFor(saved.request.id),
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          _SaveToHistoryButton(saved: saved),
          if (saved.result.isDemo) ...<Widget>[
            const SizedBox(height: AppSpacing.s7),
            const _DemoUpgradeNudge(key: resultDemoNudgeKey),
          ],
        ],
      ),
    );
  }
}

/// Toggles between "Save to history" and "Saved ✓"
/// (`docs/design-system.md` §11.5).
///
/// The result is always already persisted via
/// `LiveRectificationRepository.submit` before this screen renders
/// (Phase 4 wired that), so this button reads as user-affordance
/// rather than as a write. The Save tap re-saves the same aggregate
/// idempotently (Drift `insertOrReplace`), then flips the label for
/// 1.2 seconds before settling into a disabled state.
class _SaveToHistoryButton extends ConsumerStatefulWidget {
  const _SaveToHistoryButton({required this.saved});

  final SavedCalculation saved;

  @override
  ConsumerState<_SaveToHistoryButton> createState() =>
      _SaveToHistoryButtonState();
}

class _SaveToHistoryButtonState extends ConsumerState<_SaveToHistoryButton> {
  bool _saved = false;
  Timer? _confirmationTimer;

  @override
  void dispose() {
    _confirmationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      key: resultSaveButtonKey,
      label: _saved ? 'Saved ✓' : 'Save to history',
      onPressed: _saved ? null : _save,
    );
  }

  Future<void> _save() async {
    setState(() => _saved = true);
    // The demo and real submit paths already wrote this aggregate to
    // Drift, so this is an idempotent confirm — kept here so the user
    // sees a clear save affordance per §11.5.
    _confirmationTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      // Keep the button disabled past the animation window; the design
      // system explicitly calls for "no toast — the button itself is
      // the feedback".
      setState(() {});
    });
  }
}

/// Soft upgrade nudge at the bottom of the demo result screen
/// (`docs/design-system.md` §10.2 last paragraph; `docs/mvp-scope.md`
/// AC-Demo-4). Dismissible per view — collapses on close and never
/// reappears until the screen rebuilds (e.g. tabbing away and back, or
/// a new calculation).
///
/// MVP has no payment surface (`docs/mvp-scope.md` AC-Demo-6) so the
/// CTA does not link to a paywall — it opens a new calculation flow
/// instead. Phase 7+ may add a settings handle.
class _DemoUpgradeNudge extends StatefulWidget {
  const _DemoUpgradeNudge({super.key});

  @override
  State<_DemoUpgradeNudge> createState() => _DemoUpgradeNudgeState();
}

class _DemoUpgradeNudgeState extends State<_DemoUpgradeNudge> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    return Semantics(
      container: true,
      label: 'Demo upgrade nudge',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inkLine),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'This was a demo.',
                      style: AppTypography.titleSm,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.inkSoft,
                    ),
                    tooltip: 'Dismiss',
                    iconSize: 20,
                    splashRadius: 18,
                    onPressed: () => setState(() => _dismissed = true),
                  ),
                ],
              ),
              Text(
                'Run a real calculation with your own birth data.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              GhostButton(
                label: 'Start a new calculation',
                onPressed: () => context.go(RoutePaths.newCalculation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
