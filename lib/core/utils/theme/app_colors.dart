import 'package:flutter/material.dart';
import '../../../config/app_config.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  //? ======================== Primary Color ========================
  static Color get primary =>
      Color(int.parse(AppConfig.primaryColor.replaceFirst('#', '0xFF')));
  static Color get secondary =>
      Color(int.parse(AppConfig.secondaryColor.replaceFirst('#', '0xFF')));
  static Color get third =>
      Color(int.parse(AppConfig.thirdColor.replaceFirst('#', '0xFF')));
  static Color get textPrimary =>
      Color(int.parse(AppConfig.textPrimary.replaceFirst('#', '0xFF')));
  static Color get textSecondary =>
      Color(int.parse(AppConfig.textSecondary.replaceFirst('#', '0xFF')));
  static Color get thirdColor =>
      Color(int.parse(AppConfig.thirdColor.replaceFirst('#', '0xFF')));
  static Color get scaffoldBackgroundColor => Color(
    int.parse(AppConfig.scaffoldBackgroundColor.replaceFirst('#', '0xFF')),
  );

  static const Color textPrimaryA1A = Color(0xFF1A1A1A);
  static const Color textSecondary569 = Color(0xFF475569);

  // Aliases
  static const Color transparent = Colors.transparent;

  //? ======================== core widget Color ========================
  static const Color grayDA = Color(0xFFDAE0E6);
  static const Color grayF0 = Color(0xFFF0F0F0);
  static const Color grayF1 = Color(0xFFF1F5F9);
  static const Color grayF2 = Color(0xFFF2F2F2);
  static const Color grayD9 = Color(0xFFD9D9D9);
  static const Color grayE9 = Color(0xFFE9E9E9);
  static const Color grayC9 = Color(0xFFC9C9C9);
  static const Color grayB2 = Color(0xFFB2B2B2);
  static const Color gray85 = Color(0xFF858585);
  static const Color gray2F = Color(0xFF2F2F2F);
  static const Color gray62 = Color(0xFF626262);
  static const Color zinc2A = Color(0xFF2D3748);
  static const Color zinc3A = Color(0xFF2C323A);
  static const Color zinc4A = Color(0xFF292929);
  static const Color zinc7A = Color(0xff272727);
  static const Color black0C = Color(0xFF0C0C0C);

  //? ======================== Accent Color ========================
  static const Color red = Color(0xFFFF0000);
  static const Color redDark = Color(0xFFE2483D);

  //? ======================== Text Colors ========================
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF808080);
  static const Color greyShade300 = Color(0xFFE0E0E0);

  //? ======================== Background Colors ========================
  static const Color scaffoldBackground = Color(0xFFF1F5F9);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);

  //? ======================== Status Colors ========================
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  //? ======================== Button Colors ========================
  static Color buttonBackground = primary;
  static const Color buttonText = white;
  static const Color delete = Color(0xffFF0000);
  static const Color scaffold = Colors.white;
  static const Color sideBar = Color(0xffFAFAFA);
  static const Color border = Color(0xffD4D4D8);
  static const Color grey6C = Color(0xFF6C6C6C);
  static const Color darkGrey2A = Color(0xFF2B2B2A);
  static const Color darkGrey3A = Color(0xFF2C323A);
  static const Color lightGreyE0 = Color(0xFFE0E0E0);
  static const Color lightGreyF5 = Color(0xFFF5F5F5);
  static const Color green00 = Color(0xFF008000);
  static const Color greyEB = Color(0xFFEBEBEB);
  static const Color grey92 = Color(0xFF929292);
  static const Color greyFA = Color(0xFFFAFAFA);
  static const Color dark1E = Color(0xFF1E1E1E);
  static const Color dark38 = Color(0xFF263238);
  static const Color dark2A = Color(0xFF2A2A2A);
  static const Color blueGrey62 = Color(0xFF545A62);
  static const Color greyAA = Color(0xFFAAAAAA);
  static const Color greyD9 = Color(0xFFD9D9D9);
  static const Color lightGreyF5x = Color(0xFFF4F4F5);
  static const Color yellow00 = Color(0xFFFFC100);
  static const Color dark3B = Color(0xFF25273B);
  static const Color peach9D = Color(0xFFFFBE9D);
  static const Color orange6E = Color(0xFFEB996E);
  static const Color yellow24x = Color(0xFFF5A524);
  static const Color lightGreyEC = Color(0xFFECECEC);
  static const Color blueGrey64 = Color(0xFF455A64);
  static const Color greyD3 = Color(0xFFD3D3D3);
  static const Color grey43 = Color(0xFF434343);
  static const Color beigeE5 = Color(0xFFFCF6E5);
  static const Color yellow84 = Color(0xFFE4C884);
  static const Color greyDC = Color(0xFFDCDCDC);
  static const Color grey89 = Color(0xFF898989);
  static const Color greyD8 = Color(0xFFD4D4D8);
  static const Color dark2AAlt = Color(0xFF27272A);
  static const Color greyE1 = Color(0xFFE1E1E1);
  static const Color yellow01 = Color(0xFFF4CA01);
  static const Color unActive = Color(0xFFBFBFBF);
  static const Color green = Color(0xFF008000);
  static const Color starGrey = Color(0xFFB2B2B2);

  //0xFF7C7C7C
  static const Color grey7C = Color(0xFF7C7C7C);
  //0xFFE3E3E3
  static const Color greyE3 = Color(0xFFE3E3E3);
  //0xFF001580
  static const Color darkBlue00 = Color(0xFF001580);
  //FF9202
  static const Color orange = Color(0xFFFF9202);
  //E9B824
  static const Color yellow = Color(0xFFE9B824);

  static const Color red202 = Color(0xFFFB0202);
  //71717A
  static const Color grey71 = Color(0xFF71717A);

  //#52525B
  static const Color black5b = Color(0xFF52525B);
}
