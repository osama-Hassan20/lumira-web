/// Phone number utility functions (Iraq + Egypt)
class PhoneUtils {
  PhoneUtils._();

  // ══════════════════════════ Iraq Constants ══════════════════════════
  /// Iraq country code
  static const String iraqCountryCode = '+964';

  /// Valid Iraqi local phone prefix with leading zero
  static const String iraqPrefixWithZero = '07';

  /// Valid Iraqi local phone prefix without leading zero
  static const String iraqPrefixWithoutZero = '7';

  // ══════════════════════════ Egypt Constants ══════════════════════════
  /// Egypt country code
  static const String egyptCountryCode = '+20';

  /// Valid Egyptian local phone prefix with leading zero
  static const String egyptPrefixWithZero = '01';

  /// Valid Egyptian local phone prefix without leading zero
  static const String egyptPrefixWithoutZero = '1';

  // ══════════════════════════ Shared Constants ══════════════════════════
  /// Expected local phone number length with leading zero (e.g., 07712345678 / 01012345678)
  static const int localPhoneLengthWithZero = 11;

  /// Expected local phone number length without leading zero (e.g., 7712345678 / 1012345678)
  static const int localPhoneLengthWithoutZero = 10;

  // For backward compatibility
  static const String validLocalPrefixWithZero = '07';
  static const String validLocalPrefixWithoutZero = '7';

  // ══════════════════════════ Detection ══════════════════════════

  /// Detects if the phone is an Iraqi number (starts with 7/07)
  static bool isIraqiPhone(String phone) {
    final trimmed = phone.trim();
    return trimmed.startsWith(iraqPrefixWithZero) ||
        (trimmed.startsWith(iraqPrefixWithoutZero) &&
            !trimmed.startsWith(iraqPrefixWithZero));
  }

  /// Detects if the phone is an Egyptian number (starts with 1/01)
  static bool isEgyptianPhone(String phone) {
    final trimmed = phone.trim();
    return trimmed.startsWith(egyptPrefixWithZero) ||
        (trimmed.startsWith(egyptPrefixWithoutZero) &&
            !trimmed.startsWith(egyptPrefixWithZero));
  }

  /// Detects if the phone is in international Iraqi format (+964...)
  static bool isIraqiInternational(String phone) {
    final trimmed = phone.trim();
    return trimmed.startsWith(iraqCountryCode) ||
        (trimmed.startsWith('964') && trimmed.length == 13);
  }

  /// Detects if the phone is in international Egyptian format (+20...)
  static bool isEgyptianInternational(String phone) {
    final trimmed = phone.trim();
    return trimmed.startsWith(egyptCountryCode) ||
        (trimmed.startsWith('20') &&
            !trimmed.startsWith('200') &&
            trimmed.length == 12);
  }

  // ══════════════════════════ Conversion ══════════════════════════

  /// Converts a local phone number (Iraqi or Egyptian) to international format
  ///
  /// Iraqi Examples:
  /// - `07712345678` → `+9647712345678`
  /// - `7712345678` → `+9647712345678`
  ///
  /// Egyptian Examples:
  /// - `01012345678` → `+201012345678`
  /// - `1012345678` → `+201012345678`
  static String toInternationalFormat(String localPhone) {
    final phone = localPhone.trim();

    // Already in international format
    if (phone.startsWith('+')) return phone;

    // Iraqi: starts with 964 (without +)
    if (phone.startsWith('964') && phone.length == 13) {
      return '+$phone';
    }

    // Egyptian: starts with 20 (without +) and length matches
    if (phone.startsWith('201') && phone.length == 12) {
      return '+$phone';
    }

    // Iraqi: 07xxxxxxxxx (11 digits)
    if (phone.startsWith(iraqPrefixWithZero) &&
        phone.length == localPhoneLengthWithZero) {
      return '$iraqCountryCode${phone.substring(1)}';
    }

    // Iraqi: 7xxxxxxxxx (10 digits) - starts with 7 but NOT 07
    if (phone.startsWith(iraqPrefixWithoutZero) &&
        !phone.startsWith(iraqPrefixWithZero) &&
        phone.length == localPhoneLengthWithoutZero) {
      return '$iraqCountryCode$phone';
    }

    // Egyptian: 01xxxxxxxxx (11 digits)
    if (phone.startsWith(egyptPrefixWithZero) &&
        phone.length == localPhoneLengthWithZero) {
      return '$egyptCountryCode${phone.substring(1)}';
    }

    // Egyptian: 1xxxxxxxxx (10 digits) - starts with 1 but NOT 01
    if (phone.startsWith(egyptPrefixWithoutZero) &&
        !phone.startsWith(egyptPrefixWithZero) &&
        phone.length == localPhoneLengthWithoutZero) {
      return '$egyptCountryCode$phone';
    }

    return phone;
  }

  /// Converts an international phone number (Iraqi or Egyptian) to local format
  ///
  /// Iraqi: `+9647712345678` → `07712345678`
  /// Egyptian: `+201012345678` → `01012345678`
  static String toLocalFormat(String internationalPhone) {
    final phone = internationalPhone.trim();

    // Iraqi: +964...
    if (phone.startsWith(iraqCountryCode)) {
      return '0${phone.substring(iraqCountryCode.length)}';
    }

    // Iraqi: 964... (without +)
    if (phone.startsWith('964') && phone.length == 13) {
      return '0${phone.substring(3)}';
    }

    // Egyptian: +20...
    if (phone.startsWith(egyptCountryCode)) {
      return '0${phone.substring(egyptCountryCode.length)}';
    }

    // Egyptian: 20... (without +)
    if (phone.startsWith('201') && phone.length == 12) {
      return '0${phone.substring(2)}';
    }

    return phone;
  }

  // ══════════════════════════ Validation ══════════════════════════

  /// Validates a local phone number (Iraqi or Egyptian)
  ///
  /// Iraqi formats: 07xxxxxxxxx (11 digits) or 7xxxxxxxxx (10 digits)
  /// Egyptian formats: 01xxxxxxxxx (11 digits) or 1xxxxxxxxx (10 digits)
  static bool isValidLocalPhone(String phone) {
    final trimmed = phone.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(trimmed)) {
      return false;
    }

    return isValidIraqiLocalPhone(trimmed) ||
        isValidEgyptianLocalPhone(trimmed);
  }

  /// Validates a local Iraqi phone number
  static bool isValidIraqiLocalPhone(String phone) {
    final trimmed = phone.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(trimmed)) return false;

    // 07xxxxxxxxx (11 digits)
    if (trimmed.startsWith(iraqPrefixWithZero) &&
        trimmed.length == localPhoneLengthWithZero) {
      return true;
    }

    // 7xxxxxxxxx (10 digits)
    if (trimmed.startsWith(iraqPrefixWithoutZero) &&
        !trimmed.startsWith(iraqPrefixWithZero) &&
        trimmed.length == localPhoneLengthWithoutZero) {
      return true;
    }

    return false;
  }

  /// Validates a local Egyptian phone number
  static bool isValidEgyptianLocalPhone(String phone) {
    final trimmed = phone.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(trimmed)) return false;

    // 01xxxxxxxxx (11 digits)
    if (trimmed.startsWith(egyptPrefixWithZero) &&
        trimmed.length == localPhoneLengthWithZero) {
      return true;
    }

    // 1xxxxxxxxx (10 digits)
    if (trimmed.startsWith(egyptPrefixWithoutZero) &&
        !trimmed.startsWith(egyptPrefixWithZero) &&
        trimmed.length == localPhoneLengthWithoutZero) {
      return true;
    }

    return false;
  }

  // ══════════════════════════ Helper Methods ══════════════════════════

  /// Checks if the phone starts with '07' format (Iraqi)
  static bool startsWithZeroSeven(String phone) {
    return phone.trim().startsWith(iraqPrefixWithZero);
  }

  /// Checks if the phone starts with '7' format without leading zero (Iraqi)
  static bool startsWithSevenOnly(String phone) {
    final trimmed = phone.trim();
    return trimmed.startsWith(iraqPrefixWithoutZero) &&
        !trimmed.startsWith(iraqPrefixWithZero);
  }

  /// Checks if the phone starts with '01' format (Egyptian)
  static bool startsWithZeroOne(String phone) {
    return phone.trim().startsWith(egyptPrefixWithZero);
  }

  /// Checks if the phone starts with '1' format without leading zero (Egyptian)
  static bool startsWithOneOnly(String phone) {
    final trimmed = phone.trim();
    return trimmed.startsWith(egyptPrefixWithoutZero) &&
        !trimmed.startsWith(egyptPrefixWithZero);
  }

  /// Gets the expected length based on the phone prefix
  static int getExpectedLength(String phone) {
    final trimmed = phone.trim();
    if (trimmed.startsWith('0')) {
      return localPhoneLengthWithZero;
    }
    if (trimmed.startsWith('7') || trimmed.startsWith('1')) {
      return localPhoneLengthWithoutZero;
    }
    return localPhoneLengthWithZero; // Default
  }

  /// Validates an international phone number (Iraqi or Egyptian)
  static bool isValidInternationalPhone(String phone) {
    final trimmed = phone.trim();

    // Iraqi: +964xxxxxxxxxx (14 digits total)
    if (trimmed.startsWith(iraqCountryCode)) {
      final localPart = trimmed.substring(iraqCountryCode.length);
      return localPart.length == 10 && RegExp(r'^[0-9]+$').hasMatch(localPart);
    }

    // Egyptian: +20xxxxxxxxxx (13 digits total)
    if (trimmed.startsWith(egyptCountryCode)) {
      final localPart = trimmed.substring(egyptCountryCode.length);
      return localPart.length == 10 && RegExp(r'^[0-9]+$').hasMatch(localPart);
    }

    return false;
  }

  /// Strips the country code from a phone number and returns it in local format with leading 0
  /// Useful for displaying phone numbers in controllers (edit screens)
  ///
  /// Examples:
  /// - `+9647712345678` → `07712345678`
  /// - `+201012345678` → `01012345678`
  /// - `07712345678` → `07712345678` (no change)
  static String stripCountryCode(String phone) {
    return toLocalFormat(phone);
  }
}
