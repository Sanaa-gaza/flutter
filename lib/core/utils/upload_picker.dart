import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum UploadSource {
  camera,
  gallery,

  /// The phone's file manager, which also shows Google Drive.
  files,
}

sealed class UploadPickResult {
  const UploadPickResult();
}

final class UploadPicked extends UploadPickResult {
  const UploadPicked(this.file);

  final XFile file;

  bool get isPdf => file.name.toLowerCase().endsWith('.pdf');
}

/// The user closed the picker without choosing.
final class UploadCancelled extends UploadPickResult {
  const UploadCancelled();
}

final class UploadTooLarge extends UploadPickResult {
  const UploadTooLarge();
}

final class UploadUnsupportedType extends UploadPickResult {
  const UploadUnsupportedType();
}

/// Picks a file for upload and checks it: JPG or PNG (and PDF when
/// allowed), at most 10MB.
///
/// Camera and gallery photos are resized and re-compressed while picking,
/// which keeps them small and drops most metadata (EXIF). Files from the file
/// manager or Drive are sent as they are. Removing every metadata field, GPS
/// included, is not guaranteed: revisit when real uploads start.
class UploadPicker {
  UploadPicker(this._imagePicker);

  final ImagePicker _imagePicker;

  static const int maxBytes = 10 * 1024 * 1024;
  static const double _maxDimension = 1600;
  static const int _quality = 85;
  static const List<String> _imageExtensions = ['jpg', 'jpeg', 'png'];
  static const String _pdfExtension = 'pdf';

  Future<UploadPickResult> pick(
    UploadSource source, {
    required bool allowPdf,
  }) async {
    final allowed = [..._imageExtensions, if (allowPdf) _pdfExtension];
    final file = switch (source) {
      UploadSource.camera => await _pickImage(ImageSource.camera),
      UploadSource.gallery => await _pickImage(ImageSource.gallery),
      UploadSource.files => (await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: allowed,
      ))?.xFile,
    };
    if (file == null) return const UploadCancelled();

    final extension = file.name.split('.').last.toLowerCase();
    if (!allowed.contains(extension)) return const UploadUnsupportedType();
    if (await file.length() > maxBytes) return const UploadTooLarge();
    return UploadPicked(file);
  }

  Future<XFile?> _pickImage(ImageSource source) => _imagePicker.pickImage(
    source: source,
    maxWidth: _maxDimension,
    maxHeight: _maxDimension,
    imageQuality: _quality,
  );
}

final uploadPickerProvider = Provider<UploadPicker>(
  (ref) => UploadPicker(ImagePicker()),
);
