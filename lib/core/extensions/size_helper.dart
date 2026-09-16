import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import 'size_provider.dart';

extension SizeHelperExtensions on BuildContext {
  // التحقق من وضعية الشاشة
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  // الحصول على عرض الشاشة مع مراعاة أقصى عرض مسموح به
  double get screenWidth => isLandscape
      ? MediaQuery.of(this).size.height
      : MediaQuery.of(this).size.width > AppConstants.maxScreenWidth
      ? AppConstants.maxScreenWidth
      : MediaQuery.of(this).size.width;

  // الحصول على ارتفاع الشاشة
  double get screenHeight => isLandscape
      ? MediaQuery.of(this).size.width > AppConstants.maxScreenWidth
            ? AppConstants.maxScreenWidth
            : MediaQuery.of(this).size.width
      : MediaQuery.of(this).size.height;

  SizeProvider get sizeProvider => SizeProvider.of(this);

  // حساب نسبة التوسع بناءً على التصميم الأساسي
  double get scaleWidth => (sizeProvider.width) / sizeProvider.baseSize.width;

  double get scaleHeight => sizeProvider.height / sizeProvider.baseSize.height;

  // دالة لتحديد العرض مع قيود (Clamp)
  double setWidth(num w) {
    return w * scaleWidth.clamp(0.8, 1.2);
  }

  // دالة لتحديد الارتفاع مع قيود (Clamp)
  double setHeight(num h) {
    return h * scaleHeight.clamp(0.8, 1.2);
  }

  // دالة تحديد حجم الخط مع قيود (Clamp) لضمان عدم الكبر/الصغر الزائد
  double setSp(num fontSize) {
    return fontSize * scaleWidth.clamp(0.8, 1.2);
  }

  /// هذه هي الدالة التي تستخدمها في AppFontStyle
  /// تم إضافة .clamp(0.8, 1.2) هنا لحل مشكلة التابلت
  double setMinSize(num size) {
    double scale = min(scaleWidth, scaleHeight);
    return size * scale.clamp(0.8, 1.1);
  }
}
