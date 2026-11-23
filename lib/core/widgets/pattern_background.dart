import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';

/// The faint crafts pattern behind the splash and onboarding screens.
class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key, required this.child});

  final Widget child;

  static const double _opacity = 0.03;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: _opacity,
          child: Image.asset(AppImages.backgroundPattern, fit: BoxFit.cover),
        ),
        child,
      ],
    );
  }
}
