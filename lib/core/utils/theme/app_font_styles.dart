import 'package:flutter/material.dart';

import '../../../config/app_constants.dart';
import '../../extensions/size_helper.dart';

class AppFontStyle {
  static TextStyle _base(
    BuildContext context,
    double size,
    FontWeight weight,
  ) => TextStyle(
    fontSize: getResponsiveFontSize(context, fontSize: size),
    fontWeight: weight,
    // fontFamily: AppConstants.arabicFontFamily,
  );

  // 10px
  static TextStyle regular10(BuildContext context) =>
      _base(context, 10, FontWeightHelper.regular);

  static TextStyle light10(BuildContext context) =>
      _base(context, 10, FontWeightHelper.light);

  static TextStyle medium10(BuildContext context) =>
      _base(context, 10, FontWeightHelper.medium);

  static TextStyle semiBold10(BuildContext context) =>
      _base(context, 10, FontWeightHelper.semiBold);

  static TextStyle bold10(BuildContext context) =>
      _base(context, 10, FontWeightHelper.bold);

  // 11px
  static TextStyle regular11(BuildContext context) =>
      _base(context, 11, FontWeightHelper.regular);

  static TextStyle light11(BuildContext context) =>
      _base(context, 11, FontWeightHelper.light);

  static TextStyle medium11(BuildContext context) =>
      _base(context, 11, FontWeightHelper.medium);

  static TextStyle semiBold11(BuildContext context) =>
      _base(context, 11, FontWeightHelper.semiBold);

  static TextStyle bold11(BuildContext context) =>
      _base(context, 11, FontWeightHelper.bold);

  // 12px
  static TextStyle regular12(BuildContext context) =>
      _base(context, 12, FontWeightHelper.regular);

  static TextStyle light12(BuildContext context) =>
      _base(context, 12, FontWeightHelper.light);

  static TextStyle medium12(BuildContext context) =>
      _base(context, 12, FontWeightHelper.medium);

  static TextStyle semiBold12(BuildContext context) =>
      _base(context, 12, FontWeightHelper.semiBold);

  static TextStyle bold12(BuildContext context) =>
      _base(context, 12, FontWeightHelper.bold);

  // 13px
  static TextStyle regular13(BuildContext context) =>
      _base(context, 13, FontWeightHelper.regular);

  static TextStyle light13(BuildContext context) =>
      _base(context, 13, FontWeightHelper.light);

  static TextStyle medium13(BuildContext context) =>
      _base(context, 13, FontWeightHelper.medium);

  static TextStyle semiBold13(BuildContext context) =>
      _base(context, 13, FontWeightHelper.semiBold);

  static TextStyle bold13(BuildContext context) =>
      _base(context, 13, FontWeightHelper.bold);

  // 14px
  static TextStyle regular14(BuildContext context) =>
      _base(context, 14, FontWeightHelper.regular);

  static TextStyle light14(BuildContext context) =>
      _base(context, 14, FontWeightHelper.light);

  static TextStyle medium14(BuildContext context) =>
      _base(context, 14, FontWeightHelper.medium);

  static TextStyle semiBold14(BuildContext context) =>
      _base(context, 14, FontWeightHelper.semiBold);

  static TextStyle bold14(BuildContext context) =>
      _base(context, 14, FontWeightHelper.bold);

  // 15px
  static TextStyle regular15(BuildContext context) =>
      _base(context, 15, FontWeightHelper.regular);

  static TextStyle light15(BuildContext context) =>
      _base(context, 15, FontWeightHelper.light);

  static TextStyle medium15(BuildContext context) =>
      _base(context, 15, FontWeightHelper.medium);

  static TextStyle semiBold15(BuildContext context) =>
      _base(context, 15, FontWeightHelper.semiBold);

  static TextStyle bold15(BuildContext context) =>
      _base(context, 15, FontWeightHelper.bold);

  // 16px
  static TextStyle regular16(BuildContext context) =>
      _base(context, 16, FontWeightHelper.regular);

  static TextStyle light16(BuildContext context) =>
      _base(context, 16, FontWeightHelper.light);

  static TextStyle medium16(BuildContext context) =>
      _base(context, 16, FontWeightHelper.medium);

  static TextStyle semiBold16(BuildContext context) =>
      _base(context, 16, FontWeightHelper.semiBold);

  static TextStyle bold16(BuildContext context) =>
      _base(context, 16, FontWeightHelper.bold);

  // 17px
  static TextStyle regular17(BuildContext context) =>
      _base(context, 17, FontWeightHelper.regular);

  static TextStyle light17(BuildContext context) =>
      _base(context, 17, FontWeightHelper.light);

  static TextStyle medium17(BuildContext context) =>
      _base(context, 17, FontWeightHelper.medium);

  static TextStyle semiBold17(BuildContext context) =>
      _base(context, 17, FontWeightHelper.semiBold);

  static TextStyle bold17(BuildContext context) =>
      _base(context, 17, FontWeightHelper.bold);

  // 18px
  static TextStyle regular18(BuildContext context) =>
      _base(context, 18, FontWeightHelper.regular);

  static TextStyle light18(BuildContext context) =>
      _base(context, 18, FontWeightHelper.light);

  static TextStyle medium18(BuildContext context) =>
      _base(context, 18, FontWeightHelper.medium);

  static TextStyle semiBold18(BuildContext context) =>
      _base(context, 18, FontWeightHelper.semiBold);

  static TextStyle bold18(BuildContext context) =>
      _base(context, 18, FontWeightHelper.bold);

  // 20px
  static TextStyle regular20(BuildContext context) =>
      _base(context, 20, FontWeightHelper.regular);

  static TextStyle light20(BuildContext context) =>
      _base(context, 20, FontWeightHelper.light);

  static TextStyle medium20(BuildContext context) =>
      _base(context, 20, FontWeightHelper.medium);

  static TextStyle semiBold20(BuildContext context) =>
      _base(context, 20, FontWeightHelper.semiBold);

  static TextStyle bold20(BuildContext context) =>
      _base(context, 20, FontWeightHelper.bold);

  // 22px
  static TextStyle regular22(BuildContext context) =>
      _base(context, 22, FontWeightHelper.regular);

  static TextStyle light22(BuildContext context) =>
      _base(context, 22, FontWeightHelper.light);

  static TextStyle medium22(BuildContext context) =>
      _base(context, 22, FontWeightHelper.medium);

  static TextStyle semiBold22(BuildContext context) =>
      _base(context, 22, FontWeightHelper.semiBold);

  static TextStyle bold22(BuildContext context) =>
      _base(context, 22, FontWeightHelper.bold);

  // 24px
  static TextStyle regular24(BuildContext context) =>
      _base(context, 24, FontWeightHelper.regular);

  static TextStyle light24(BuildContext context) =>
      _base(context, 24, FontWeightHelper.light);

  static TextStyle medium24(BuildContext context) =>
      _base(context, 24, FontWeightHelper.medium);

  static TextStyle semiBold24(BuildContext context) =>
      _base(context, 24, FontWeightHelper.semiBold);

  static TextStyle bold24(BuildContext context) =>
      _base(context, 24, FontWeightHelper.bold);

  // 32px
  static TextStyle semiBold32(BuildContext context) =>
      _base(context, 32, FontWeightHelper.semiBold);

  static TextStyle bold32(BuildContext context) =>
      _base(context, 32, FontWeightHelper.bold);
  static TextStyle medium32(BuildContext context) =>
      _base(context, 32, FontWeightHelper.medium);
  static TextStyle regular32(BuildContext context) =>
      _base(context, 32, FontWeightHelper.regular);

  // 36px
  static TextStyle regular36(BuildContext context) =>
      _base(context, 36, FontWeightHelper.regular);

  static TextStyle light36(BuildContext context) =>
      _base(context, 36, FontWeightHelper.light);

  static TextStyle medium36(BuildContext context) =>
      _base(context, 36, FontWeightHelper.medium);

  static TextStyle semiBold36(BuildContext context) =>
      _base(context, 36, FontWeightHelper.semiBold);

  static TextStyle bold36(BuildContext context) =>
      _base(context, 36, FontWeightHelper.bold);

  static TextStyle bold38(BuildContext context) =>
      _base(context, 38, FontWeightHelper.bold);

  // 44px
  static TextStyle regular44(BuildContext context) =>
      _base(context, 44, FontWeightHelper.regular);
  static TextStyle light44(BuildContext context) =>
      _base(context, 44, FontWeightHelper.light);
  static TextStyle medium44(BuildContext context) =>
      _base(context, 44, FontWeightHelper.medium);
  static TextStyle semiBold44(BuildContext context) =>
      _base(context, 44, FontWeightHelper.semiBold);
}

double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
  double responsiveFontSize = context.setMinSize(fontSize);

  return responsiveFontSize;
}

class FontWeightHelper {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}
