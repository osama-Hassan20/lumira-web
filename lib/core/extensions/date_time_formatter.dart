import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../storage/shared_prefs.dart';
import '../utils/constants/app_strings.dart';

extension DateTimeFormatter on DateTime {
  String get toArabicDayName {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(year, month, day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return 'اليوم';
    if (diff == 1) return 'أمس';
    return DateFormat('EEEE', 'ar').format(this); // الأحد، الإثنين... إلخ
  }

  String toArabicSmart({bool dateOnly = false, bool dateForm = true}) {
    final savedLang =
        (SharedPrefHelper.getData(key: AppStrings.currentLanguage) ?? 'ar')
            .toString();
    final langCode = savedLang.split(RegExp('[-_]'))[0];
    final bool isAr = langCode == 'ar';

    if (isAr) {
      timeago.setLocaleMessages('ar', ArabicMessages());
    }

    final DateTime now = DateTime.now();
    final Duration difference = now.difference(this);

    if (dateForm) {
      return DateFormat('d MMMM yyyy', isAr ? 'ar' : 'en').format(this);
    }

    // التواريخ المستقبلية: عرض التاريخ والوقت حسب اللغة
    if (difference.isNegative) {
      final String date = DateFormat(
        'd MMMM yyyy',
        isAr ? 'ar' : 'en',
      ).format(this);
      final String time = DateFormat('h:mm a', isAr ? 'ar' : 'en').format(this);
      return dateOnly ? date : '$date - $time';
    }

    // إذا كان الفرق أقل من 15 ثانية، نظهر "الآن" أو "now"
    if (difference.inSeconds < 15 && !dateOnly) {
      return isAr ? 'الآن' : 'now';
    }

    if (difference.inDays < 1) {
      return isAr
          ? timeago.format(this, locale: 'ar', allowFromNow: false)
          : timeago.format(this, allowFromNow: false);
    } else if (difference.inDays < 2) {
      final String time = DateFormat('h:mm a', isAr ? 'ar' : 'en').format(this);
      return isAr ? 'أمس - $time' : 'Yesterday - $time';
    } else {
      final String date = DateFormat(
        'd MMMM yyyy',
        isAr ? 'ar' : 'en',
      ).format(this);
      final String time = DateFormat('h:mm a', isAr ? 'ar' : 'en').format(this);
      return '$date - $time';
    }
  }
}

// ─── Age formatter ───────────────────────────────────────────────────────────
// Returns a human-readable age string from a birth date.
// [locale] should be 'ar' for Arabic or 'en' for English.
//
// Arabic examples : 7 أيام | 15 يوم | شهر | شهر و 7 أيام | شهرين | 3 شهور
//                   سنة | سنة وشهر | سنة و 4 شهور
// English examples: 7 days | 15 days | 1 month | 1 month and 7 days | 2 months
//                   1 year | 1 year and 1 month | 1 year and 4 months
extension AgeFormatter on DateTime {
  String toAgeString(String locale) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final birth = DateTime(year, month, day);

    if (today.isBefore(birth)) return '';

    final bool isAr = locale == 'ar';

    if (today.isAtSameMomentAs(birth)) {
      return isAr ? 'بضع ساعات' : 'A few hours';
    }

    int years = today.year - birth.year;
    int months = today.month - birth.month;
    int days = today.day - birth.day;

    if (days < 0) {
      months--;
      // days in the previous month
      days += DateTime(today.year, today.month, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    if (years >= 1) {
      final yearStr = _formatYears(years, isAr);
      if (months == 0 || years >= 5) return yearStr;
      final monthStr = _formatMonths(months, isAr);
      return isAr ? '$yearStr و$monthStr' : '$yearStr and $monthStr';
    }

    if (months >= 1) {
      final monthStr = _formatMonths(months, isAr);
      if (days == 0) return monthStr;
      final dayStr = _formatDays(days, isAr);
      return isAr ? '$monthStr و $dayStr' : '$monthStr and $dayStr';
    }

    final totalDays = today.difference(birth).inDays;
    return _formatDays(totalDays < 1 ? 1 : totalDays, isAr);
  }

  static String _formatDays(int n, bool isAr) {
    if (!isAr) return '$n ${n == 1 ? 'day' : 'days'}';
    if (n == 1) return 'يوم';
    if (n == 2) return 'يومين';
    if (n >= 3 && n <= 10) return '$n أيام';
    return '$n يوم';
  }

  static String _formatMonths(int n, bool isAr) {
    if (!isAr) return '$n ${n == 1 ? 'month' : 'months'}';
    if (n == 1) return 'شهر';
    if (n == 2) return 'شهرين';
    if (n >= 3 && n <= 10) return '$n شهور';
    return '$n شهر';
  }

  static String _formatYears(int n, bool isAr) {
    if (!isAr) return '$n ${n == 1 ? 'year' : 'years'}';
    if (n == 1) return 'سنة';
    if (n == 2) return 'سنتين';
    if (n >= 3 && n <= 10) return '$n سنوات';
    return '$n سنة';
  }
}

class ArabicMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => 'منذ';
  @override
  String prefixFromNow() => 'من الآن';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';

  // تعديل "أقل من دقيقة" لتبدو طبيعية أكثر
  @override
  String lessThanOneMinute(int seconds) => 'لحظات';

  @override
  String aboutAMinute(int minutes) => 'دقيقة';
  @override
  String minutes(int minutes) => minutes == 2
      ? 'دقيقتين'
      : (minutes >= 3 && minutes <= 10 ? '$minutes دقائق' : '$minutes دقيقة');
  @override
  String aboutAnHour(int minutes) => 'ساعة';
  @override
  String hours(int hours) => hours == 2
      ? 'ساعتين'
      : (hours >= 3 && hours <= 10 ? '$hours ساعات' : '$hours ساعة');
  @override
  String aDay(int hours) => 'أمس';
  @override
  String days(int days) => days == 2
      ? 'يومين'
      : (days >= 3 && days <= 10 ? '$days أيام' : '$days يوم');
  @override
  String aboutAMonth(int days) => 'شهر';
  @override
  String months(int months) => months == 2
      ? 'شهرين'
      : (months >= 3 && months <= 10 ? '$months أشهر' : '$months شهر');
  @override
  String aboutAYear(int year) => 'سنة';
  @override
  String years(int years) => years == 2
      ? 'سنتين'
      : (years >= 3 && years <= 10 ? '$years سنوات' : '$years سنة');
  @override
  String wordSeparator() => ' ';
}

// ─── Query Parameter Date Format ─────────────────────────────────────────────
// Format: 20-4-2026 (used for API query parameters)
extension QueryDateFormatter on DateTime {
  String toQueryDateFormat() {
    return '$day-$month-$year';
  }
}
