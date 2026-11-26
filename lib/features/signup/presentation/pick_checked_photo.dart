import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/core/utils/photo_picker.dart';
import 'package:flutter_sanaa_app/core/widgets/photo_source_sheet.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

/// Asks "camera or gallery?", then picks and checks the photo. Returns null
/// when nothing usable was chosen; [onError] gets the message to show (or
/// null to clear an old one).
Future<XFile?> pickCheckedPhoto(
  BuildContext context,
  WidgetRef ref, {
  required ValueChanged<String?> onError,
}) async {
  final l10n = AppLocalizations.of(context);
  final source = await showPhotoSourceSheet(context);
  if (source == null || !context.mounted) return null;

  final result = await ref.read(photoPickerProvider).pick(source);
  if (!context.mounted) return null;
  switch (result) {
    case PhotoPicked(:final photo):
      onError(null);
      return photo;
    case PhotoCancelled():
      return null;
    case PhotoTooLarge():
      onError(l10n.photoTooLarge);
    case PhotoUnsupportedType():
      onError(l10n.photoUnsupportedType);
  }
  return null;
}
