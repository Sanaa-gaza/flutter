import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';

/// Dots under the animation: the current page is a wide pill.
class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  static const double _height = 6;
  static const double _activeWidth = 31;
  static const double _gap = 5;
  static const Duration _duration = Duration(milliseconds: 250);

  static const LinearGradient _activeGradient = LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [AppColors.indicatorStart, AppColors.indicatorEnd],
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: _gap,
      children: [
        for (var index = 0; index < count; index++)
          AnimatedContainer(
            duration: _duration,
            curve: Curves.easeOut,
            width: index == currentIndex ? _activeWidth : _height,
            height: _height,
            decoration: BoxDecoration(
              color: index == currentIndex ? null : AppColors.indicatorInactive,
              gradient: index == currentIndex ? _activeGradient : null,
              borderRadius: BorderRadius.circular(_height / 2),
            ),
          ),
      ],
    );
  }
}
