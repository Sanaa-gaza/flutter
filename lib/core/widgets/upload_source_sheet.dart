import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/upload_picker.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Asks where the file comes from: camera, gallery or files (Drive).
/// Returns null when the sheet is closed.
Future<UploadSource?> showUploadSourceSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);

  Widget option(IconData icon, String label, UploadSource source) => ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(label, style: AppTextStyles.body),
    onTap: () => Navigator.pop(context, source),
  );

  return showModalBottomSheet<UploadSource>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          option(
            Icons.photo_camera_outlined,
            l10n.photoFromCamera,
            UploadSource.camera,
          ),
          option(
            Icons.photo_library_outlined,
            l10n.photoFromGallery,
            UploadSource.gallery,
          ),
          option(
            Icons.folder_open_outlined,
            l10n.uploadFromFiles,
            UploadSource.files,
          ),
        ],
      ),
    ),
  );
}
