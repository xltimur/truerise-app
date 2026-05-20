import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';

/// Breath-ring indeterminate loader (`docs/design-system.md` §9.11.2).
///
/// 64pt ring, 1.5pt stroke in clay with the lower half darker
/// (`accent.clay.deep`), rotating one full turn over 2.4s. Used on
/// the full-screen calculation loader. Respects
/// `MediaQuery.disableAnimations` (§8.4) by holding still.
class BreathRingLoader extends StatefulWidget {
  const BreathRingLoader({
    this.size = 64,
    this.strokeWidth = 1.5,
    this.semanticsLabel = 'Calculating',
    super.key,
  });

  final double size;
  final double strokeWidth;
  final String semanticsLabel;

  @override
  State<BreathRingLoader> createState() => _BreathRingLoaderState();
}

class _BreathRingLoaderState extends State<BreathRingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  bool _animationsDisabled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disabled = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disabled != _animationsDisabled) {
      _animationsDisabled = disabled;
      if (_animationsDisabled) {
        _controller
          ..stop()
          ..value = 0;
      } else if (!_controller.isAnimating) {
        unawaited(_controller.repeat());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel,
      liveRegion: true,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: CustomPaint(
              painter: _BreathRingPainter(strokeWidth: widget.strokeWidth),
            ),
          ),
        ),
      ),
    );
  }
}

class _BreathRingPainter extends CustomPainter {
  _BreathRingPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final topPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = AppColors.accentClay;
    canvas.drawArc(rect, math.pi, math.pi, false, topPaint);

    final bottomPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = AppColors.accentClayDeep;
    canvas.drawArc(rect, 0, math.pi, false, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant _BreathRingPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth;
}
