import 'package:flutter_sanaa_app/features/signup/domain/customer_signup_request.dart';

abstract interface class SignupRepository {
  /// Creates the account; the server then emails a verification code.
  /// Throws a `Failure` on error. Field errors use these keys: `full_name`,
  /// `phone`, `email`, `password`, `governorate_id`, `address`.
  Future<void> registerCustomer(CustomerSignupRequest request);
}
