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
import 'package:rectify/data/prefs/result_feedback_store.dart';
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

part 'result_screen_sections.dart';

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
const Key resultConfidenceExplainerKey = ValueKey<String>(
  'result-confidence-explainer',
);

@visibleForTesting
const Key resultConfidenceExplainerTitleKey = ValueKey<String>(
  'result-confidence-explainer-title',
);

@visibleForTesting
const Key resultConfidenceExplainerBodyKey = ValueKey<String>(
  'result-confidence-explainer-body',
);

@visibleForTesting
const Key resultConfidenceExplainerMethodKey = ValueKey<String>(
  'result-confidence-explainer-method',
);

@visibleForTesting
const Key resultDemoSharePromptKey = ValueKey<String>(
  'result-demo-share-prompt',
);

@visibleForTesting
const Key resultDemoSharePromptShareKey = ValueKey<String>(
  'result-demo-share-prompt-share',
);

@visibleForTesting
const Key resultFeedbackPromptKey = ValueKey<String>('result-feedback-prompt');

@visibleForTesting
const Key resultFeedbackYesKey = ValueKey<String>('result-feedback-yes');

@visibleForTesting
const Key resultFeedbackNotSureKey = ValueKey<String>(
  'result-feedback-not-sure',
);

@visibleForTesting
const Key resultFeedbackNoKey = ValueKey<String>('result-feedback-no');

@visibleForTesting
const Key resultFeedbackSavedKey = ValueKey<String>('result-feedback-saved');

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
      localeName: l10n.localeName,
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
          const SizedBox(height: AppSpacing.s3),
          const _ConfidenceExplainer(key: resultConfidenceExplainerKey),
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
                    localeName: l10n.localeName,
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
          _ResultFeedbackPrompt(
            key: resultFeedbackPromptKey,
            resultId: saved.request.id,
          ),
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
