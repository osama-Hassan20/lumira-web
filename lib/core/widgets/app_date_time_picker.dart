import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../extensions/localization_extension.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import '../utils/theme/app_size.dart';
import 'animated_dialog.dart';

// ─── Public API ───────────────────────────────────────────────────────────────

/// Shows a custom date+time picker dialog.
/// Returns the selected [DateTime] or `null` if cancelled/cleared.
Future<DateTime?> showAppDateTimePicker(
  BuildContext context, {
  DateTime? initial,
  DateTime? firstDate,
  DateTime? lastDate,
  String? title,
  bool showTime = true,
  bool allowFuture = true,
}) {
  final now = DateTime.now();
  final effectiveLastDate = allowFuture ? (lastDate ?? DateTime(2100)) : now;

  return showAnimatedDialog<DateTime>(
    context: context,
    child: _AppDateTimePickerDialog(
      initial: initial,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: effectiveLastDate,
      title: title,
      showTime: showTime,
    ),
  );
}

/// Shows a custom date-only picker dialog.
/// Returns the selected [DateTime] (time 00:00) or `null` if cancelled/cleared.
Future<DateTime?> showAppDatePicker(
  BuildContext context, {
  DateTime? initial,
  DateTime? firstDate,
  DateTime? lastDate,
  String? title,
  bool allowFuture = false,
}) {
  final now = DateTime.now();
  final effectiveLastDate = allowFuture ? (lastDate ?? DateTime(2100)) : now;

  return showAnimatedDialog<DateTime>(
    context: context,
    child: _AppDateTimePickerDialog(
      initial: initial,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: effectiveLastDate,
      title: title,
      dateOnly: true,
    ),
  );
}

// ─── Dialog widget ────────────────────────────────────────────────────────────

class _AppDateTimePickerDialog extends StatefulWidget {
  const _AppDateTimePickerDialog({
    this.initial,
    required this.firstDate,
    required this.lastDate,
    this.title,
    this.dateOnly = false,
    this.showTime = true,
  });

  final DateTime? initial;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? title;
  final bool dateOnly;
  final bool showTime;

  @override
  State<_AppDateTimePickerDialog> createState() =>
      _AppDateTimePickerDialogState();
}

class _AppDateTimePickerDialogState extends State<_AppDateTimePickerDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final now = widget.initial ?? DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && mounted) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formattedDate(BuildContext context) {
    try {
      final locale = Localizations.localeOf(context).toString();
      return DateFormat('d MMMM y', locale).format(_selectedDate);
    } catch (_) {
      return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title ?? context.l10n.tr('home_date_time');

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.size16),
        border: Border.all(color: AppColors.gray2F),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppFontStyle.semiBold18(
                      context,
                    ).copyWith(color: AppColors.gray2F),
                  ),
                ),
                Text(
                  _formattedDate(context),
                  style: AppFontStyle.regular14(
                    context,
                  ).copyWith(color: AppColors.gray2F),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // ── Calendar ──────────────────────────────────────────────────────
          CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            onDateChanged: (d) => setState(() => _selectedDate = d),
          ),

          const Divider(height: 1, color: AppColors.gray2F),

          // ── Time row / action row ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Time button — hidden in date-only mode
                if (!widget.dateOnly && widget.showTime) ...[
                  GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.gray2F),
                      ),
                      child: Text(
                        _selectedTime.format(context),
                        style: AppFontStyle.semiBold16(
                          context,
                        ).copyWith(color: AppColors.gray2F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.tr('home_time_label'),
                    style: AppFontStyle.medium14(
                      context,
                    ).copyWith(color: AppColors.textSecondary569),
                  ),
                ],

                const Spacer(),

                // Clear
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    context.l10n.tr('home_clear'),
                    style: AppFontStyle.regular14(
                      context,
                    ).copyWith(color: AppColors.gray2F),
                  ),
                ),
                // Cancel
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    context.l10n.tr('cancel'),
                    style: AppFontStyle.regular14(
                      context,
                    ).copyWith(color: AppColors.gray2F),
                  ),
                ),
                // Save
                TextButton(
                  onPressed: () {
                    final result = widget.dateOnly || !widget.showTime
                        ? DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                          )
                        : DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTime.hour,
                            _selectedTime.minute,
                          );
                    Navigator.of(context).pop(result);
                  },
                  child: Text(
                    context.l10n.tr('save'),
                    style: AppFontStyle.regular14(
                      context,
                    ).copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppDateTimeField extends StatelessWidget {
  const AppDateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.hintText,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final effectiveHint = hintText ?? context.l10n.tr('home_date_time_hint');
    final isEmpty = value.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFontStyle.medium16(
            context,
          ).copyWith(color: AppColors.textSecondary569),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray2F),
              borderRadius: BorderRadius.circular(AppSize.borderRadiusSize12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isEmpty ? effectiveHint : value,
                    style: AppFontStyle.regular14(context).copyWith(
                      color: isEmpty
                          ? AppColors.gray2F
                          : AppColors.gray2F,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: isEmpty ? AppColors.gray2F : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
