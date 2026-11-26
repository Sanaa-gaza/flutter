import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/core/utils/upload_picker.dart';
import 'package:flutter_sanaa_app/core/widgets/upload_source_sheet.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Asks camera, gallery or files, then picks and checks the file. Returns
/// null when nothing usable was chosen; [onError] gets the message to show
/// (or null to clear an old one). PDF is accepted only when [allowPdf].
Future<UploadPicked?> pickCheckedUpload(
  BuildContext context,
  WidgetRef ref, {
  required bool allowPdf,
  required ValueChanged<String?> onError,
}) async {
  final l10n = AppLocalizations.of(context);
  final source = await showUploadSourceSheet(context);
  if (source == null || !context.mounted) return null;

  final result = await ref
      .read(uploadPickerProvider)
      .pick(source, allowPdf: allowPdf);
  if (!context.mounted) return null;
  switch (result) {
    case UploadPicked():
      onError(null);
      return result;
    case UploadCancelled():
      return null;
    case UploadTooLarge():
      onError(l10n.photoTooLarge);
    case UploadUnsupportedType():
      onError(allowPdf ? l10n.fileUnsupportedType : l10n.photoUnsupportedType);
  }
  return null;
}
