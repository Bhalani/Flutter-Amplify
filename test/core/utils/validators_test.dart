import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error for empty', () {
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email(null), 'Email is required');
    });
    test('returns error for invalid', () {
      expect(Validators.email('foo'), 'Enter a valid email');
      expect(Validators.email('foo@bar'), 'Enter a valid email');
      expect(Validators.email('foo@bar.'), 'Enter a valid email');
      expect(Validators.email('foo@bar.c'), 'Enter a valid email');
    });
    test('returns null for valid', () {
      expect(Validators.email('foo@bar.com'), null);
      expect(Validators.email('john.doe@example.co.uk'), null);
    });
  });

  group('Validators.name', () {
    test('returns error for empty', () {
      expect(Validators.name(''), 'Name is required');
      expect(Validators.name(null), 'Name is required');
    });
    test('returns error for numbers', () {
      expect(Validators.name('John123'), 'Name must contain only letters');
    });
    test('returns null for valid', () {
      expect(Validators.name('John'), null);
      expect(Validators.name("O'Connor"), null);
      expect(Validators.name('Mary-Jane'), null);
    });
  });

  group('Validators.password', () {
    test('returns error for empty', () {
      expect(Validators.password(''), 'Password is required');
      expect(Validators.password(null), 'Password is required');
    });
    test('returns error for too short', () {
      expect(Validators.password('Short1!'),
          'Password must be at least 12 characters');
    });
    test('returns error for missing uppercase', () {
      expect(Validators.password('lowercase123!@#'),
          'Add at least one uppercase letter');
    });
    test('returns error for missing lowercase', () {
      expect(Validators.password('UPPERCASE123!@#'),
          'Add at least one lowercase letter');
    });
    test('returns error for missing number', () {
      expect(Validators.password('PasswordOnly!@#'), 'Add at least one number');
    });
    test('returns error for missing special', () {
      expect(Validators.password('Password12345'),
          'Add at least one special character (!@#\$&*~_- )');
    });
    test('returns null for valid', () {
      expect(Validators.password('ValidPass123!'), null);
      expect(Validators.password('A1b2c3d4e5!@#'), null);
    });
  });

  group('Validators.code', () {
    test('returns error for empty', () {
      expect(Validators.code(''), 'Enter the verification code');
      expect(Validators.code(null), 'Enter the verification code');
    });
    test('returns error for non-numeric', () {
      expect(Validators.code('abc'), 'Code must be numbers only');
      expect(Validators.code('123abc'), 'Code must be numbers only');
    });
    test('returns null for valid', () {
      expect(Validators.code('123456'), null);
    });
  });

  group('Validators.passwordStrength', () {
    test('returns correct strength', () {
      expect(Validators.passwordStrength(''), 0);
      expect(Validators.passwordStrength('short'), 0);
      expect(Validators.passwordStrength('longenoughpassword'), 1);
      expect(Validators.passwordStrength('Longenoughpassword'), 2);
      expect(Validators.passwordStrength('Longenoughpassword1'), 3);
      expect(Validators.passwordStrength('Longenoughpassword1!'), 4);
      expect(Validators.passwordStrength('ValidPass123!'), 5 / 5);
    });
  });
}
