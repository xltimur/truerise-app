import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/error_flow/error_routing.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:rectify/widgets/feedback/breath_ring_loader.dart';

const _rotatingCopyCount = 3;

const _rotationInterval = Duration(milliseconds: 3000);

/// Step 5 — the calculation loader (`docs/ascii-wireframes.md` Screen 5).
///
/// Phase 4 wired the submit; Phase 5 wires the post-success
/// `context.go('/calc/result/:id')` jump. The demo repository persists
/// the aggregate before this redirect fires, so the result screen
/// reads the freshly-saved row through `HistoryRepository.findById`.
class CalculationLoadingScreen extends ConsumerStatefulWidget {
  const CalculationLoadingScreen({super.key});

  @override
  ConsumerState<CalculationLoadingScreen> createState() =>
      _CalculationLoadingScreenState();
}

class _CalculationLoadingScreenState
    extends ConsumerState<CalculationLoadingScreen> {
  Timer? _rotator;
  int _copyIndex = 0;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _rotator = Timer.periodic(_rotationInterval, (_) {
      if (!mounted) return;
      setState(() => _copyIndex = (_copyIndex + 1) % _rotatingCopyCount);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _kickoff());
  }

  Future<void> _kickoff() async {
    if (_started) return;
    _started = true;
    final controller = ref.read(calculationFlowControllerProvider.notifier);
    final state = ref.read(calculationFlowControllerProvider);
    if (!state.readyToSubmit) {
      // Draft is incomplete — bounce back so the user finishes a step.
      if (!mounted) return;
      context.go(RoutePaths.calcConfirm);
      return;
    }
    // Capture the draft id before submit() clears it. The id is the
    // history primary key — same value the user will see in the URL.
    final resultId = state.id;
    final result = await controller.submit();
    if (!mounted) return;
    switch (result) {
      case Ok():
        controller.reset();
        context.go(RoutePaths.calcResultFor(resultId));
      case Err(:final failure):
        // Route into the matching Phase-6 error screen instead of
        // parking the user on the loader with prose; the draft stays
        // in [DraftRepository] so a retry re-enters /calc/loading
        // against the same submission.
        context.go(errorScreenForFailure(failure).path);
    }
  }

  @override
  void dispose() {
    _rotator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final flow = ref.watch(calculationFlowControllerProvider);
    final rotatingCopy = <String>[
      l10n.loadingRotating1,
      l10n.loadingRotating2,
      l10n.loadingRotating3,
    ];

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: AppSpacing.s4),
              if (flow.isDemo)
                const Align(
                  child: DemoPill(),
                ),
              const Spacer(),
              const BreathRingLoader(),
              const SizedBox(height: AppSpacing.s7),
              Text(
                flow.isDemo ? l10n.loadingDemoTitle : l10n.loadingTitle,
                style: AppTypography.titleMd,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: Text(
                  rotatingCopy[_copyIndex],
                  key: ValueKey<int>(_copyIndex),
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.inkSoft,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.s5),
              Text(
                l10n.loadingTakesUnder,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.inkSoft,
                ),
              ),
              const Spacer(),
              GhostButton(
                label: l10n.commonCancel,
                onPressed: () {
                  ref
                      .read(calculationFlowControllerProvider.notifier)
                      .goTo(CalculationFlowStep.confirm);
                  context.go(RoutePaths.calcConfirm);
                },
              ),
              const SizedBox(height: AppSpacing.s4),
            ],
          ),
        ),
      ),
    );
  }
}
