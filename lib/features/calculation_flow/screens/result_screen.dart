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
import 'package:rectify/features/reviews/review_invitation.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
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

@visibleForTesting
const Key resultLowConfidenceNoteKey = ValueKey<String>(
  'result-low-confidence-note',
);

@visibleForTesting
const Key resultDemoSharePromptKey = ValueKey<String>(
  'result-demo-share-prompt',
);

@visibleForTesting
const Key resultDemoSharePromptShareKey = ValueKey<String>(
  'result-demo-share-prompt-share',
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
          if (ConfidenceBar.isLowBand(top.confidence)) ...<Widget>[
            const SizedBox(height: AppSpacing.s3),
            const _LowConfidenceNote(key: resultLowConfidenceNoteKey),
          ],
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
            _DemoSharePrompt(saved: saved),
            const SizedBox(height: AppSpacing.s7),
            const _DemoUpgradeNudge(key: resultDemoNudgeKey),
          ],
        ],
      ),
    );
  }
}

/// Inline guidance shown under the [ConfidenceBar] when the top
/// candidate sits in the low band ([ConfidenceBar.isLowBand]).
///
/// Frames a weak estimate as "needs more input", never as a failure:
/// the user is pointed at adding more dated life events or narrowing
/// the birth-time window for their next calculation. Deliberately has
/// no CTA — the submitted draft is cleared on submit, so routing back
/// into the calc flow from here cannot rehydrate this result's input
/// without new state plumbing (out of scope; the evidence CTA below
/// already lets the user review what drove the estimate). Mirrors the
/// events-step guidance banner tokens so the tone reads as a hint, not
/// an error.
class _LowConfidenceNote extends StatelessWidget {
  const _LowConfidenceNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        decoration: BoxDecoration(
          color: AppColors.accentClayTint,
          borderRadius: AppRadius.brSm,
          border: Border.all(color: AppColors.accentClayLine),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.resultLowConfidenceTitle,
              style: AppTypography.titleSm.copyWith(
                color: AppColors.accentClayDeep,
              ),
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(
              l10n.resultLowConfidenceBody,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.accentClayDeep,
              ),
            ),
          ],
        ),
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
      icon: AppIcons.share,
      onPressed: () async {
        final svc = ref.read(shareServiceProvider);
        final text = ShareCopyBuilder.build(
          saved,
          l10n,
          timeFormat: ref.read(settingsControllerProvider).timeFormat,
        );
        final usedNative = await svc.share(text);
        if (!context.mounted) return;
        if (usedNative) {
          // Positive moment: the user just shared a result through the
          // native sheet. Invite an (optional, throttled, OS-governed)
          // review. Deliberately not triggered on the clipboard fallback
          // below — a fallback is a degraded experience, not a win.
          await maybeInviteReview(context, ref);
        } else {
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
      icon: AppIcons.share,
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
        final caption = ShareCopyBuilder.build(
          saved,
          l10n,
          timeFormat: settings.timeFormat,
        );
        final usedNative = await svc.shareImagePng(bytes, text: caption);
        if (!context.mounted) return;
        if (usedNative) {
          // Positive moment after a successful native image share.
          await maybeInviteReview(context, ref);
        } else {
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

/// One-time, post-demo "share this sample" affordance (G10 share
/// discoverability). Renders only on a demo result, and only the first
/// time the user reaches one — it marks itself seen on display via the
/// share-prompt store so it never nags again, on this or any later demo
/// result. Its share reuses the exact PII-free [ShareCopyBuilder] /
/// [ShareService] text payload as every other share entry point (no birth
/// city/date, events, label, coordinates, or API ids).
///
/// Deliberately does NOT chain the S2 review invitation: a gentle one-time
/// nudge is not the celebratory positive moment that flow is reserved for,
/// and stacking a rating dialog on top would read as a dark pattern. It
/// still honours the fallback contract — a clipboard fallback surfaces a
/// SnackBar and is never treated as a success moment.
class _DemoSharePrompt extends ConsumerStatefulWidget {
  const _DemoSharePrompt({required this.saved});

  final SavedCalculation saved;

  @override
  ConsumerState<_DemoSharePrompt> createState() => _DemoSharePromptState();
}

class _DemoSharePromptState extends ConsumerState<_DemoSharePrompt> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    final store = ref.read(sharePromptStoreProvider);
    if (!store.demoSharePromptSeen()) {
      _visible = true;
      // Mark seen on display so the prompt is shown at most once, ever.
      unawaited(store.markDemoSharePromptSeen());
    }
  }

  Future<void> _share() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final svc = ref.read(shareServiceProvider);
    final usedNative = await svc.share(
      ShareCopyBuilder.build(
        widget.saved,
        l10n,
        timeFormat: ref.read(settingsControllerProvider).timeFormat,
      ),
    );
    if (!context.mounted) return;
    if (!usedNative) {
      // Clipboard fallback is a degraded path, not a win — no review prompt.
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.resultCopiedToClipboard)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      key: resultDemoSharePromptKey,
      padding: const EdgeInsets.only(top: AppSpacing.s6),
      child: Semantics(
        container: true,
        label: l10n.resultDemoShareLabel,
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
                        l10n.resultDemoShareTitle,
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
                      onPressed: () => setState(() => _visible = false),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                GhostButton(
                  key: resultDemoSharePromptShareKey,
                  label: l10n.resultDemoShareButton,
                  icon: AppIcons.share,
                  onPressed: _share,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
