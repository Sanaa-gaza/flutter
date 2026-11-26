import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

sealed class PhotoPickResult {
  const PhotoPickResult();
}

final class PhotoPicked extends PhotoPickResult {
  const PhotoPicked(this.photo);

  final XFile photo;
}

/// The user closed the camera or gallery without choosing.
final class PhotoCancelled extends PhotoPickResult {
  const PhotoCancelled();
}

final class PhotoTooLarge extends PhotoPickResult {
  const PhotoTooLarge();
}

final class PhotoUnsupportedType extends PhotoPickResult {
  const PhotoUnsupportedType();
}

/// Picks a photo and checks it before upload: JPG or PNG, at most 10MB.
///
/// The photo is resized and re-compressed while picking, which keeps it small
/// and drops most metadata (EXIF). Removing every metadata field, GPS
/// included, is not guaranteed on all phones: revisit when real uploads start.
class PhotoPicker {
  PhotoPicker(this._picker);

  final ImagePicker _picker;

  static const int maxBytes = 10 * 1024 * 1024;
  static const double _maxDimension = 1600;
  static const int _quality = 85;
  static const Set<String> _allowedExtensions = {'jpg', 'jpeg', 'png'};

  Future<PhotoPickResult> pick(PhotoSource source) async {
    final photo = await _picker.pickImage(
      source: switch (source) {
        PhotoSource.camera => ImageSource.camera,
        PhotoSource.gallery => ImageSource.gallery,
      },
      maxWidth: _maxDimension,
      maxHeight: _maxDimension,
      imageQuality: _quality,
    );
    if (photo == null) return const PhotoCancelled();

    final extension = photo.name.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(extension)) {
      return const PhotoUnsupportedType();
    }
    if (await photo.length() > maxBytes) return const PhotoTooLarge();
    return PhotoPicked(photo);
  }
}

final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => PhotoPicker(ImagePicker()),
);
