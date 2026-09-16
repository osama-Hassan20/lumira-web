import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../config/app_constants.dart';
import '../../../../../../core/animations/slide_transition_animation.dart';
import '../../../../../../core/utils/phone_utils.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

// ══════════════════════════════ Iraqi Formatter ══════════════════════════════

/// فورماتر خاص بالأرقام العراقية
/// يتعامل مع الكود الدولي +964 عند اللصق
/// الأرقام المقبولة: 07xxxxxxxxx (11 رقم) أو 7xxxxxxxxx (10 أرقام)
class IraqiPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    // حذف الكود الدولي العراقي عند اللصق
    if (newText.startsWith('+964')) {
      newText = '0${newText.substring(4)}'; // +964 7xx → 07xx
    } else if (newText.startsWith('964')) {
      newText = '0${newText.substring(3)}'; // 964 7xx → 07xx
    }

    // السماح بالأرقام فقط
    final digitsOnly = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // تحديد الحد الأقصى
    int maxLength;
    if (digitsOnly.startsWith('07')) {
      maxLength = 11; // 07xxxxxxxxx
    } else if (digitsOnly.startsWith('7')) {
      maxLength = 10; // 7xxxxxxxxx
    } else if (digitsOnly.startsWith('0')) {
      maxLength = 11;
    } else {
      maxLength = 11;
    }

    // منع تجاوز الحد الأقصى
    if (digitsOnly.length > maxLength) {
      final truncatedText = digitsOnly.substring(0, maxLength);
      return TextEditingValue(
        text: truncatedText,
        selection: TextSelection.collapsed(offset: truncatedText.length),
      );
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

// ══════════════════════════════ Egyptian Formatter ══════════════════════════════

/// فورماتر خاص بالأرقام المصرية
/// يتعامل مع الكود الدولي +20 عند اللصق
/// الأرقام المقبولة: 01xxxxxxxxx (11 رقم) أو 1xxxxxxxxx (10 أرقام)
class EgyptianPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    // حذف الكود الدولي المصري عند اللصق
    if (newText.startsWith('+20')) {
      newText = '0${newText.substring(3)}'; // +20 1xx → 01xx
    } else if (newText.startsWith('20') &&
        newText.length >= 4 &&
        newText[2] == '1') {
      newText = '0${newText.substring(2)}'; // 201xx → 01xx
    }

    // السماح بالأرقام فقط
    final digitsOnly = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // تحديد الحد الأقصى
    int maxLength;
    if (digitsOnly.startsWith('01')) {
      maxLength = 11; // 01xxxxxxxxx
    } else if (digitsOnly.startsWith('1')) {
      maxLength = 10; // 1xxxxxxxxx
    } else if (digitsOnly.startsWith('0')) {
      maxLength = 11;
    } else {
      maxLength = 11;
    }

    // منع تجاوز الحد الأقصى
    if (digitsOnly.length > maxLength) {
      final truncatedText = digitsOnly.substring(0, maxLength);
      return TextEditingValue(
        text: truncatedText,
        selection: TextSelection.collapsed(offset: truncatedText.length),
      );
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

// ══════════════════════════════ Combined Formatter ══════════════════════════════

/// فورماتر مُجمّع يدعم الأرقام العراقية والمصرية معاً
/// يحدد نوع الرقم تلقائياً ويطبق الفورماتر المناسب
class CombinedPhoneInputFormatter extends TextInputFormatter {
  final _iraqiFormatter = IraqiPhoneInputFormatter();
  final _egyptianFormatter = EgyptianPhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // تحديد نوع الرقم بناءً على الكود الدولي أو البادئة
    if (text.startsWith('+20') ||
        text.startsWith('20') && text.length >= 4 && text[2] == '1') {
      return _egyptianFormatter.formatEditUpdate(oldValue, newValue);
    }

    if (text.startsWith('+964') || text.startsWith('964')) {
      return _iraqiFormatter.formatEditUpdate(oldValue, newValue);
    }

    // بالنسبة للأرقام المحلية: نحدد بناءً على البادئة
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('01') || digits.startsWith('1')) {
      return _egyptianFormatter.formatEditUpdate(oldValue, newValue);
    }

    // Default: عراقي (07 أو 7 أو أي رقم آخر)
    return _iraqiFormatter.formatEditUpdate(oldValue, newValue);
  }
}

class MobileInputWidget extends StatefulWidget {
  const MobileInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.title,
    this.readOnly = false,
    this.suffixIcon,
    this.animate = true,
    this.validator,
    this.textAlign,
    this.textDirection,
    this.prefixIcon,
    this.fillColor,
    this.filled = false,
  });

  /// The external controller — always holds the **international** format (+964…/+20…).
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? title;
  final bool readOnly;
  final Widget? suffixIcon;
  final bool animate;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Widget? prefixIcon;
  final Color? fillColor;
  final bool filled;

  @override
  State<MobileInputWidget> createState() => _MobileInputWidgetState();
}

class _MobileInputWidgetState extends State<MobileInputWidget> {
  /// Internal display controller — always holds the **local** format for display.
  late final TextEditingController _displayController;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    // If external controller already has a value, show it in local format.
    final initial = widget.controller.text;
    final localInitial = initial.startsWith('+')
        ? PhoneUtils.toLocalFormat(initial)
        : initial;
    _displayController = TextEditingController(text: localInitial);

    // Ensure external controller holds international format immediately
    final internationalInitial = PhoneUtils.toInternationalFormat(localInitial);
    if (widget.controller.text != internationalInitial) {
      widget.controller.text = internationalInitial;
    }

    // Keep display in sync when external controller is changed programmatically.
    widget.controller.addListener(_onExternalChanged);
  }

  void _onExternalChanged() {
    if (_syncing) return;
    final external = widget.controller.text;
    final local = external.startsWith('+')
        ? PhoneUtils.toLocalFormat(external)
        : external;
    if (_displayController.text != local) {
      _syncing = true;
      _displayController.value = TextEditingValue(
        text: local,
        selection: TextSelection.collapsed(offset: local.length),
      );
      _syncing = false;
    }
  }

  void _onDisplayChanged(String localValue) {
    if (_syncing) return;
    final international = PhoneUtils.toInternationalFormat(localValue);
    _syncing = true;
    widget.controller.value = TextEditingValue(
      text: international,
      selection: TextSelection.collapsed(offset: international.length),
    );
    _syncing = false;
    widget.onChanged?.call(localValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onExternalChanged);
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textField = CustomTextField(
      prefixIcon: widget.prefixIcon,
      title: widget.title,
      controller: _displayController,
      hintText: widget.hintText ?? 'أدخل رقم الهاتف ....',
      textInputType: TextInputType.phone,
      readOnly: widget.readOnly,
      ///////isValidLocalPhone in lib\core\utils\phone_utils.dart
      inputFormatters: [CombinedPhoneInputFormatter()],
      onChanged: _onDisplayChanged,
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection,
      suffixIcon: widget.suffixIcon,
      validator: widget.validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى ادخال رقم الجوال';
            }
            if (!PhoneUtils.isValidLocalPhone(value)) {
              return 'رقم الجوال غير صحيح';
            }
            return null;
          },
      fillColor: widget.fillColor,
      filled: widget.filled,
    );

    if (!widget.animate) return textField;

    return SlideTransitionAnimation(
      duration: const Duration(
        milliseconds:
            AppConstants.animationDuration +
            4 * AppConstants.animationIncrement,
      ),
      begin: const Offset(0, 1),
      end: Offset.zero,
      curve: Curves.easeOutCubic,
      child: textField,
    );
  }
}
