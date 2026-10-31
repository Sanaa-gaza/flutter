import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppStepIndicator extends StatelessWidget {
  const AppStepIndicator({
    super.key,
    required this.labels,
    required this.currentStep,
  });

  final List<String> labels;

  /// Zero-based index of the step the user is on.
  final int currentStep;

  static const double _circleToLabel = 8;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(child: _buildStep(index)),
      ],
    );
  }

  Widget _buildStep(int index) {
    final isReached = index <= currentStep;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: index == 0
                  ? const SizedBox.shrink()
                  : _StepLine(isActive: isReached),
            ),
            _StepCircle(
              number: index + 1,
              isCompleted: index < currentStep,
              isCurrent: index == currentStep,
            ),
            Expanded(
              child: index == labels.length - 1
                  ? const SizedBox.shrink()
                  : _StepLine(isActive: index < currentStep),
            ),
          ],
        ),
        const SizedBox(height: _circleToLabel),
        Text(
          labels[index],
          textAlign: TextAlign.center,
          style: AppTextStyles.stepLabel.copyWith(
            color: isReached ? AppColors.primary : AppColors.stepInactive,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: isActive ? AppColors.primary : AppColors.stepInactiveLine,
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.number,
    required this.isCompleted,
    required this.isCurrent,
  });

  final int number;
  final bool isCompleted;
  final bool isCurrent;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    final isFilled = isCompleted || isCurrent;

    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? AppColors.primary : null,
        border: isFilled ? null : Border.all(color: AppColors.stepInactive),
      ),
      child: isCompleted
          ? SvgPicture.asset(AppIcons.check, width: _size, height: _size)
          : Text(
              '$number',
              style: AppTextStyles.stepNumber.copyWith(
                color: isCurrent ? Colors.white : AppColors.stepInactiveLine,
              ),
            ),
    );
  }
}
