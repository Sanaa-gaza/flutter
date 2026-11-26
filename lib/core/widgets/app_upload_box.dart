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
    this.preview,
    this.errorText,
  });

  final String label;
  final VoidCallback? onTap;
  final String iconAsset;

  /// The chosen file (e.g. an image); it fills the box instead of the label.
  final Widget? preview;
  final String? errorText;

  static const double _iconToLabel = 6;
  static const double _errorTop = 6;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.card);

    final preview = this.preview;
    final error = errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: AppSizes.uploadBoxHeight,
          child: CustomPaint(
            foregroundPainter: _DashedBorderPainter(
              color: error == null ? AppColors.gradientStart : AppColors.error,
            ),
            child: Material(
              color: Colors.white,
              borderRadius: borderRadius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: preview != null
                    ? SizedBox.expand(child: preview)
                    : Column(
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
        ),
        if (error != null) ...[
          const SizedBox(height: _errorTop),
          Text(error, style: AppTextStyles.fieldError),
        ],
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  static const double _dashLength = 6;
  static const double _gapLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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
        canvas.drawPath(metric.extractPath(start, start + _dashLength), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
