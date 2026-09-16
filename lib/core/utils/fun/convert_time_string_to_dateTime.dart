import 'package:intl/intl.dart';

DateTime convertTimeStringToDateTime(String timeString) {
  // نحلل الوقت باستخدام تنسيق "HH:mm:ss"
  DateTime parsedTime = DateFormat("HH:mm:ss", 'en').parse(timeString);

  // نحصل على التاريخ الحالي
  DateTime now = DateTime.now();

  // ننشئ كائن DateTime مع تاريخ اليوم ووقت التحليل
  return DateTime(
    now.year,
    now.month,
    now.day,
    parsedTime.hour,
    parsedTime.minute,
    parsedTime.second,
  );
}
