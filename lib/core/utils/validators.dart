class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _passwordUpper = RegExp(r'[A-Z]');
  static final RegExp _passwordLower = RegExp(r'[a-z]');
  static final RegExp _passwordDigit = RegExp(r'\d');
  static final RegExp _passwordSpecial = RegExp(r'[!@#\$&*~_\-\.]');
  static final RegExp _codeRegExp = RegExp(r'^\d+$');

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!_emailRegExp.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? name(String? value, {String field = 'Name'}) {
    if (value == null || value.isEmpty) return '$field is required';
    // Only allow names with letters, spaces, hyphens, or apostrophes, and must not contain any digits
    final trimmed = value.trim();
    if (!RegExp(r"^[A-Za-z\s'-]+").hasMatch(trimmed) ||
        RegExp(r'\d').hasMatch(trimmed)) {
      return '$field must contain only letters, spaces, hyphens, or apostrophes';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 12) return 'Password must be at least 12 characters';
    if (!_passwordUpper.hasMatch(value)) {
      return 'Add at least one uppercase letter';
    }
    if (!_passwordLower.hasMatch(value)) {
      return 'Add at least one lowercase letter';
    }
    if (!_passwordDigit.hasMatch(value)) {
      return 'Add at least one number';
    }
    if (!_passwordSpecial.hasMatch(value)) {
      return 'Add at least one special character (!@#\$&*~_- )';
    }
    return null;
  }

  static String? code(String? value) {
    if (value == null || value.isEmpty) return 'Enter the verification code';
    if (!_codeRegExp.hasMatch(value.trim())) return 'Code must be numbers only';
    return null;
  }

  static double passwordStrength(String value) {
    if (value.length < 12) {
      // Too short, always weak
      return 0.0;
    }
    // Each criteria: length >= 12, upper, lower, digit, special
    int score = 0;
    if (_passwordUpper.hasMatch(value)) score++;
    if (_passwordLower.hasMatch(value)) score++;
    if (_passwordDigit.hasMatch(value)) score++;
    if (_passwordSpecial.hasMatch(value)) score++;
    if (value.length > 15 && score == 4) return 1.0;
    return score / 5.0;
  }
}
