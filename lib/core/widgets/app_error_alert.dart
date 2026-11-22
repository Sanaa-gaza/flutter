import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';

/// A general error that does not belong to one field, e.g. the server
/// `message` or a network error.
class AppErrorAlert extends StatelessWidget {
  const AppErrorAlert({super.key, required this.message});

  final String message;

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const double _iconSize = 18;
  static const double _iconToText = 8;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: _padding,
        decoration: BoxDecoration(
          color: AppColors.errorSurface,
          border: Border.all(color: AppColors.error),
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline,
              size: _iconSize,
              color: AppColors.error,
            ),
            const SizedBox(width: _iconToText),
            Expanded(child: Text(message, style: AppTextStyles.errorAlert)),
          ],
        ),
      ),
    );
  }
}
