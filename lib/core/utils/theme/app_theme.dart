import 'package:flutter/material.dart';

import '../../../config/app_constants.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    splashColor: AppColors.transparent,
    highlightColor: AppColors.transparent,
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: AppColors.white,
      dialTextStyle: TextStyle(
        color: AppColors.textPrimaryA1A,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: const TextStyle(color: AppColors.white),
      padding: const EdgeInsets.symmetric(vertical: 16),
      leadingPadding: const EdgeInsets.symmetric(horizontal: 16),
    ),
    datePickerTheme: const DatePickerThemeData(
      dayStyle: TextStyle(
        color: AppColors.textPrimaryA1A,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      yearStyle: TextStyle(
        color: AppColors.textPrimaryA1A,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      weekdayStyle: TextStyle(
        color: AppColors.textPrimaryA1A,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.white,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimaryA1A,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.textPrimaryA1A,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: AppConstants.arabicFontFamily,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textPrimaryA1A,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: AppConstants.arabicFontFamily,
      ),
      bodySmall: TextStyle(
        color: AppColors.textPrimaryA1A,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: AppConstants.arabicFontFamily,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.primary,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.textPrimaryA1A,
      error: AppColors.error,
      onError: AppColors.white,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withValues(alpha: 0.1),
      selectionHandleColor: AppColors.primary,
    ),
    fontFamily: AppConstants.arabicFontFamily,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.all(14.0),
      isDense: true,
      hintStyle: const TextStyle(color: AppColors.textSecondary569),
      labelStyle: const TextStyle(color: AppColors.textSecondary569),
      focusColor: AppColors.primary,
      floatingLabelStyle: TextStyle(color: AppColors.primary, fontSize: 18),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.divider),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.divider, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary),
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.white),
        overlayColor: WidgetStateProperty.all<Color>(AppColors.primary),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: const CircleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      dragHandleColor: AppColors.grayDA,
      dragHandleSize: Size(48, 6),
      backgroundColor: AppColors.grayF2,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.zinc2A,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    fontFamily: AppConstants.arabicFontFamily,
    scaffoldBackgroundColor: AppColors.black0C,
    primaryColor: AppColors.primary,
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: const TextStyle(color: AppColors.white),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.primary,
      onSecondary: AppColors.white,
      surface: AppColors.zinc2A,
      onSurface: AppColors.white,
      error: AppColors.red,
      onError: AppColors.white,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all<Color>(AppColors.grey),
      thumbColor: WidgetStateProperty.all<Color>(AppColors.white),
    ),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.primary),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      focusColor: AppColors.primary,
      floatingLabelStyle: TextStyle(color: AppColors.primary, fontSize: 18),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error, width: 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      fillColor: AppColors.zinc2A,
      filled: true,
      hintStyle: const TextStyle(color: AppColors.zinc7A),
      labelStyle: const TextStyle(color: AppColors.zinc7A),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary),
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.white),
        overlayColor: WidgetStateProperty.all<Color>(Colors.black26),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: const CircleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.gray2F,
    ),
  );
}
