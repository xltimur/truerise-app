import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/features/onboarding/onboarding_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';

/// Onboarding screen — 3 slides per `docs/ascii-wireframes.md` Screen 1
/// and `docs/design-system.md` §10.6.
///
/// Slide 1: what is birth-time rectification.
/// Slide 2: how Rectify works.
/// Slide 3: two stacked CTAs ("Try demo first" / "Start real calculation");
///          no Skip on the final slide per §10.6.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _slideCount = 3;

  final PageController _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishAndGo() async {
    await ref.read(onboardingControllerProvider.notifier).complete();
    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  void _next() {
    if (_index < _slideCount - 1) {
      unawaited(
        _pageController.nextPage(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _slideCount - 1;

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        // 8pt minimum so the Skip affordance never sits flush against the
        // status bar / dynamic island on iPhones where SafeArea reports
        // zero top inset (Phase 8 visual polish).
        minimum: const EdgeInsets.only(top: AppSpacing.s2),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s2,
              ),
              child: SizedBox(
                height: 48,
                child: Row(
                  children: <Widget>[
                    const Spacer(),
                    if (!isLast)
                      GhostButton(
                        key: const ValueKey<String>('onboarding-skip'),
                        label: 'Skip',
                        onPressed: _finishAndGo,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                key: const ValueKey<String>('onboarding-pageview'),
                controller: _pageController,
                onPageChanged: (next) => setState(() => _index = next),
                children: const <Widget>[
                  _OnboardingSlide(
                    icon: LucideIcons.clock,
                    headline:
                        'Your birth chart depends on your exact '
                        'birth time.',
                    body:
                        'Most people only know an approximate time — '
                        'or nothing at all. Rectify narrows it down using '
                        'events from your life.',
                  ),
                  _OnboardingSlide(
                    icon: LucideIcons.listChecks,
                    headline: 'How Rectify works',
                    body:
                        '1. Enter your birth date and approximate time.\n'
                        '2. Add events from your life — marriage, job '
                        'changes, moves, more.\n'
                        '3. We calculate the most probable birth time '
                        'and show you why.\n\n'
                        'The more events you add, the more accurate '
                        'the result.',
                  ),
                  _OnboardingSlide(
                    icon: LucideIcons.compass,
                    headline: 'Ready to find your birth time?',
                    body:
                        'A demo shows you a sample result first, '
                        'with no account needed.',
                  ),
                ],
              ),
            ),
            _PageDots(count: _slideCount, current: _index),
            const SizedBox(height: AppSpacing.s6),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.s6,
              ),
              child: isLast
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PrimaryButton(
                          label: 'Try demo first',
                          onPressed: _finishAndGo,
                        ),
                        const SizedBox(height: AppSpacing.s3),
                        SecondaryButton(
                          label: 'Start real calculation',
                          onPressed: _finishAndGo,
                        ),
                      ],
                    )
                  : PrimaryButton(
                      label: 'Next',
                      onPressed: _next,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.icon,
    required this.headline,
    required this.body,
  });

  final IconData icon;
  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 64, color: AppColors.inkSoft),
          const SizedBox(height: AppSpacing.s7),
          Text(headline, style: AppTypography.displayLg),
          const SizedBox(height: AppSpacing.s4),
          Text(
            body,
            style: AppTypography.bodyLg.copyWith(color: AppColors.inkBody),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${current + 1} of $count',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < count; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 8,
                width: i == current ? 20 : 8,
                decoration: BoxDecoration(
                  color: i == current
                      ? AppColors.accentClay
                      : AppColors.inkFaint,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
