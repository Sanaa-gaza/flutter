import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';

class OutlinedAppButton extends StatelessWidget {
  /// Strong blue border with gradient text (e.g. the welcome screen).
  const OutlinedAppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSizes.buttonHeight,
  }) : _light = false;

  /// Very light border with plain blue text (e.g. "Back" on onboarding).
  const OutlinedAppButton.light({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSizes.buttonHeight,
  }) : _light = true;

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final bool _light;

  static const double _borderWidth = 2;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.button);
    final text = _light
        ? Text(
            label,
            style: AppTextStyles.button.copyWith(color: AppColors.primary),
          )
        : ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: AppColors.primaryButtonGradient.createShader,
            child: Text(label, style: AppTextStyles.button),
          );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: _light ? AppColors.iconSurface : AppColors.gradientStart,
            width: _borderWidth,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onPressed,
            child: Center(child: text),
          ),
        ),
      ),
    );
  }
}
