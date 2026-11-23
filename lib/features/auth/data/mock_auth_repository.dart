import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/network/session_storage.dart';
import 'package:flutter_sanaa_app/features/auth/domain/auth_repository.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';

/// Login without a server, used until the backend sends the mobile app API.
///
/// Test accounts (any email domain works):
/// - The part before "@" picks the role: `craftsman@test.com`, `institution@…`,
///   `contractor@…`. Anything else logs in as a customer.
/// - Password `Wrong123!` answers like a wrong password.
/// - An email that starts with `unverified` asks for email verification.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._sessionStorage);

  final SessionStorage _sessionStorage;

  static const Duration _delay = Duration(milliseconds: 800);
  static const String _wrongPassword = 'Wrong123!';
  static const String _unverifiedPrefix = 'unverified';

  @override
  Future<User> login({required String email, required String password}) async {
    await Future<void>.delayed(_delay);
    final cleanEmail = email.trim();
    final localPart = cleanEmail.split('@').first;

    if (password == _wrongPassword) {
      throw const UnauthorizedFailure(
        message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
      );
    }
    if (localPart.startsWith(_unverifiedPrefix)) {
      throw const ServerFailure(statusCode: 403, requiresVerification: true);
    }

    final role = switch (UserRole.fromApi(localPart)) {
      UserRole.admin || null => UserRole.customer,
      final role => role,
    };
    final user = User(
      id: 1,
      fullName: 'مستخدم تجريبي',
      email: cleanEmail,
      role: role,
    );
    await _sessionStorage.saveSession(token: 'mock-token', user: user.toJson());
    return user;
  }

  @override
  Future<User?> savedUser() async {
    final token = await _sessionStorage.readToken();
    if (token == null) return null;
    return User.fromJson(await _sessionStorage.readUser());
  }
}
