import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/photo_picker.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Asks "camera or gallery?". Returns null when the sheet is closed.
Future<PhotoSource?> showPhotoSourceSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);

  return showModalBottomSheet<PhotoSource>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              Icons.photo_camera_outlined,
              color: AppColors.primary,
            ),
            title: Text(l10n.photoFromCamera, style: AppTextStyles.body),
            onTap: () => Navigator.pop(context, PhotoSource.camera),
          ),
          ListTile(
            leading: const Icon(
              Icons.photo_library_outlined,
              color: AppColors.primary,
            ),
            title: Text(l10n.photoFromGallery, style: AppTextStyles.body),
            onTap: () => Navigator.pop(context, PhotoSource.gallery),
          ),
        ],
      ),
    ),
  );
}
