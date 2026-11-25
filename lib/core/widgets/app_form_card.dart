import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';

/// The white card with a soft shadow that holds a form.
class AppFormCard extends StatelessWidget {
  const AppFormCard({super.key, required this.padding, required this.child});

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.formCardShadow,
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
