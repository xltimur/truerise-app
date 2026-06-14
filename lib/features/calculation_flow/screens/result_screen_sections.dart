// Private section widgets of the result screen, split out of
// `result_screen.dart` purely for file-size hygiene. Same library
// (`part of`), so behavior, keys, imports, and privacy notes are
// unchanged.
part of 'result_screen.dart';

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

/// Inline guidance shown under the [ConfidenceBar] when the top
/// candidate sits in the low band ([ConfidenceBar.isLowBand]).
///
/// Frames a weak estimate as "needs more input", never as a failure:
/// the user gets concrete next steps for their next calculation — more
/// dated life events, double-checking the birth input, or a wider
/// birth-time window. Deliberately has
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
    final tips = <String>[
      l10n.resultLowConfidenceTipEvents,
      l10n.resultLowConfidenceTipReviewInput,
      l10n.resultLowConfidenceTipWiderWindow,
    ];
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
            for (final tip in tips)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '• ',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.accentClayDeep,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.accentClayDeep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Compact explanation block under the [ConfidenceBar] (and below the
/// [_LowConfidenceNote] when present) telling the user what the
/// confidence percent means and, at a high level, how candidate times
/// are ranked.
///
/// Copy contract (G15/G16): strictly probabilistic — confidence is an
/// estimate of how strongly the user's dated life events support this
/// candidate relative to the other candidate times in the selected
/// birth-time window, and the transits + progressions scoring is framed
/// as method/tooling, never as absolute outcome claims or fortune-telling.
/// Quiet surface tokens (sunken background, no accent border) so it
/// reads as a footnote, not a warning — the clay-tinted low-confidence
/// note above keeps visual priority.
class _ConfidenceExplainer extends StatelessWidget {
  const _ConfidenceExplainer({super.key});

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
          color: AppColors.bgSurfaceSunken,
          borderRadius: AppRadius.brSm,
          border: Border.all(color: AppColors.inkLine),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.resultConfidenceExplainerTitle,
              key: resultConfidenceExplainerTitleKey,
              style: AppTypography.titleSm,
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(
              l10n.resultConfidenceExplainerBody,
              key: resultConfidenceExplainerBodyKey,
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              l10n.resultConfidenceExplainerMethod,
              key: resultConfidenceExplainerMethodKey,
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
          ],
        ),
      ),
    );
  }
}

/// Post-result "Does this time feel plausible?" prompt
/// (`docs/mvp-scope.md` S1 / feature-gap G18).
///
/// Local-only by design: a tap persists exactly `result id -> answer`
/// through [ResultFeedbackStore] — no network, analytics, or review
/// invitation rides on it. A previously recorded answer renders
/// pre-selected on first build, and any selection shows a quiet
/// inline "saved" confirmation instead of a toast. Choices live in a
/// [Wrap] so they reflow on narrow widths without overflowing.
class _ResultFeedbackPrompt extends ConsumerStatefulWidget {
  const _ResultFeedbackPrompt({required this.resultId, super.key});

  final String resultId;

  @override
  ConsumerState<_ResultFeedbackPrompt> createState() =>
      _ResultFeedbackPromptState();
}

class _ResultFeedbackPromptState extends ConsumerState<_ResultFeedbackPrompt> {
  ResultFeedbackAnswer? _answer;

  @override
  void initState() {
    super.initState();
    _answer = ref.read(resultFeedbackStoreProvider).read(widget.resultId);
  }

  @override
  void didUpdateWidget(_ResultFeedbackPrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resultId != widget.resultId) {
      _answer = ref.read(resultFeedbackStoreProvider).read(widget.resultId);
    }
  }

  Future<void> _select(ResultFeedbackAnswer answer) async {
    setState(() => _answer = answer);
    await ref.read(resultFeedbackStoreProvider).write(widget.resultId, answer);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      container: true,
      label: l10n.resultFeedbackLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: AppRadius.brMd,
          border: Border.all(color: AppColors.inkLine),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(l10n.resultFeedbackTitle, style: AppTypography.titleSm),
              const SizedBox(height: AppSpacing.s3),
              Wrap(
                spacing: AppSpacing.s2,
                runSpacing: AppSpacing.s2,
                children: <Widget>[
                  _FeedbackChoice(
                    key: resultFeedbackYesKey,
                    label: l10n.resultFeedbackYes,
                    selected: _answer == ResultFeedbackAnswer.yes,
                    onTap: () => _select(ResultFeedbackAnswer.yes),
                  ),
                  _FeedbackChoice(
                    key: resultFeedbackNotSureKey,
                    label: l10n.resultFeedbackNotSure,
                    selected: _answer == ResultFeedbackAnswer.notSure,
                    onTap: () => _select(ResultFeedbackAnswer.notSure),
                  ),
                  _FeedbackChoice(
                    key: resultFeedbackNoKey,
                    label: l10n.resultFeedbackNo,
                    selected: _answer == ResultFeedbackAnswer.no,
                    onTap: () => _select(ResultFeedbackAnswer.no),
                  ),
                ],
              ),
              if (_answer != null) ...<Widget>[
                const SizedBox(height: AppSpacing.s3),
                Text(
                  l10n.resultFeedbackSaved,
                  key: resultFeedbackSavedKey,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.statusSuccess,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// One tappable answer in [_ResultFeedbackPrompt]. Constrained to a
/// >= 44px hit target; the selected state mirrors the clay-tint
/// "selected" chip tokens (`docs/design-system.md` §9.5).
class _FeedbackChoice extends StatelessWidget {
  const _FeedbackChoice({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? AppColors.accentClayTint : AppColors.bgSurfaceSunken,
        borderRadius: AppRadius.brSm,
        child: InkWell(
          borderRadius: AppRadius.brSm,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.s3,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.brSm,
              border: Border.all(
                color: selected ? AppColors.accentClayLine : AppColors.inkLine,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.labelMd.copyWith(
                color: selected ? AppColors.accentClayDeep : AppColors.inkMuted,
              ),
            ),
          ),
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
