import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';

/// Pulse-dot indeterminate loader (`docs/design-system.md` §9.11.1).
///
/// 12pt clay dot, pulsing 1.0 → 1.4 → 1.0 every 1.6s. Used for short,
/// in-line waits like city geocoding. Respects
/// `MediaQuery.disableAnimations` (§8.4) by holding the dot at rest scale.
class PulseDotLoader extends StatefulWidget {
  const PulseDotLoader({
    this.size = 12,
    this.color = AppColors.accentClay,
    this.semanticsLabel = 'Loading',
    super.key,
  });

  final double size;
  final Color color;
  final String semanticsLabel;

  @override
  State<PulseDotLoader> createState() => _PulseDotLoaderState();
}

class _PulseDotLoaderState extends State<PulseDotLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
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
        width: widget.size * 1.4,
        height: widget.size * 1.4,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              // Triangle wave: 0 → 0.5 → 1 mapped to 1.0 → 1.4 → 1.0.
              final t = _controller.value;
              final scale = 1 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
