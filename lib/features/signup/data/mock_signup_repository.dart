import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/features/signup/domain/customer_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/signup_repository.dart';

/// Signup without a server, used until the backend sends the mobile app API.
///
/// Test cases: an email that starts with `taken` answers "email already
/// used" under the email field. Anything else succeeds.
class MockSignupRepository implements SignupRepository {
  static const Duration _delay = Duration(milliseconds: 800);
  static const String _takenPrefix = 'taken';

  @override
  Future<void> registerCustomer(CustomerSignupRequest request) async {
    await Future<void>.delayed(_delay);
    if (request.email.startsWith(_takenPrefix)) {
      throw const ServerFailure(
        statusCode: 422,
        fieldErrors: {'email': 'البريد الإلكتروني مستخدم مسبقاً.'},
      );
    }
  }
}
