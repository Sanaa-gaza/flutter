import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Plays a Lottie animation once each time its page becomes active.
class OnboardingAnimation extends StatefulWidget {
  const OnboardingAnimation({
    super.key,
    required this.asset,
    required this.isActive,
  });

  final String asset;
  final bool isActive;

  @override
  State<OnboardingAnimation> createState() => _OnboardingAnimationState();
}

class _OnboardingAnimationState extends State<OnboardingAnimation>
    with SingleTickerProviderStateMixin {
  static const double _maxSize = 360;

  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didUpdateWidget(OnboardingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) _play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play() {
    // The duration is only known after the file has loaded.
    if (_controller.duration != null) _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: _maxSize,
        maxHeight: _maxSize,
      ),
      child: Lottie.asset(
        widget.asset,
        controller: _controller,
        fit: BoxFit.contain,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          if (widget.isActive) _play();
        },
      ),
    );
  }
}
