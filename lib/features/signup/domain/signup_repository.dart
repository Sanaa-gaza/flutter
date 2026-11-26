import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/domain/contractor_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/craftsman_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/institution_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';

/// Each method creates the account; the server then emails a verification
/// code. Throws a `Failure` on error. Field errors use these keys:
/// `full_name`, `phone`, `email`, `password`, `governorate_id`, `address`,
/// for the craftsman also `craft`, `custom_craft_name`, `bio`, and for the
/// institution also `activity_type`, `commercial_registration_number`,
/// `description`, and for the contractor also `national_id`,
/// `main_specialization`.
abstract interface class SignupRepository {
  /// Uploads a file picked on the phone (already checked: JPG/PNG/PDF, max
  /// 10MB) and returns its server path, to send with the signup request.
  Future<String> uploadFile(String localPath);

  Future<void> registerCustomer(PersonalInfo info);

  Future<void> registerCraftsman(CraftsmanSignupRequest request);

  /// Options of the "activity type" dropdown (institution and contractor).
  /// Not confirmed by the backend yet: the web uses a free text field.
  Future<List<ReferenceItem>> getActivityTypes();

  /// Options of the contractor "workers count" dropdown. Not confirmed by
  /// the backend yet: the web uses a number field.
  Future<List<ReferenceItem>> getWorkersCountOptions();

  Future<void> registerInstitution(InstitutionSignupRequest request);

  Future<void> registerContractor(ContractorSignupRequest request);
}
