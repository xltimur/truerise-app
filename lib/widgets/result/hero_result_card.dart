import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/typography.dart';

/// Test-only key for the hero time row.
@visibleForTesting
const Key heroTimeKey = ValueKey<String>('hero-result-card-time');

/// The single most decorated component in the product
/// (`docs/design-system.md` §9.7).
///
/// Deep-midnight surface, 28pt radius, 32pt padding all sides.
/// Renders: clay-tint eyebrow, the time (mono numerals + serif AM/PM),
/// and the rising-sign caption.
class HeroResultCard extends StatelessWidget {
  const HeroResultCard({
    required this.time,
    required this.meridiem,
    required this.risingSign,
    this.eyebrow = 'YOUR MOST PROBABLE BIRTH TIME',
    this.zodiacGlyph,
    super.key,
  });

  /// The numeric time portion, e.g. `7:14`. Rendered in JetBrains Mono
  /// at `type.mono.xl` with tabular figures so wheel-style picker
  /// transitions don't reflow.
  final String time;

  /// The meridiem suffix (e.g. `AM`, `PM`). Rendered in Source Serif 4.
  /// Pass an empty string for 24h formats.
  final String meridiem;

  /// Rising-sign caption (e.g. "Gemini Rising"). Type.title.md.
  final String risingSign;

  /// Eyebrow above the time. Defaults to the production copy from §9.7.
  final String eyebrow;

  /// Optional 16pt monochrome zodiac glyph rendered after [risingSign].
  /// Out-of-scope for MVP scaffolding; design-system §7.4 reserves
  /// one approved glyph here.
  final IconData? zodiacGlyph;

  @override
  Widget build(BuildContext context) {
    const ink = AppColors.deepInkOnMidnight;
    const eyebrowColor = AppColors.accentClayTint;

    final timeRow = Text.rich(
      key: heroTimeKey,
      textAlign: TextAlign.center,
      TextSpan(
        style: AppTypography.monoXl.copyWith(color: ink),
        children: <InlineSpan>[
          TextSpan(text: time),
          if (meridiem.isNotEmpty)
            TextSpan(
              text: ' $meridiem',
              style: AppTypography.displayXl.copyWith(color: ink),
            ),
        ],
      ),
    );

    return Semantics(
      header: true,
      label:
          '$eyebrow: $time${meridiem.isEmpty ? '' : ' $meridiem'}, '
          '$risingSign',
      excludeSemantics: true,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.deepMidnight,
          borderRadius: AppRadius.brXl,
          border: Border.all(
            color: const Color(0x0FFFFFFF),
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              eyebrow,
              textAlign: TextAlign.center,
              style: AppTypography.labelSm.copyWith(color: eyebrowColor),
            ),
            const SizedBox(height: 24),
            timeRow,
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  risingSign,
                  style: AppTypography.titleMd.copyWith(color: ink),
                ),
                if (zodiacGlyph != null) ...<Widget>[
                  const SizedBox(width: 8),
                  Icon(zodiacGlyph, size: 16, color: ink),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
