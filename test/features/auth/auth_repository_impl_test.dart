import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/network/session_storage.dart';
import 'package:flutter_sanaa_app/features/auth/data/auth_repository_impl.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_adapter.dart';

const _userJson = {
  'id': 7,
  'full_name': 'Test User',
  'email': 'user@example.com',
  'role': 'craftsman',
};

void main() {
  late SessionStorage sessionStorage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    sessionStorage = SessionStorage(const FlutterSecureStorage());
  });

  AuthRepositoryImpl repository(FakeHttpAdapter adapter) =>
      AuthRepositoryImpl(fakeDio(adapter), sessionStorage);

  test('login sends the request and saves the session', () async {
    final adapter = FakeHttpAdapter(200, {
      'success': true,
      'data': {'token': 'abc123', 'user': _userJson},
    });

    final user = await repository(
      adapter,
    ).login(email: ' user@example.com ', password: 'Secret1!');

    expect(adapter.lastRequest?.path, '/auth/login');
    expect(adapter.lastRequest?.data, {
      'email': 'user@example.com',
      'password': 'Secret1!',
      'remember': true,
    });
    expect(user.role, UserRole.craftsman);
    expect(await sessionStorage.readToken(), 'abc123');
    expect(await sessionStorage.readUser(), _userJson);
  });

  test('the saved session never contains the password', () async {
    final adapter = FakeHttpAdapter(200, {
      'data': {'token': 'abc123', 'user': _userJson},
    });

    await repository(
      adapter,
    ).login(email: 'user@example.com', password: 'Secret1!');

    final saved = await const FlutterSecureStorage().readAll();
    expect(saved.values.any((value) => value.contains('Secret1!')), isFalse);
  });

  test('wrong password gives the server message', () async {
    final adapter = FakeHttpAdapter(401, {
      'message': 'Wrong email or password',
    });

    await expectLater(
      repository(adapter).login(email: 'a@b.com', password: 'x'),
      throwsA(
        isA<UnauthorizedFailure>().having(
          (failure) => failure.message,
          'message',
          'Wrong email or password',
        ),
      ),
    );
  });

  test('unverified email asks for verification', () async {
    final adapter = FakeHttpAdapter(403, {
      'message': 'Verify your email',
      'data': {'requires_verification': true},
    });

    await expectLater(
      repository(adapter).login(email: 'a@b.com', password: 'x'),
      throwsA(
        isA<ServerFailure>().having(
          (failure) => failure.requiresVerification,
          'requiresVerification',
          isTrue,
        ),
      ),
    );
  });

  test('an unknown role is rejected and nothing is saved', () async {
    final adapter = FakeHttpAdapter(200, {
      'data': {
        'token': 'abc123',
        'user': {..._userJson, 'role': 'superuser'},
      },
    });

    await expectLater(
      repository(adapter).login(email: 'a@b.com', password: 'x'),
      throwsA(isA<ServerFailure>()),
    );
    expect(await sessionStorage.readToken(), isNull);
  });

  test('savedUser reads the session and clears a broken one', () async {
    await sessionStorage.saveSession(token: 't', user: _userJson);
    final saved = await repository(FakeHttpAdapter(200, {})).savedUser();
    expect(saved?.id, 7);

    await sessionStorage.saveSession(token: 't', user: {'id': 'bad'});
    expect(await repository(FakeHttpAdapter(200, {})).savedUser(), isNull);
    expect(await sessionStorage.readToken(), isNull);
  });
}
