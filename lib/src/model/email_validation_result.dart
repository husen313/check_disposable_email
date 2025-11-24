/// Result of email validation containing detailed information about the validation.
///
/// This class provides comprehensive information about email validation,
/// including whether the email is valid, disposable, and any error messages.
class EmailValidationResult {
  /// Whether the email address is valid (format is correct and non-disposable).
  final bool isValid;

  /// Whether the email domain is a disposable/temporary email domain.
  final bool isDisposable;

  /// Whether the email format is valid (regardless of disposable status).
  final bool isFormatValid;

  /// The extracted domain from the email address (in lowercase), or `null` if invalid.
  final String? domain;

  /// Error message describing why validation failed, or `null` if validation succeeded.
  final String? errorMessage;

  /// Creates an [EmailValidationResult] with the given values.
  const EmailValidationResult({
    required this.isValid,
    required this.isDisposable,
    required this.isFormatValid,
    this.domain,
    this.errorMessage,
  });

  /// Creates a successful validation result for a valid, non-disposable email.
  factory EmailValidationResult.valid(String domain) {
    return EmailValidationResult(
      isValid: true,
      isDisposable: false,
      isFormatValid: true,
      domain: domain,
    );
  }

  /// Creates a result for a disposable email (valid format but disposable domain).
  factory EmailValidationResult.disposable(String domain) {
    return EmailValidationResult(
      isValid: false,
      isDisposable: true,
      isFormatValid: true,
      domain: domain,
      errorMessage: 'Email uses a disposable/temporary email domain: $domain',
    );
  }

  /// Creates a result for an invalid email format.
  factory EmailValidationResult.invalidFormat(String? errorMessage) {
    return EmailValidationResult(
      isValid: false,
      isDisposable: false,
      isFormatValid: false,
      errorMessage: errorMessage ?? 'Invalid email format',
    );
  }

  @override
  String toString() {
    if (isValid) {
      return 'EmailValidationResult(valid: true, domain: $domain)';
    } else if (isDisposable) {
      return 'EmailValidationResult(disposable: true, domain: $domain)';
    } else {
      return 'EmailValidationResult(invalid: true, error: $errorMessage)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmailValidationResult &&
        other.isValid == isValid &&
        other.isDisposable == isDisposable &&
        other.isFormatValid == isFormatValid &&
        other.domain == domain &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      isValid,
      isDisposable,
      isFormatValid,
      domain,
      errorMessage,
    );
  }
}
