import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';
import 'package:flutter_sanaa_app/features/signup/domain/signup_repository.dart';

/// Step 1 of the institution signup. [PersonalInfo.fullName] holds the
/// institution name.
typedef InstitutionStep1 = ({
  PersonalInfo personalInfo,
  ReferenceItem activityType,
});

/// Step 1 (official info) plus step 2 (legal documents).
class InstitutionSignupRequest {
  const InstitutionSignupRequest({
    required this.step1,
    required this.commercialRegistrationNumber,
    required this.licenseFilePath,
    required this.description,
  });

  final InstitutionStep1 step1;
  final String commercialRegistrationNumber;

  /// Server path returned by [SignupRepository.uploadFile].
  final String licenseFilePath;
  final String description;
}
