import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

extension PriceExtension on num {
  /// Formats the number with a comma as a thousands separator.
  /// Example: 1000 -> 1,000
  /// Example: 1250000 -> 1,250,000
  /// Example: 1250.5 -> 1,250.5
  String toFormattedPrice() {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return formatter.format(this);
  }
}

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-digit characters (including existing commas)
    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final parsed = num.tryParse(cleanText);
    if (parsed == null) {
      return oldValue;
    }

    // Format using PriceExtension
    final formatted = parsed.toFormattedPrice();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
