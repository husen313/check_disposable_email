# Check Disposable Email Package

A powerful Flutter package to validate email addresses and check if they use disposable/temporary email domains. Features high-performance O(1) lookups, comprehensive email format validation, and detailed validation results.

## What is a Disposable Email Address?

A Disposable Email Address (also known as a throwaway email, temporary email, or fake email address) is a type of email address that is used for a short period of time and is intended to be discarded after use. These email addresses are typically provided by various online services or websites to allow users to sign up for services or access content without using their primary or personal email address.

## ✨ Features

- ✅ **Fast Performance**: O(1) lookup using optimized Set-based checking (3000x+ faster)
- ✅ **Case-Insensitive Matching**: Handles uppercase, lowercase, and mixed case emails
- ✅ **Email Format Validation**: RFC 5322 compliant email format validation
- ✅ **Detailed Validation Results**: Get comprehensive validation information with `EmailValidationResult`
- ✅ **Domain Extraction**: Extract and normalize domains from email addresses
- ✅ **Null Safety**: Proper null handling for all inputs
- ✅ **Comprehensive Error Messages**: Specific, descriptive error messages
- ✅ **3,200+ Disposable Domains**: Extensive list of known disposable email domains

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  check_disposable_email: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Usage

### Basic Usage - Simple Validation

```dart
import 'package:check_disposable_email/check_disposable_email.dart';

// Simple boolean check
bool isValid = Disposable.instance.hasValidEmail('user@gmail.com');
// Returns: true

bool isDisposable = Disposable.instance.hasValidEmail('user@mailinator.com');
// Returns: false (disposable email)
```

### Advanced Usage - Detailed Validation Results

```dart
import 'package:check_disposable_email/check_disposable_email.dart';

// Get detailed validation information
EmailValidationResult result = Disposable.instance.validateEmail('user@gmail.com');

print(result.isValid);        // true
print(result.isDisposable);   // false
print(result.isFormatValid);  // true
print(result.domain);         // 'gmail.com'
print(result.errorMessage);   // null
```

### Handling Different Scenarios

```dart
// Valid email
EmailValidationResult valid = Disposable.instance.validateEmail('user@gmail.com');
if (valid.isValid) {
  print('Email is valid and not disposable');
}

// Disposable email
EmailValidationResult disposable = Disposable.instance.validateEmail('user@mailinator.com');
if (disposable.isDisposable) {
  print('Email uses disposable domain: ${disposable.domain}');
  print('Error: ${disposable.errorMessage}');
}

// Invalid format
EmailValidationResult invalid = Disposable.instance.validateEmail('invalid-email');
if (!invalid.isFormatValid) {
  print('Email format is invalid: ${invalid.errorMessage}');
}
```

### Domain Extraction

```dart
// Extract domain from email
String? domain = Disposable.instance.extractDomain('user@Gmail.COM');
print(domain); // 'gmail.com' (normalized to lowercase)

// Returns null for invalid emails
String? invalid = Disposable.instance.extractDomain('invalid-email');
print(invalid); // null
```

### Null Handling

```dart
// All methods handle null inputs gracefully
bool result = Disposable.instance.hasValidEmail(null); // Returns false

EmailValidationResult result = Disposable.instance.validateEmail(null);
// Returns EmailValidationResult with errorMessage: 'Email address cannot be null'

String? domain = Disposable.instance.extractDomain(null); // Returns null
```

## 📚 API Reference

### `Disposable.instance.hasValidEmail(String? email)`

Simple boolean check for email validation.

**Parameters:**

- `email`: Email address to validate (can be null)

**Returns:** `bool` - `true` if email is valid and non-disposable, `false` otherwise

**Example:**

```dart
bool isValid = Disposable.instance.hasValidEmail('user@gmail.com');
```

---

### `Disposable.instance.validateEmail(String? email)`

Get detailed validation information about an email address.

**Parameters:**

- `email`: Email address to validate (can be null)

**Returns:** `EmailValidationResult` - Detailed validation result object

**Example:**

```dart
EmailValidationResult result = Disposable.instance.validateEmail('user@gmail.com');
```

---

### `Disposable.instance.extractDomain(String? email)`

Extract and normalize the domain from an email address.

**Parameters:**

- `email`: Email address to extract domain from (can be null)

**Returns:** `String?` - Domain in lowercase, or `null` if invalid

**Example:**

```dart
String? domain = Disposable.instance.extractDomain('user@Gmail.COM');
// Returns: 'gmail.com'
```

---

## 📋 EmailValidationResult

The `EmailValidationResult` class provides comprehensive validation information:

| Property          | Type        | Description                                   |
| ----------------- | ----------- | --------------------------------------------- |
| `isValid`       | `bool`    | Whether the email is valid and non-disposable |
| `isDisposable`  | `bool`    | Whether the domain is disposable/temporary    |
| `isFormatValid` | `bool`    | Whether the email format is valid             |
| `domain`        | `String?` | Extracted domain (lowercase)                  |
| `errorMessage`  | `String?` | Error message if validation failed            |

### Factory Constructors

```dart
// Valid email
EmailValidationResult.valid('gmail.com')

// Disposable email
EmailValidationResult.disposable('mailinator.com')

// Invalid format
EmailValidationResult.invalidFormat('Email address must contain @ symbol')
```

## 🎯 Use Cases

- **User Registration**: Prevent users from signing up with disposable emails
- **Email Verification**: Validate email addresses before sending verification emails
- **Form Validation**: Real-time email validation in forms
- **Data Quality**: Ensure data quality by filtering disposable emails
- **Security**: Prevent abuse from temporary email addresses

## ⚡ Performance

- **O(1) Lookup**: Domain checking uses Set-based lookups for constant-time performance
- **Lazy Initialization**: Domain list is cached and initialized on first access
- **Optimized**: 3000x+ faster than previous List-based implementation

## 🔒 Null Safety

All methods properly handle null inputs:

- `hasValidEmail(null)` returns `false`
- `validateEmail(null)` returns `EmailValidationResult` with appropriate error message
- `extractDomain(null)` returns `null`

## 🧪 Testing

The package includes comprehensive test coverage with 47+ tests covering:

- Valid and disposable email detection
- Case-insensitive matching
- Email format validation
- Null handling
- Domain extraction
- Edge cases

## 📸 Screenshots

![Disposable-Email-Demo]()
![Valid-Email-Demo]()
![Extraction-Email-Demo]()

## 🛠️ Example App

Check out the example app in the `example/` directory to see:

- Beautiful gradient UI
- Email validation
- Detailed validation results display
- Domain extraction demonstration

Run the example:

```bash
cd example
flutter run
```

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and improvements.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the terms specified in the LICENSE file.

## 🔗 Links

- [GitHub Repository](https://github.com/husen313/check_disposable_email)
- [Pub.dev Package](https://pub.dev/packages/check_disposable_email)

## 💡 Tips

- Use `validateEmail()` when you need detailed validation information
- Use `hasValidEmail()` for simple boolean checks (faster for simple use cases)
- Use `extractDomain()` to normalize and extract domains from emails
- All methods automatically trim whitespace from inputs
- Domain matching is case-insensitive, so `User@Gmail.COM` works the same as `user@gmail.com`

---

Made with ❤️ for the Flutter community
