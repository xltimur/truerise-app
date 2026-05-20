import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/nav/top_nav.dart';

/// In-app privacy copy (`docs/mvp-scope.md` AC4 — "the
/// provider's shared API key is **not** present in the app binary";
/// `docs/implementation-plan.md` §9.5 — "user-supplied Pro/Dev key
/// stored in `flutter_secure_storage` only"; §15.3 open question:
/// final policy URL deferred to Phase 8).
///
/// Renders a plain-language summary so the Settings row works the
/// moment Phase 7 ships, without depending on a Legal-team URL that
/// isn't ready yet. Phase 8 swaps this for the canonical hosted URL
/// via `url_launcher`.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(
        title: 'Privacy',
        onBack: context.canPop() ? () => context.pop() : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.s5,
          AppSpacing.screenEdge,
          AppSpacing.s8,
        ),
        children: <Widget>[
          Text(
            'What Rectify stores',
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          const _Body(
            'Everything you enter — birth date, birth city, life '
            'events, calculation results — is stored on this device '
            'only. Nothing is uploaded to a Rectify account, because '
            'we do not run user accounts. Deleting the app removes '
            'every byte of that data.',
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            'Optional API key',
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          const _Body(
            'Power users can paste their own provider API key in '
            'Settings. When set, that key lives in the platform '
            'keychain (iOS) or Keystore (Android) — it never enters '
            'the database, preferences, logs, or crash reports, and '
            'is never displayed back to you after you save it.',
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            'Demo mode',
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          const _Body(
            'Demo calculations run entirely on this device — no '
            'network calls are made and no key is used. Demo results '
            'are clearly labelled with a DEMO pill so they do not get '
            'mixed up with real readings.',
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            'Deleting your data',
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          const _Body(
            'The Settings screen has a "Delete all data" action that '
            'wipes the local database, every preference, and the '
            "secure-storage entry holding your API key (if you've "
            'set one). The wipe completes before the action returns; '
            'the app then sends you back to onboarding so you can '
            'confirm the reset.',
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            'Analytics and crash reporting',
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          const _Body(
            'This release of Rectify ships without an analytics SDK '
            'and without crash reporting. If a future release adds '
            'either, it will be disclosed here and limited to '
            'anonymous, non-identifying data.',
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyMd.copyWith(color: AppColors.inkBody),
    );
  }
}
