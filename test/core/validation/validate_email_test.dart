import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/core/validation/validate_email.dart';

void main() {
  String emailErrorStr = emailErrorString;
  group('validateEmail', () {
    test('should return null for a valid email', () {
      expect(validateEmail("test@example.com"), null);
      expect(validateEmail("user.name@domain.co"), null);
      expect(validateEmail("my-email123@test.org"), null);
    });

    test('should return error for empty email', () {
      expect(validateEmail(""), emailErrorStr);
    });

    test('should return error for missing "@" symbol', () {
      expect(validateEmail("testexample.com"), emailErrorStr);
    });

    test('should return error for missing domain', () {
      expect(validateEmail("test@"), emailErrorStr);
    });

    test('should return error for missing username', () {
      expect(validateEmail("@example.com"), emailErrorStr);
    });

    test('should return error for missing top-level domain', () {
      expect(validateEmail("user@example"),emailErrorStr);
    });

    test('should return error for spaces in email', () {
      expect(validateEmail("user @example.com"), emailErrorStr);
      expect(validateEmail("user@ example.com"), emailErrorStr);
    });

    test('should return error for special characters in invalid places', () {
      expect(validateEmail("user@@example.com"), emailErrorStr);
      expect(validateEmail("user#email.com"), emailErrorStr);
    });
  });
}