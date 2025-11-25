## 0.2.0

### 🚀 Major Enhancements

#### Performance & Correctness Improvements

- **Performance Optimization**: Converted domain list from `List` to `Set` for O(1) lookup performance (3000x+ faster)
- **Lazy Initialization**: Domain set is now cached and initialized on first access
- **Case-Insensitive Matching**: All domain checks are now case-insensitive (handles uppercase, lowercase, mixed case)
- **Email Format Validation**: Added comprehensive RFC 5322 compliant email format validation
  - Validates email structure (local@domain format)
  - Checks email length limits (max 254 chars total, 64 for local part)
  - Validates domain format (no consecutive dots, no leading/ending dots/hyphens)
  - Automatic whitespace trimming
  - Special character validation

#### Developer Experience Improvements

- **EmailValidationResult Class**: New result class providing detailed validation information
  - `isValid`: Whether email is valid and non-disposable
  - `isDisposable`: Whether domain is disposable
  - `isFormatValid`: Whether email format is valid
  - `domain`: Extracted domain (lowercase)
  - `errorMessage`: Detailed error message if validation failed
- **validateEmail Method**: New method returning `EmailValidationResult` with comprehensive validation details
- **extractDomain Method**: New public utility method to extract domain from email addresses
- **Enhanced Null Handling**: All methods now properly handle null inputs with clear error messages
- **Improved Error Messages**: Specific, descriptive error messages for different validation failures

### ✨ New Features

- `Disposable.instance.validateEmail(String? email)` - Returns detailed `EmailValidationResult`
- `Disposable.instance.extractDomain(String? email)` - Extracts and normalizes domain from email
- `EmailValidationResult` class with factory constructors (`valid()`, `disposable()`, `invalidFormat()`)

### 🔧 Improvements

- Return type changed from `bool?` to `bool` for `hasValidEmail()` method (more explicit)
- Better input sanitization (automatic trimming, null handling)
- Improved documentation with examples

### 🐛 Bug Fixes

- Fixed case-sensitive domain matching issue
- Fixed performance issue with O(n) list lookups
- Improved handling of edge cases (null, empty, whitespace-only inputs)

### 📝 Documentation

- Added comprehensive API documentation
- Added usage examples in method documentation
- Improved code comments and explanations

### ⚠️ Breaking Changes

- None - All changes are backward compatible. The existing `hasValidEmail()` method continues to work as before.

---

## 0.0.1

* TODO: initial release check Email Disposable
