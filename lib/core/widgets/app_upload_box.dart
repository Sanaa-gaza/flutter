import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppUploadBox extends StatelessWidget {
  const AppUploadBox({
    super.key,
    required this.label,
    required this.onTap,
    this.iconAsset = AppIcons.imageUp,
  });

  final String label;
  final VoidCallback? onTap;
  final String iconAsset;

  static const double _iconToLabel = 6;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.card);

    return SizedBox(
      width: double.infinity,
      height: AppSizes.uploadBoxHeight,
      child: CustomPaint(
        foregroundPainter: _DashedBorderPainter(),
        child: Material(
          color: Colors.white,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconAsset),
                const SizedBox(height: _iconToLabel),
                Text(label, style: AppTextStyles.uploadLabel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  static const double _dashLength = 6;
  static const double _gapLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gradientStart
      ..style = PaintingStyle.stroke;
    final border = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.card),
        ),
      );

    for (final metric in border.computeMetrics()) {
      for (
        double start = 0;
        start < metric.length;
        start += _dashLength + _gapLength
      ) {
        canvas.drawPath(
          metric.extractPath(start, start + _dashLength),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => false;
}
