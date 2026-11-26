import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';

/// Step 1 (personal info) plus step 2 (craft details) of the craftsman signup.
class CraftsmanSignupRequest {
  const CraftsmanSignupRequest({
    required this.personalInfo,
    required this.bio,
    this.craftId,
    this.customCraftName,
    this.personalPhotoPath,
    this.idSelfiePath,
  }) : assert(
         (craftId == null) != (customCraftName == null),
         'Send a craft from the list or a custom craft name, not both.',
       );

  final PersonalInfo personalInfo;

  /// A craft from the services list, or [customCraftName] for "Other".
  final int? craftId;
  final String? customCraftName;
  final String bio;

  // Server paths of the uploaded photos. They become required when photo
  // picking is added (image_picker is not installed yet).
  final String? personalPhotoPath;
  final String? idSelfiePath;
}
