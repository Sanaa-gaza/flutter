import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';
import 'package:flutter_sanaa_app/features/signup/domain/signup_repository.dart';

/// Step 1 (personal info) plus step 2 (craft details) of the craftsman signup.
class CraftsmanSignupRequest {
  const CraftsmanSignupRequest({
    required this.personalInfo,
    required this.bio,
    required this.personalPhotoPath,
    required this.idSelfiePath,
    this.craftId,
    this.customCraftName,
  }) : assert(
         (craftId == null) != (customCraftName == null),
         'Send a craft from the list or a custom craft name, not both.',
       );

  final PersonalInfo personalInfo;

  /// A craft from the services list, or [customCraftName] for "Other".
  final int? craftId;
  final String? customCraftName;
  final String bio;

  /// Server paths returned by [SignupRepository.uploadFile].
  final String personalPhotoPath;
  final String idSelfiePath;
}
