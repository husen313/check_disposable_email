import 'package:check_disposable_email/check_disposable_email.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Disposable Email Validation Tests', () {
    test('Test Disposable Email Address - mailinator.com', () {
      const email = 'zen@mailinator.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'mailinator.com is a disposable domain');
    });

    test('Test Valid Email Address - gmail.com', () {
      const email = 'zen@gmail.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, true, reason: 'gmail.com is a valid domain');
    });

    test('Test Case-Insensitive Domain Matching - Uppercase', () {
      const email = 'user@MAILINATOR.COM';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Should detect disposable domain regardless of case');
    });

    test('Test Case-Insensitive Domain Matching - Mixed Case', () {
      const email = 'user@MaIlInAtOr.CoM';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Should detect disposable domain with mixed case');
    });

    test('Test Case-Insensitive Domain Matching - Valid Domain', () {
      const email = 'user@GMAIL.COM';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, true, reason: 'Valid domain should work regardless of case');
    });

    test('Test Email Format Validation - Missing @ Symbol', () {
      const email = 'invalidemail.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Email without @ should be invalid');
    });

    test('Test Email Format Validation - Multiple @ Symbols', () {
      const email = 'user@@domain.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Email with multiple @ should be invalid');
    });

    test('Test Email Format Validation - Empty Email', () {
      const email = '';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Empty email should be invalid');
    });

    test('Test Email Format Validation - Only Whitespace', () {
      const email = '   ';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Whitespace-only email should be invalid');
    });

    test('Test Email Format Validation - Missing Local Part', () {
      const email = '@domain.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Email without local part should be invalid');
    });

    test('Test Email Format Validation - Missing Domain Part', () {
      const email = 'user@';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Email without domain should be invalid');
    });

    test('Test Email Format Validation - Valid Email with Special Characters', () {
      const email = 'user.name+tag@example.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, true, reason: 'Email with special characters should be valid');
    });

    test('Test Email Format Validation - Email with Whitespace (should trim)', () {
      const email = '  user@gmail.com  ';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, true, reason: 'Email with whitespace should be trimmed and validated');
    });

    test('Test Email Format Validation - Domain with Consecutive Dots', () {
      const email = 'user@domain..com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Domain with consecutive dots should be invalid');
    });

    test('Test Email Format Validation - Domain Starting with Dot', () {
      const email = 'user@.domain.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Domain starting with dot should be invalid');
    });

    test('Test Email Format Validation - Domain Ending with Dot', () {
      const email = 'user@domain.com.';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: 'Domain ending with dot should be invalid');
    });

    test('Test Another Disposable Domain - 10minutemail.com', () {
      const email = 'test@10minutemail.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, false, reason: '10minutemail.com is a disposable domain');
    });

    test('Test Another Valid Domain - yahoo.com', () {
      const email = 'test@yahoo.com';
      final isValid = Disposable.instance.hasValidEmail(email);
      expect(isValid, true, reason: 'yahoo.com is a valid domain');
    });

    test('Test Performance - Multiple Calls (cached Set)', () {
      const email = 'user@gmail.com';

      // First call initializes the cache
      final firstCall = Disposable.instance.hasValidEmail(email);

      // Subsequent calls should use cached Set
      final secondCall = Disposable.instance.hasValidEmail(email);
      final thirdCall = Disposable.instance.hasValidEmail(email);

      expect(firstCall, true);
      expect(secondCall, true);
      expect(thirdCall, true);
      expect(firstCall, equals(secondCall));
      expect(secondCall, equals(thirdCall));
    });
  });

  group('Phase 2: EmailValidationResult Tests', () {
    test('Test validateEmail - Valid Non-Disposable Email', () {
      const email = 'user@gmail.com';
      final result = Disposable.instance.validateEmail(email);

      expect(result.isValid, true);
      expect(result.isDisposable, false);
      expect(result.isFormatValid, true);
      expect(result.domain, 'gmail.com');
      expect(result.errorMessage, isNull);
    });

    test('Test validateEmail - Disposable Email', () {
      const email = 'user@mailinator.com';
      final result = Disposable.instance.validateEmail(email);

      expect(result.isValid, false);
      expect(result.isDisposable, true);
      expect(result.isFormatValid, true);
      expect(result.domain, 'mailinator.com');
      expect(result.errorMessage, contains('disposable'));
    });

    test('Test validateEmail - Invalid Format (Missing @)', () {
      const email = 'invalidemail.com';
      final result = Disposable.instance.validateEmail(email);

      expect(result.isValid, false);
      expect(result.isDisposable, false);
      expect(result.isFormatValid, false);
      expect(result.domain, isNull);
      expect(result.errorMessage, contains('@ symbol'));
    });

    test('Test validateEmail - Null Input', () {
      final result = Disposable.instance.validateEmail(null);

      expect(result.isValid, false);
      expect(result.isDisposable, false);
      expect(result.isFormatValid, false);
      expect(result.domain, isNull);
      expect(result.errorMessage, contains('cannot be null'));
    });

    test('Test validateEmail - Empty String', () {
      final result = Disposable.instance.validateEmail('');

      expect(result.isValid, false);
      expect(result.isDisposable, false);
      expect(result.isFormatValid, false);
      expect(result.domain, isNull);
      expect(result.errorMessage, contains('cannot be empty'));
    });

    test('Test validateEmail - Whitespace Only', () {
      final result = Disposable.instance.validateEmail('   ');

      expect(result.isValid, false);
      expect(result.isDisposable, false);
      expect(result.isFormatValid, false);
      expect(result.domain, isNull);
      expect(result.errorMessage, contains('cannot be empty'));
    });

    test('Test validateEmail - Email Too Long', () {
      final longEmail = 'a' * 250 + '@example.com';
      final result = Disposable.instance.validateEmail(longEmail);

      expect(result.isValid, false);
      expect(result.isFormatValid, false);
      expect(result.errorMessage, contains('exceeds maximum length'));
    });

    test('Test validateEmail - Multiple @ Symbols', () {
      final result = Disposable.instance.validateEmail('user@@domain.com');

      expect(result.isValid, false);
      expect(result.isFormatValid, false);
      expect(result.errorMessage, contains('exactly one @ symbol'));
    });

    test('EmailValidationResult.valid factory', () {
      final result = EmailValidationResult.valid('gmail.com');

      expect(result.isValid, true);
      expect(result.isDisposable, false);
      expect(result.isFormatValid, true);
      expect(result.domain, 'gmail.com');
      expect(result.errorMessage, isNull);
    });

    test('EmailValidationResult.disposable factory', () {
      final result = EmailValidationResult.disposable('mailinator.com');

      expect(result.isValid, false);
      expect(result.isDisposable, true);
      expect(result.isFormatValid, true);
      expect(result.domain, 'mailinator.com');
      expect(result.errorMessage, contains('disposable'));
    });

    test('EmailValidationResult.invalidFormat factory', () {
      final result = EmailValidationResult.invalidFormat('Custom error');

      expect(result.isValid, false);
      expect(result.isDisposable, false);
      expect(result.isFormatValid, false);
      expect(result.domain, isNull);
      expect(result.errorMessage, 'Custom error');
    });

    test('EmailValidationResult equality', () {
      final result1 = EmailValidationResult.valid('gmail.com');
      final result2 = EmailValidationResult.valid('gmail.com');
      final result3 = EmailValidationResult.disposable('mailinator.com');

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('EmailValidationResult toString', () {
      final valid = EmailValidationResult.valid('gmail.com');
      final disposable = EmailValidationResult.disposable('mailinator.com');
      final invalid = EmailValidationResult.invalidFormat('Error');

      expect(valid.toString(), contains('valid: true'));
      expect(disposable.toString(), contains('disposable: true'));
      expect(invalid.toString(), contains('invalid: true'));
    });
  });

  group('Phase 2: extractDomain Tests', () {
    test('Test extractDomain - Valid Email', () {
      final domain = Disposable.instance.extractDomain('user@gmail.com');
      expect(domain, 'gmail.com');
    });

    test('Test extractDomain - Case Insensitive', () {
      final domain = Disposable.instance.extractDomain('user@GMAIL.COM');
      expect(domain, 'gmail.com');
    });

    test('Test extractDomain - Mixed Case', () {
      final domain = Disposable.instance.extractDomain('user@GmAiL.CoM');
      expect(domain, 'gmail.com');
    });

    test('Test extractDomain - With Whitespace', () {
      final domain = Disposable.instance.extractDomain('  user@gmail.com  ');
      expect(domain, 'gmail.com');
    });

    test('Test extractDomain - Null Input', () {
      final domain = Disposable.instance.extractDomain(null);
      expect(domain, isNull);
    });

    test('Test extractDomain - Empty String', () {
      final domain = Disposable.instance.extractDomain('');
      expect(domain, isNull);
    });

    test('Test extractDomain - Whitespace Only', () {
      final domain = Disposable.instance.extractDomain('   ');
      expect(domain, isNull);
    });

    test('Test extractDomain - Missing @ Symbol', () {
      final domain = Disposable.instance.extractDomain('invalidemail.com');
      expect(domain, isNull);
    });

    test('Test extractDomain - Multiple @ Symbols', () {
      final domain = Disposable.instance.extractDomain('user@@domain.com');
      expect(domain, isNull);
    });

    test('Test extractDomain - Missing Domain', () {
      final domain = Disposable.instance.extractDomain('user@');
      expect(domain, isNull);
    });

    test('Test extractDomain - Missing Local Part', () {
      final domain = Disposable.instance.extractDomain('@domain.com');
      expect(domain, 'domain.com');
    });

    test('Test extractDomain - Complex Domain', () {
      final domain = Disposable.instance.extractDomain('user@sub.domain.co.uk');
      expect(domain, 'sub.domain.co.uk');
    });
  });

  group('Phase 2: Null Handling Tests', () {
    test('hasValidEmail handles null', () {
      final result = Disposable.instance.hasValidEmail(null);
      expect(result, false);
    });

    test('validateEmail handles null', () {
      final result = Disposable.instance.validateEmail(null);
      expect(result.isValid, false);
      expect(result.errorMessage, contains('null'));
    });

    test('extractDomain handles null', () {
      final domain = Disposable.instance.extractDomain(null);
      expect(domain, isNull);
    });
  });
}
