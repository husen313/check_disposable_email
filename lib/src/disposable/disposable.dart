import '../domains/domains_map.dart';
import '../model/domain_model.dart';
import '../model/email_validation_result.dart';

/// Internal class to hold email format validation result.
class _FormatValidationResult {
  final bool isValid;
  final String? errorMessage;

  const _FormatValidationResult(this.isValid, this.errorMessage);
}

/// A class for checking if an email address uses a disposable/temporary email domain.
///
/// This class provides efficient checking against a list of known disposable
/// email domains using optimized data structures for fast lookups.
class Disposable {
  Disposable._();

  static final Disposable instance = Disposable._();

  /// Cached Set of disposable domains for O(1) lookup performance.
  /// Initialized lazily on first access.
  Set<String>? _disposableDomains;

  /// Regular expression for basic email format validation.
  /// Matches: local@domain format with basic character validation.
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );

  /// Maximum length for email address (RFC 5321)
  static const int _maxEmailLength = 254;

  /// Maximum length for local part (before @) (RFC 5321)
  static const int _maxLocalPartLength = 64;

  /// Gets the cached set of disposable domains.
  /// Initializes the set on first access (lazy initialization).
  Set<String> get _domains {
    _disposableDomains ??= _loadDisposableDomains();
    return _disposableDomains!;
  }

  /// Loads and converts the domain list to a Set for O(1) lookup.
  /// All domains are normalized to lowercase for case-insensitive matching.
  Set<String> _loadDisposableDomains() {
    final domainItem = _loadDomainItem();
    final model = DomainModel.fromJson(domainItem);
    final domains = model.domainItems ?? [];

    // Convert to Set and normalize to lowercase for case-insensitive matching
    return domains.map((domain) => domain.toLowerCase().trim()).toSet();
  }

  /// Validates the email format according to RFC 5322 standards.
  ///
  /// Returns a [_FormatValidationResult] containing validation status and error message.
  _FormatValidationResult _validateEmailFormat(String email) {
    // Trim whitespace
    final trimmedEmail = email.trim();

    // Check if empty
    if (trimmedEmail.isEmpty) {
      return const _FormatValidationResult(false, 'Email address cannot be empty');
    }

    // Check maximum length
    if (trimmedEmail.length > _maxEmailLength) {
      return const _FormatValidationResult(
        false,
        'Email address exceeds maximum length of 254 characters',
      );
    }

    // Check if contains @ symbol
    if (!trimmedEmail.contains('@')) {
      return const _FormatValidationResult(false, 'Email address must contain @ symbol');
    }

    // Split email into local and domain parts
    final parts = trimmedEmail.split('@');
    if (parts.length != 2) {
      return const _FormatValidationResult(
        false,
        'Email address must contain exactly one @ symbol',
      );
    }

    final localPart = parts[0];
    final domainPart = parts[1];

    // Validate local part
    if (localPart.isEmpty) {
      return const _FormatValidationResult(
        false,
        'Email address must have a local part (before @)',
      );
    }
    if (localPart.length > _maxLocalPartLength) {
      return const _FormatValidationResult(
        false,
        'Local part exceeds maximum length of 64 characters',
      );
    }

    // Validate domain part
    if (domainPart.isEmpty) {
      return const _FormatValidationResult(
        false,
        'Email address must have a domain part (after @)',
      );
    }

    // Check for consecutive dots
    if (domainPart.contains('..')) {
      return const _FormatValidationResult(false, 'Domain cannot contain consecutive dots');
    }

    // Check if domain starts or ends with dot or hyphen
    if (domainPart.startsWith('.') || domainPart.endsWith('.')) {
      return const _FormatValidationResult(false, 'Domain cannot start or end with a dot');
    }
    if (domainPart.startsWith('-') || domainPart.endsWith('-')) {
      return const _FormatValidationResult(false, 'Domain cannot start or end with a hyphen');
    }

    // Use regex for comprehensive format validation
    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return const _FormatValidationResult(false, 'Email address format is invalid');
    }

    return const _FormatValidationResult(true, null);
  }

  /// Extracts the domain from an email address.
  ///
  /// This method handles:
  /// - Trimming whitespace
  /// - Case normalization (returns lowercase)
  /// - Invalid format detection
  ///
  /// Returns the domain part in lowercase, or `null` if email is invalid.
  ///
  /// Example:
  /// ```dart
  /// Disposable.instance.extractDomain('user@Gmail.COM'); // 'gmail.com'
  /// Disposable.instance.extractDomain('invalid-email'); // null
  /// ```
  String? extractDomain(String? email) {
    // Handle null input
    if (email == null) {
      return null;
    }

    // Trim whitespace
    final trimmedEmail = email.trim();

    // Check if empty after trimming
    if (trimmedEmail.isEmpty) {
      return null;
    }

    // Check if contains @ symbol
    if (!trimmedEmail.contains('@')) {
      return null;
    }

    // Split email into local and domain parts
    final parts = trimmedEmail.split('@');
    if (parts.length != 2) {
      return null; // Multiple @ symbols
    }

    final domain = parts[1].trim();
    return domain.isEmpty ? null : domain.toLowerCase();
  }

  /// Validates an email address and returns detailed validation information.
  ///
  /// This method performs:
  /// 1. Input sanitization (trimming, null handling)
  /// 2. Email format validation (RFC 5322 compliant)
  /// 3. Disposable domain checking (case-insensitive)
  ///
  /// Returns an [EmailValidationResult] containing:
  /// - `isValid`: Whether the email is valid and non-disposable
  /// - `isDisposable`: Whether the domain is disposable
  /// - `isFormatValid`: Whether the email format is valid
  /// - `domain`: The extracted domain (in lowercase)
  /// - `errorMessage`: Error message if validation failed
  ///
  /// Example:
  /// ```dart
  /// final result = Disposable.instance.validateEmail('user@gmail.com');
  /// print(result.isValid); // true
  /// print(result.domain); // 'gmail.com'
  ///
  /// final disposable = Disposable.instance.validateEmail('user@mailinator.com');
  /// print(disposable.isDisposable); // true
  /// print(disposable.errorMessage); // 'Email uses a disposable...'
  ///
  /// final invalid = Disposable.instance.validateEmail('invalid-email');
  /// print(invalid.isFormatValid); // false
  /// print(invalid.errorMessage); // 'Email address must contain @ symbol'
  /// ```
  EmailValidationResult validateEmail(String? email) {
    // Handle null input
    if (email == null) {
      return EmailValidationResult.invalidFormat('Email address cannot be null');
    }

    // Trim whitespace
    final trimmedEmail = email.trim();

    // Validate email format
    final formatResult = _validateEmailFormat(trimmedEmail);
    if (!formatResult.isValid) {
      return EmailValidationResult.invalidFormat(formatResult.errorMessage);
    }

    // Extract and normalize domain
    final domain = extractDomain(trimmedEmail);
    if (domain == null) {
      return EmailValidationResult.invalidFormat('Could not extract domain from email');
    }

    // Check against disposable domains (O(1) lookup with Set)
    final isDisposable = _domains.contains(domain);

    if (isDisposable) {
      return EmailValidationResult.disposable(domain);
    } else {
      return EmailValidationResult.valid(domain);
    }
  }

  /// Checks if the provided email address is valid and non-disposable.
  ///
  /// This method performs:
  /// 1. Email format validation (RFC 5322 compliant)
  /// 2. Disposable domain checking (case-insensitive)
  ///
  /// Returns `true` if the email is valid and non-disposable, `false` otherwise.
  ///
  /// This is a convenience method that calls [validateEmail] and returns only the `isValid` property.
  /// For detailed validation information, use [validateEmail] instead.
  ///
  /// Example:
  /// ```dart
  /// Disposable.instance.hasValidEmail('user@gmail.com'); // true
  /// Disposable.instance.hasValidEmail('user@mailinator.com'); // false (disposable)
  /// Disposable.instance.hasValidEmail('invalid-email'); // false (invalid format)
  /// ```
  bool hasValidEmail(String? email) {
    if (email == null) {
      return false;
    }
    return validateEmail(email).isValid;
  }

  /// Loads the domain items from the static map.
  static Map<String, dynamic> _loadDomainItem() {
    const Map<String, dynamic> domainData = DomainItems.items;
    return domainData;
  }
}
