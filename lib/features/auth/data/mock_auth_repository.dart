import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/network/session_storage.dart';
import 'package:flutter_sanaa_app/features/auth/domain/auth_repository.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';

/// Login and email codes without a server, used until the backend sends the
/// mobile app API.
///
/// Test accounts (any email domain works):
/// - The part before "@" picks the role: `craftsman@test.com`, `institution@…`,
///   `contractor@…`. Anything else logs in as a customer.
/// - Password `Wrong123!` answers like a wrong password.
/// - An email that starts with `unverified` asks for email verification.
/// - The email code `123456` is correct; any other code is wrong.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._sessionStorage);

  final SessionStorage _sessionStorage;

  static const Duration _delay = Duration(milliseconds: 800);
  static const String _wrongPassword = 'Wrong123!';
  static const String _unverifiedPrefix = 'unverified';
  static const String _correctCode = '123456';

  @override
  Future<User> login({required String email, required String password}) async {
    await Future<void>.delayed(_delay);
    final cleanEmail = email.trim();

    if (password == _wrongPassword) {
      throw const UnauthorizedFailure(
        message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
      );
    }
    if (cleanEmail.startsWith(_unverifiedPrefix)) {
      throw const ServerFailure(statusCode: 403, requiresVerification: true);
    }
    return _startSession(cleanEmail);
  }

  @override
  Future<User?> savedUser() async {
    final token = await _sessionStorage.readToken();
    if (token == null) return null;
    return User.fromJson(await _sessionStorage.readUser());
  }

  @override
  Future<VerificationResult> verifyEmail({
    required String email,
    required String code,
    required VerificationPurpose purpose,
  }) async {
    await Future<void>.delayed(_delay);
    if (code != _correctCode) {
      throw const ServerFailure(
        statusCode: 422,
        message: 'رمز التحقق غير صحيح أو منتهي الصلاحية.',
      );
    }
    return switch (purpose) {
      VerificationPurpose.register => VerifiedSession(
        await _startSession(email.trim()),
      ),
      VerificationPurpose.reset => const ResetAllowed('mock-reset-token'),
    };
  }

  @override
  Future<void> resendCode({
    required String email,
    required VerificationPurpose purpose,
  }) => Future<void>.delayed(_delay);

  Future<User> _startSession(String email) async {
    final role = switch (UserRole.fromApi(email.split('@').first)) {
      UserRole.admin || null => UserRole.customer,
      final role => role,
    };
    final user = User(
      id: 1,
      fullName: 'مستخدم تجريبي',
      email: email,
      role: role,
    );
    await _sessionStorage.saveSession(token: 'mock-token', user: user.toJson());
    return user;
  }
}
