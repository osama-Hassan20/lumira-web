import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// -------------------------------------------------------------------
// 1. Extension: لتنسيق الأرقام والأسعار في أي مكان بالكود
// -------------------------------------------------------------------
extension PriceFormatter on num {
  /// تحويل الرقم لتنسيق عربي: 1000.5 -> ١٬٠٠٠٫٥
  String toArabicPrice({String? currency}) {
    final format = NumberFormat.decimalPattern('ar');
    String formatted = format.format(this);
    return currency != null ? '$formatted $currency' : formatted;
  }

  /// تحويل الأرقام الكبيرة لمختصرة: 1200000 -> ١٫٢ مليون
  String toShortArabic() {
    return NumberFormat.compactCurrency(
      locale: 'ar',
      symbol: '',
    ).format(this).trim();
  }
}

// -------------------------------------------------------------------
// 2. Widget: عرض السعر بشكل احترافي مع أنيميشن وخيارات الخصم
// -------------------------------------------------------------------
class PriceTagWidget extends StatelessWidget {
  final double price;
  final double? oldPrice;
  final String currency;
  final Color themeColor;
  final bool showDiscountPercentage;
  final double fontSize;

  const PriceTagWidget({
    super.key,
    required this.price,
    this.oldPrice,
    this.currency = 'ج.م',
    this.themeColor = Colors.green,
    this.showDiscountPercentage = false,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // تاغ نسبة الخصم
        if (showDiscountPercentage && oldPrice != null && oldPrice! > price)
          _buildBadge(),

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            // السعر الحالي مع عداد متحرك
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0, end: price),
              curve: Curves.easeOutQuart,
              builder: (context, value, _) {
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value.toArabicPrice(),
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: currency,
                        style: TextStyle(
                          fontSize: fontSize * 0.7,
                          color: themeColor.withAlpha(204), // 80% opacity
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // السعر القديم مشطوب
            if (oldPrice != null && oldPrice! > price)
              Text(
                oldPrice!.toArabicPrice(currency: currency),
                style: TextStyle(
                  fontSize: fontSize * 0.65,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge() {
    final discount = (((oldPrice! - price) / oldPrice!) * 100).toInt();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'خصم ${discount.toArabicPrice()}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
