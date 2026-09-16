import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import 'animated_dialog.dart';
import 'custom_button.dart';

/// Result of a date range picker selection.
class DateRangeResult {
  final DateTime from;
  final DateTime to;

  const DateRangeResult({required this.from, required this.to});

  String get formatted =>
      '${DateFormat('yyyy/MM/dd').format(from)} - ${DateFormat('yyyy/MM/dd').format(to)}';
}

/// Shows a date range picker dialog and returns [DateRangeResult] or null.
Future<DateRangeResult?> showDateRangePickerDialog({
  required BuildContext context,
  DateTime? initialFrom,
  DateTime? initialTo,
}) async {
  final result = await showAnimatedDialog<DateTimeRange>(
    context: context,
    child: _DateRangePickerDialogContent(
      initialFrom: initialFrom,
      initialTo: initialTo,
    ),
  );
  if (result != null) {
    return DateRangeResult(from: result.start, to: result.end);
  }
  return null;
}

class _DateRangePickerDialogContent extends StatefulWidget {
  final DateTime? initialFrom;
  final DateTime? initialTo;

  const _DateRangePickerDialogContent({this.initialFrom, this.initialTo});

  @override
  State<_DateRangePickerDialogContent> createState() =>
      _DateRangePickerDialogContentState();
}

class _DateRangePickerDialogContentState
    extends State<_DateRangePickerDialogContent> {
  DateTime? _from;
  DateTime? _to;
  bool _selectingEnd = false;

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
    _selectingEnd = _from != null;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      if (!_selectingEnd) {
        _from = date;
        _to = null;
        _selectingEnd = true;
      } else {
        if (date.isBefore(_from!)) {
          _from = date;
          _to = null;
        } else {
          _to = date;
          _selectingEnd = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy/MM/dd');

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر الفترة الزمنية',
                  style: AppFontStyle.bold18(
                    context,
                  ).copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'من',
                        value: _from != null ? formatter.format(_from!) : '---',
                        isActive: !_selectingEnd,
                        onTap: () => setState(() => _selectingEnd = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateField(
                        label: 'إلى',
                        value: _to != null ? formatter.format(_to!) : '---',
                        isActive: _selectingEnd,
                        onTap: () => setState(() => _selectingEnd = true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: AppColors.primary),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _selectingEnd
                        ? (_to ?? _from ?? now)
                        : (_from ?? now),
                    firstDate: DateTime(2020),
                    lastDate: now,
                    onDateChanged: _onDateSelected,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: 'إلغاء',
                        backGroundColor: AppColors.gray2F,
                        titleStyle: AppFontStyle.semiBold14(
                          context,
                        ).copyWith(color: AppColors.gray2F),
                        onTap: () => context.pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        title: 'تأكيد',
                        backGroundColor: _from != null && _to != null
                            ? AppColors.primary
                            : AppColors.grayDA,
                        onTap: _from != null && _to != null
                            ? () {
                                context.pop(
                                  DateTimeRange(start: _from!, end: _to!),
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.gray2F,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppFontStyle.regular12(
                context,
              ).copyWith(color: AppColors.gray2F),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppFontStyle.medium16(
                context,
              ).copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
