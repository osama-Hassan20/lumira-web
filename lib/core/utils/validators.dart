import 'package:flutter/material.dart';

import '../extensions/localization_extension.dart';
import 'phone_utils.dart';

/// Validation utility functions for form inputs
class Validators {
  Validators._();

  // ══════════════════════════════ Context-free bool validators ══════════════════════════════

  /// Returns true if the name has at least 3 non-whitespace characters.
  static bool isNameValid(String? value) =>
      value != null && value.trim().length >= 3;

  /// Returns true if the phone has at least 10 non-whitespace characters.
  static bool isPhoneValid(String? value) =>
      value != null && value.trim().length >= 10;

  /// Returns true if the password has at least 6 non-whitespace characters.
  static bool isPasswordValid(String? value) =>
      value != null && value.trim().length >= 6;

  // ══════════════════════════════ Iraqi Phone Validator ══════════════════════════════

  /// التحقق من رقم هاتف عراقي
  ///
  /// الصيغ المقبولة:
  /// - مع الصفر: 07xxxxxxxxx (11 رقم)
  /// - بدون الصفر: 7xxxxxxxxx (10 أرقام)
  static String? validateIraqiPhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    final startsWithZeroSeven = PhoneUtils.startsWithZeroSeven(value);
    final startsWithSevenOnly = PhoneUtils.startsWithSevenOnly(value);

    if (!startsWithZeroSeven && !startsWithSevenOnly)
      return null; // ليس عراقي - نرجع null عشان المصري يقدر يتحقق

    if (startsWithZeroSeven) {
      if (value.length != PhoneUtils.localPhoneLengthWithZero) {
        return context.l10n.tr('val_phone_iraqi_11');
      }
    } else if (startsWithSevenOnly) {
      if (value.length != PhoneUtils.localPhoneLengthWithoutZero) {
        return context.l10n.tr('val_phone_iraqi_10');
      }
    }

    return null;
  }

  // ══════════════════════════════ Egyptian Phone Validator ══════════════════════════════

  /// التحقق من رقم هاتف مصري
  ///
  /// الصيغ المقبولة:
  /// - مع الصفر: 01xxxxxxxxx (11 رقم)
  /// - بدون الصفر: 1xxxxxxxxx (10 أرقام)
  static String? validateEgyptianPhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    final startsWithZeroOne = PhoneUtils.startsWithZeroOne(value);
    final startsWithOneOnly = PhoneUtils.startsWithOneOnly(value);

    if (!startsWithZeroOne && !startsWithOneOnly)
      return null; // ليس مصري - نرجع null عشان العراقي يقدر يتحقق

    if (startsWithZeroOne) {
      if (value.length != PhoneUtils.localPhoneLengthWithZero) {
        return context.l10n.tr('val_phone_egyptian_11');
      }
    } else if (startsWithOneOnly) {
      if (value.length != PhoneUtils.localPhoneLengthWithoutZero) {
        return context.l10n.tr('val_phone_egyptian_10');
      }
    }

    return null;
  }

  // ══════════════════════════════ Combined Phone Validator ══════════════════════════════

  /// التحقق من رقم هاتف (عراقي أو مصري)
  /// يحدد نوع الرقم تلقائياً ويستخدم الـ validator المناسب
  static String? validatePhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    // جرب العراقي الأول
    final iraqiResult = validateIraqiPhone(context, value);
    if (iraqiResult != null) return iraqiResult; // عراقي لكن فيه خطأ

    // لو العراقي رجع null ممكن يكون:
    // 1. رقم عراقي صحيح → نرجع null
    // 2. مش عراقي أصلاً → نجرب المصري
    if (PhoneUtils.startsWithZeroSeven(value) ||
        PhoneUtils.startsWithSevenOnly(value)) {
      return null; // رقم عراقي صحيح
    }

    // جرب المصري
    final egyptianResult = validateEgyptianPhone(context, value);
    if (egyptianResult != null) return egyptianResult; // مصري لكن فيه خطأ

    if (PhoneUtils.startsWithZeroOne(value) ||
        PhoneUtils.startsWithOneOnly(value)) {
      return null; // رقم مصري صحيح
    }

    // مش عراقي ولا مصري
    return context.l10n.tr('val_phone_invalid_prefix');
  }

  static String? validateFullName(
    BuildContext context,
    String? value,
    String? title,
  ) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.trim().length < 3) {
      return '$title ${context.l10n.tr('val_name_min_chars')}';
    }
    return null;
  }

  static String? validateCities(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return null;
  }

  static String? validateAgentQR(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(value)) {
      return context.l10n.tr('val_email_invalid');
    }
    return null;
  }

  static String? validatePassword(
    BuildContext context,
    String? value, {
    bool isComplex = true,
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // في اللوجين بس نتأكد إنها مش فاضية
    if (!isComplex) {
      if (value.length < 6) {
        return context.l10n.tr('val_password_short');
      }
      return null; // القيمة صالحة لأنها 6 أحرف أو أكثر
    }

    // قائمة لتجميع الأخطاء
    List<String> missingRequirements = [];

    // 1. التحقق من الطول
    if (value.length < 8) {
      missingRequirements.add(context.l10n.tr('val_password_min_length'));
    }

    // 2. التحقق من الحرف الكبير
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      missingRequirements.add(context.l10n.tr('val_password_uppercase'));
    }

    // 3. التحقق من الحرف الصغير
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      missingRequirements.add(context.l10n.tr('val_password_lowercase'));
    }

    // 4. التحقق من الأرقام
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      missingRequirements.add(context.l10n.tr('val_password_digit'));
    }

    // 5. التحقق من الرموز الخاصة
    if (!RegExp(
      r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:,\.<>\?/\\|`~]',
    ).hasMatch(value)) {
      missingRequirements.add(context.l10n.tr('val_password_special'));
    }

    // إذا كانت القائمة تحتوي على أخطاء، ندمجهم في رسالة واحدة
    if (missingRequirements.isNotEmpty) {
      return '${context.l10n.tr('val_password_must_contain')} ${missingRequirements.join('، ')}';
    }

    return null;
  }

  /// Validates password confirmation
  /// - Must not be empty
  /// - Must match the original password
  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return context.l10n.tr('val_confirm_password_empty');
    }
    if (value != originalPassword) {
      return context.l10n.tr('val_confirm_password_mismatch');
    }
    return null;
  }

  /// Validates an OTP code
  /// - Must be 6 digits
  static String? validateOtp(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.tr('val_otp_empty');
    }
    if (value.length != 6) {
      return context.l10n.tr('val_otp_length');
    }
    return null;
  }
}
