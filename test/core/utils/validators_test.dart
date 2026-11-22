import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('email', () {
    test('empty or spaces only is required', () {
      expect(Validators.email(''), ValidationError.emailRequired);
      expect(Validators.email('   '), ValidationError.emailRequired);
    });

    test('wrong format is invalid', () {
      for (final value in [
        'name',
        'name@',
        'name@mail',
        '@mail.com',
        'a b@mail.com',
      ]) {
        expect(
          Validators.email(value),
          ValidationError.emailInvalid,
          reason: value,
        );
      }
    });

    test('valid email passes, outer spaces ignored', () {
      expect(Validators.email('name@example.com'), isNull);
      expect(Validators.email('  name@example.com  '), isNull);
    });
  });

  group('phone', () {
    test('empty is required', () {
      expect(Validators.phone(''), ValidationError.phoneRequired);
      expect(Validators.phone('  '), ValidationError.phoneRequired);
    });

    test('must start with 59 or 56 and have 9 digits', () {
      for (final value in [
        '12345',
        '579123456',
        '59912345',
        '5991234567',
        '59912345a',
      ]) {
        expect(
          Validators.phone(value),
          ValidationError.phoneInvalid,
          reason: value,
        );
      }
    });

    test('valid numbers pass, inner spaces ignored', () {
      expect(Validators.phone('599123456'), isNull);
      expect(Validators.phone('569123456'), isNull);
      expect(Validators.phone('599 123 456'), isNull);
    });

    test('cleanPhone removes every space', () {
      expect(Validators.cleanPhone(' 599 123  456 '), '599123456');
    });
  });

  group('password', () {
    test('empty is required', () {
      expect(Validators.password(''), ValidationError.passwordRequired);
    });

    test('missing any rule is weak', () {
      for (final value in [
        'Ab1!xyz',
        'abcdef1!',
        'ABCDEFG!',
        'Abcdefg!',
        'Abcdefg1',
      ]) {
        expect(
          Validators.password(value),
          ValidationError.passwordWeak,
          reason: value,
        );
      }
    });

    test('strong password passes', () {
      expect(Validators.password('Abcdef1!'), isNull);
      expect(Validators.password('Sanaa_2026'), isNull);
    });

    test('requirements report each rule', () {
      final requirements = PasswordRequirements('abc1');
      expect(requirements.hasLength, isFalse);
      expect(requirements.hasLetter, isTrue);
      expect(requirements.hasUppercase, isFalse);
      expect(requirements.hasNumber, isTrue);
      expect(requirements.hasSpecial, isFalse);
      expect(requirements.meetsAll, isFalse);
    });
  });

  group('confirmPassword', () {
    test('empty is required', () {
      expect(
        Validators.confirmPassword('', 'Abcdef1!'),
        ValidationError.confirmPasswordRequired,
      );
    });

    test('different value is a mismatch', () {
      expect(
        Validators.confirmPassword('Abcdef1?', 'Abcdef1!'),
        ValidationError.passwordMismatch,
      );
    });

    test('same value passes', () {
      expect(Validators.confirmPassword('Abcdef1!', 'Abcdef1!'), isNull);
    });
  });

  group('nationalId', () {
    test('empty is required', () {
      expect(Validators.nationalId(' '), ValidationError.idNumberRequired);
    });

    test('must be exactly 9 digits', () {
      for (final value in ['12345678', '1234567890', '12345678a']) {
        expect(
          Validators.nationalId(value),
          ValidationError.idNumberInvalid,
          reason: value,
        );
      }
      expect(Validators.nationalId('123456789'), isNull);
    });
  });

  group('workersCount', () {
    test('empty is required', () {
      expect(Validators.workersCount(''), ValidationError.teamSizeRequired);
    });

    test('must be a whole number above zero', () {
      for (final value in ['0', '05', '-3', '2.5', 'five']) {
        expect(
          Validators.workersCount(value),
          ValidationError.teamSizeInvalid,
          reason: value,
        );
      }
      expect(Validators.workersCount('12'), isNull);
    });
  });

  group('bio', () {
    test('empty is required', () {
      expect(Validators.bio('   '), ValidationError.bioRequired);
    });

    test('shorter than 10 characters after trim is too short', () {
      expect(Validators.bio('  short   '), ValidationError.bioMinLength);
    });

    test('10 characters or more passes', () {
      expect(Validators.bio('1234567890'), isNull);
    });
  });

  test('required checks after trim', () {
    expect(Validators.required('  '), ValidationError.fieldRequired);
    expect(Validators.required(' a '), isNull);
  });

  test('terms must be accepted', () {
    expect(Validators.terms(accepted: false), ValidationError.termsRequired);
    expect(Validators.terms(accepted: true), isNull);
  });
}
