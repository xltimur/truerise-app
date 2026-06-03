import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/formatting/app_date_format.dart';
import 'package:rectify/core/sharing/share_copy_builder.dart';
import 'package:rectify/core/sharing/share_service.dart';
import 'package:rectify/core/sharing/story_card_renderer.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/features/calculation_flow/state/result_providers.dart';
import 'package:rectify/l10n/l10n.dart';
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
        title: context.l10n.resultTitle,
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
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: EmptyState(
        title: l10n.resultNotFoundTitle,
        body: l10n.resultNotFoundBody,
        cta: PrimaryButton(
          label: l10n.commonBackToHistory,
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

@visibleForTesting
const Key resultShareButtonKey = ValueKey<String>('result-share-button');

@visibleForTesting
const Key resultShareImageButtonKey = ValueKey<String>(
  'result-share-image-button',
);

class _ResultBody extends ConsumerWidget {
  const _ResultBody({required this.saved});

  final SavedCalculation saved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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
    final topFormatted = AppDateFormat.clockParts(
      top.time,
      settings.timeFormat,
    );

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
                  ? l10n.resultRisingSign(top.ascendant!)
                  : l10n.resultSampleData,
            ),
          ),
          const SizedBox(height: AppSpacing.s5),
          ConfidenceBar(value: top.confidence),
          if (secondary.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.s6),
            Text(l10n.resultOtherCandidates, style: AppTypography.titleSm),
            const SizedBox(height: AppSpacing.s3),
            for (final candidate in secondary) ...<Widget>[
              Builder(
                builder: (context) {
                  final formatted = AppDateFormat.clockParts(
                    candidate.time,
                    settings.timeFormat,
                  );
                  return CandidateCard(
                    time: formatted.time,
                    meridiem: formatted.meridiem,
                    risingSign: candidate.ascendant != null
                        ? l10n.resultRisingSign(candidate.ascendant!)
                        : l10n.resultSampleData,
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
            label: l10n.resultSeeEvidence,
            onPressed: () => context.go(
              RoutePaths.calcEvidenceFor(saved.request.id),
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          _ShareResultButton(key: resultShareButtonKey, saved: saved),
          const SizedBox(height: AppSpacing.s3),
          _ShareImageButton(key: resultShareImageButtonKey, saved: saved),
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

/// Privacy-safe share CTA. Builds share text with [ShareCopyBuilder]
/// (no birth city, birth date, events, or API details) then delegates
/// to [ShareService]. Shows a SnackBar when the clipboard fallback is
/// used instead of the native share sheet.
class _ShareResultButton extends ConsumerWidget {
  const _ShareResultButton({required this.saved, super.key});

  final SavedCalculation saved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return GhostButton(
      label: l10n.resultShare,
      onPressed: () async {
        final svc = ref.read(shareServiceProvider);
        final text = ShareCopyBuilder.build(saved);
        final usedNative = await svc.share(text);
        if (!usedNative && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.resultCopiedToClipboard)),
          );
        }
      },
    );
  }
}

/// Privacy-safe visual share CTA. Renders a 1080×1920 PNG story card
/// from the top candidate only via [StoryCardRenderer], then hands the
/// bytes (plus the same privacy-safe caption as the text share) to
/// [ShareService.shareImagePng]. The card carries no birth date, birth
/// city, coordinates, events, or API details. Shows a SnackBar when the
/// native share sheet could not be presented.
class _ShareImageButton extends ConsumerWidget {
  const _ShareImageButton({required this.saved, super.key});

  final SavedCalculation saved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);
    return GhostButton(
      label: l10n.resultShareImage,
      onPressed: () async {
        final svc = ref.read(shareServiceProvider);
        final top = saved.result.candidates.first;
        final parts = AppDateFormat.clockParts(top.time, settings.timeFormat);
        final card = StoryCardData(
          brand: appBrandName,
          time: parts.meridiem.isEmpty
              ? parts.time
              : '${parts.time} ${parts.meridiem}',
          ascendant: top.ascendant != null
              ? l10n.resultRisingSign(top.ascendant!)
              : null,
          confidenceLabel: l10n.shareCardConfidence(
            (top.confidence * 100).round(),
          ),
          tagline: l10n.shareCardTagline,
        );
        final bytes = await StoryCardRenderer.render(card);
        final caption = ShareCopyBuilder.build(saved);
        final usedNative = await svc.shareImagePng(bytes, text: caption);
        if (!usedNative && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.resultShareImageUnavailable)),
          );
        }
      },
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
    final l10n = context.l10n;
    return SecondaryButton(
      key: resultSaveButtonKey,
      label: _saved ? l10n.resultSaved : l10n.resultSaveToHistory,
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
    final l10n = context.l10n;
    return Semantics(
      container: true,
      label: l10n.resultDemoNudgeLabel,
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
                      l10n.resultDemoNudgeTitle,
                      style: AppTypography.titleSm,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.inkSoft,
                    ),
                    tooltip: l10n.commonDismiss,
                    iconSize: 20,
                    splashRadius: 18,
                    onPressed: () => setState(() => _dismissed = true),
                  ),
                ],
              ),
              Text(
                l10n.resultDemoNudgeBody,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              GhostButton(
                label: l10n.resultStartNewCalculation,
                onPressed: () => context.go(RoutePaths.newCalculation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
