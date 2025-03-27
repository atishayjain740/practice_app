import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/core/validation/validate_name.dart';

void main() {
  String defaultMinLengthErrorString = getMinLengthErrorString();
  String defaultMaxLengthErrorString = getMaxLengthErrorString();
  String invaledNameErrorString = getInvalidCharErrorString();

  group('validateName', () {
    test('should return null for a valid name', () {
      expect(validateName("Test"), null);
      expect(validateName("Test Test"), null);
    });

    test('should return error for name shorter than default minLength (3)', () {
      expect(validateName("Te"), defaultMinLengthErrorString);
      expect(validateName(""), defaultMinLengthErrorString);
    });

    test('should return error for name longer than default maxLength (50)', () {
      expect(
          validateName("A" * 51), defaultMaxLengthErrorString);
    });

    test('should return error for name containing numbers', () {
      expect(validateName("Test123"), invaledNameErrorString);
    });

    test('should return error for name containing special characters', () {
      expect(validateName("t'test"), invaledNameErrorString);
      expect(validateName("Test-Test"), invaledNameErrorString);
      expect(validateName("Test@test"), invaledNameErrorString);
    });

    test('should trim spaces and still validate correctly', () {
      expect(validateName("  Test  "), null);
      expect(validateName("  "), defaultMinLengthErrorString);
    });

    test('should work with custom min and max limits', () {
      int minLength = 2;
      int maxLength = 25;
      expect(validateName("Te", minLength: minLength), null); // Valid because min is 2
      expect(validateName("A", minLength: minLength), getMinLengthErrorString(minLength: minLength));
      expect(validateName("X" * 30, maxLength: maxLength), getMaxLengthErrorString(maxLength: 25));
    });
  });
}