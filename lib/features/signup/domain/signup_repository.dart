import 'package:flutter_sanaa_app/features/signup/domain/craftsman_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';

/// Each method creates the account; the server then emails a verification
/// code. Throws a `Failure` on error. Field errors use these keys:
/// `full_name`, `phone`, `email`, `password`, `governorate_id`, `address`,
/// and for the craftsman also `craft`, `custom_craft_name`, `bio`.
abstract interface class SignupRepository {
  Future<void> registerCustomer(PersonalInfo info);

  Future<void> registerCraftsman(CraftsmanSignupRequest request);
}
