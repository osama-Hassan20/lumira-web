import 'package:flutter/material.dart';

/// أداة مساعدة لحساب عدد الأعمدة و childAspectRatio بناءً على عرض الشاشة
class ResponsiveGrid {
  ResponsiveGrid._();

  /// عدد أعمدة grid المنتجات (2 columns للموبايل، 3 للتابلت، 4+ للشاشات الكبيرة)
  static int productCrossAxisCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  /// childAspectRatio لجريد المنتجات
  static double productAspectRatio(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) return 0.65;
    return 0.7;
  }

  /// SliverGridDelegate للمنتجات (يُستخدم في كل مكان فيه grid منتجات)
  static SliverGridDelegateWithFixedCrossAxisCount productGridDelegate(
    BuildContext context,
  ) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: productCrossAxisCount(context),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: productAspectRatio(context),
    );
  }

  /// عدد أعمدة الأقسام (categories) — أفقي: صفَّين ثابتَين، عمودي: حسب العرض
  static int categoryCrossAxisCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 3;
    return 2;
  }

  /// SliverGridDelegate لجريد الأقسام الأفقي (Home + Wallet gifts)
  static SliverGridDelegateWithFixedCrossAxisCount
  horizontalCategoryGridDelegate(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: categoryCrossAxisCount(context),
      mainAxisSpacing: 0,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9,
    );
  }

  /// SliverGridDelegate لجريد الأقسام العمودي (CategoriesScreen)
  static SliverGridDelegateWithMaxCrossAxisExtent verticalCategoryGridDelegate(
    BuildContext context,
  ) {
    final width = MediaQuery.sizeOf(context).width;
    final maxExtent = width >= 600 ? 110.0 : 90.0;
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: maxExtent,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.75,
    );
  }

  /// ارتفاع section الأقسام الأفقي
  static double horizontalCategoryHeight(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) return 240;
    return 180;
  }
}
