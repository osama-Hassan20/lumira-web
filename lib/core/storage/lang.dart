import 'package:flutter/material.dart';

import '../utils/constants/app_strings.dart';

enum LanguageType { english, arabic }

const Locale arabicLocal = Locale("ar", "EG");
const Locale englishLocal = Locale("en", "US");

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return AppStrings.english;
      case LanguageType.arabic:
        return AppStrings.arabic;
    }
  }
}
