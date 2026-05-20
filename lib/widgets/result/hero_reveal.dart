import 'dart:async';

import 'package:flutter/material.dart';

/// One-shot reveal animation for the hero result card
/// (`docs/implementation-plan.md` §16 AC-Demo-3,
/// `docs/design-system.md` §8.4 / §15).
///
/// 600ms fade + 8pt upward translate on first mount. Honors
/// `MediaQuery.disableAnimations` (iOS Reduce Motion / Android Remove
/// Animations) by snapping straight to the final state with no
/// transition.
@visibleForTesting
const Duration heroRevealDuration = Duration(milliseconds: 600);

@visibleForTesting
const double heroRevealTranslate = 8;

class HeroReveal extends StatefulWidget {
  const HeroReveal({required this.child, super.key});

  final Widget child;

  @override
  State<HeroReveal> createState() => _HeroRevealState();
}

class _HeroRevealState extends State<HeroReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: heroRevealDuration,
  );

  bool _scheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_scheduled) return;
    _scheduled = true;
    if (reduced) {
      _controller.value = 1;
    } else {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = Curves.easeOut.transform(_controller.value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, heroRevealTranslate * (1 - value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
