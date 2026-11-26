import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';
import 'package:flutter_sanaa_app/features/signup/domain/signup_repository.dart';

/// Step 1 of the contractor signup. [PersonalInfo.fullName] holds the full
/// four-part name.
typedef ContractorStep1 = ({
  PersonalInfo personalInfo,
  String nationalId,
  ReferenceItem activityType,
});

/// Step 2: work info. [description] is optional (null when empty).
typedef ContractorStep2 = ({
  ReferenceItem workersCount,
  String mainSpecialization,
  String? description,
});

/// All three steps of the contractor signup.
class ContractorSignupRequest {
  const ContractorSignupRequest({
    required this.step1,
    required this.step2,
    required this.licenseFilePath,
  });

  final ContractorStep1 step1;
  final ContractorStep2 step2;

  /// Server path returned by [SignupRepository.uploadFile].
  final String licenseFilePath;
}
