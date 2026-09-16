import 'dart:async';
import 'package:flutter/material.dart';

import '../extensions/date_time_formatter.dart';

class SmartTimeText extends StatefulWidget {
  final DateTime date;
  final TextStyle? style;

  const SmartTimeText({super.key, required this.date, this.style});

  @override
  State<SmartTimeText> createState() => _SmartTimeTextState();
}

class _SmartTimeTextState extends State<SmartTimeText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  void _startTimerIfNeeded() {
    final difference = DateTime.now().difference(widget.date);

    // بنشغل التايمر فقط لو الوقت بقاله أقل من 24 ساعة
    if (difference.inDays < 1) {
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (mounted) {
          setState(() {});

          // تحسين إضافي: لو الوقت عدى يوم وأحنا شغالين، وقف التايمر
          if (DateTime.now().difference(widget.date).inDays >= 1) {
            _timer?.cancel();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // تنظيف الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.date.toArabicSmart(), style: widget.style);
  }
}
