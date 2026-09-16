import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import '../utils/theme/app_size.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.title,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLength,
    this.textInputType,
    this.obscureText = false,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTapOutsideUnFocus = true,
    this.onTap,
    this.topPadding,
    this.bottomPadding,
    this.onChanged,
    this.inputFormatters,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onPasswordVisibilityToggle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.hintStyle,
    this.contentPadding,
    // --- المتغيرات الجديدة المضافة ---
    this.fillColor,
    this.filled = false,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.borderRadius,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? title;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final TextInputType? textInputType;
  final bool obscureText;
  final int maxLines;
  final bool readOnly;
  final bool onTapOutsideUnFocus;
  final VoidCallback? onTap;
  final double? topPadding;
  final double? bottomPadding;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onPasswordVisibilityToggle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;

  // --- تعريف المتغيرات الجديدة ---
  final Color? fillColor;
  final bool filled;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final double? borderRadius;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: AppFontStyle.medium16(
              context,
            ).copyWith(color: AppColors.textSecondary569),
          ),
        title != null
            ? SizedBox(height: topPadding ?? AppSize.size8)
            : SizedBox.shrink(),
        TextFormField(
          controller: controller,
          validator: validator,
          readOnly: readOnly,
          obscureText: isPassword ? !isPasswordVisible : obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          textAlign: textAlign,
          textDirection: textDirection,
          cursorColor: AppColors.primary,
          onTapOutside: onTapOutsideUnFocus
              ? (event) => FocusScope.of(context).unfocus()
              : null,
          style: AppFontStyle.regular16(context).copyWith(
            color: textColor ?? AppColors.textPrimary,
          ), // استخدام المتغير الجديد
          // TextStyle(
          //   fontSize: 16,
          //   fontWeight: FontWeight.w400,
          //   color: textColor ?? AppColors.zinc5B, // استخدام المتغير الجديد
          // ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: filled, // تفعيل الخلفية الملونة
            fillColor: fillColor, // لون الخلفية
            contentPadding: contentPadding,
            errorMaxLines: 2,
            suffixIconConstraints: const BoxConstraints(minWidth: 32),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.grey92,
                    ),
                    onPressed: onPasswordVisibilityToggle,
                  )
                : suffixIcon,
            prefixIcon: prefixIcon,
            hintStyle:
                hintStyle ??
                AppFontStyle.medium14(
                  context,
                ).copyWith(color: AppColors.grey7C),
            // TextStyle(
            //   color: AppColors.zinc5B,
            //   fontSize: 16,
            //   fontWeight: FontWeight.w400,
            // ),
            // إعدادات الحدود باستخدام المتغيرات الجديدة
            border: _buildBorder(borderColor ?? AppColors.greyE3),
            enabledBorder: _buildBorder(borderColor ?? AppColors.greyE3),
            disabledBorder: _buildBorder(borderColor ?? AppColors.greyE3),
            focusedBorder: _buildBorder(
              focusedBorderColor ?? AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: bottomPadding ?? 8),
      ],
    );
  }

  // دالة مساعدة لبناء الحدود لتقليل تكرار الكود
  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppSize.borderRadiusSize12,
      ),
      borderSide: BorderSide(color: color),
    );
  }
}
