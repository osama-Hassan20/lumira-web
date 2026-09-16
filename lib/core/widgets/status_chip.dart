import 'package:flutter/material.dart';
import '../utils/theme/app_font_styles.dart';

class StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final double borderRadius;

  const StatusChip({
    super.key,
    required this.text,
    required this.color,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        style: AppFontStyle.regular12(context).copyWith(color: color),
      ),
    );
  }
}
