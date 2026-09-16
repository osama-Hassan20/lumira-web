import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
// تأكد من استيراد ملف الراوتر حيث يوجد parentNavKey
import '../../core/routing/app_router.dart';

class ShowToast {
  // دالة خاصة لجلب السياق الحالي من الـ NavigatorKey
  static BuildContext? get _context => parentNavKey.currentContext;

  static ScaffoldMessengerState? get _messenger =>
      rootScaffoldMessengerKey.currentState;

  // لمنع تكرار نفس رسالة الخطأ خلال فترة قصيرة
  static String? _lastErrorMessage;
  static DateTime? _lastErrorTime;

  // دالة لعرض تنبيه النجاح
  static void showSuccess({
    required String messageTitle,
    String? messageDescription,
    BuildContext? context,
  }) {
    final resolvedContext = context ?? _context;
    if (resolvedContext == null) return;

    try {
      toastification.dismissAll();
      toastification.show(
        context: resolvedContext,
        type: ToastificationType.success,
        title: Text(messageTitle),
        description: messageDescription == null
            ? null
            : Text(messageDescription),
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );
    } catch (_) {
      _messenger?.clearSnackBars();
      _messenger?.showSnackBar(SnackBar(content: Text(messageTitle)));
    }
  }

  // دالة لعرض تنبيه الخطأ (تتجنب التكرار السريع لنفس الرسالة)
  static void showError({
    required String? messageTitle,
    String? messageDescription,
    BuildContext? context,
  }) {
    if (messageTitle == null || messageTitle.isEmpty) return;

    final resolvedContext = context ?? _context;
    if (resolvedContext == null) return;

    final now = DateTime.now();
    // إذا كانت نفس الرسالة معروضة خلال آخر ثانيتين، تجاهلها
    if (_lastErrorMessage == messageTitle &&
        _lastErrorTime != null &&
        now.difference(_lastErrorTime!) < const Duration(seconds: 2)) {
      return;
    }

    _lastErrorMessage = messageTitle;
    _lastErrorTime = now;

    try {
      toastification.dismissAll();
      toastification.show(
        context: resolvedContext,
        type: ToastificationType.error,
        title: Text(messageTitle),
        description: messageDescription == null
            ? null
            : Text(messageDescription),
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );
    } catch (_) {
      _messenger?.clearSnackBars();
      _messenger?.showSnackBar(SnackBar(content: Text(messageTitle)));
    }

    // مسح العلامة بعد انتهاء مدة العرض حتى تسمح بنفس الرسالة لاحقاً
    Future.delayed(const Duration(seconds: 3), () {
      // فقط مسح إذا لم يتم عرض رسالة جديدة منذ ذلك الحين
      if (_lastErrorTime != null &&
          DateTime.now().difference(_lastErrorTime!) >=
              const Duration(seconds: 3)) {
        _lastErrorMessage = null;
        _lastErrorTime = null;
      }
    });
  }

  // دالة لعرض ملاحظة/معلومات
  static void showNote({
    required String messageTitle,
    String? messageDescription,
    bool unlimited = false,
    BuildContext? context,
  }) {
    final resolvedContext = context ?? _context;
    if (resolvedContext == null) return;

    try {
      toastification.dismissAll();
      toastification.show(
        context: resolvedContext,
        type: ToastificationType.info,
        title: Text(
          messageTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        description: messageDescription == null
            ? null
            : Text(messageDescription),
        style: unlimited
            ? ToastificationStyle.flatColored
            : ToastificationStyle.minimal,
        autoCloseDuration: unlimited ? null : const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );
    } catch (_) {
      _messenger?.clearSnackBars();
      _messenger?.showSnackBar(SnackBar(content: Text(messageTitle)));
    }
  }

  // دالة لعرض تحذير
  static void showWarning({
    required String messageTitle,
    String? messageDescription,
    bool unlimited = false,
    BuildContext? context,
  }) {
    final resolvedContext = context ?? _context;
    if (resolvedContext == null) return;

    try {
      toastification.dismissAll();
      toastification.show(
        context: resolvedContext,
        type: ToastificationType.warning,
        title: Text(messageTitle),
        description: messageDescription == null
            ? null
            : Text(messageDescription),
        style: ToastificationStyle.minimal,
        autoCloseDuration: unlimited ? null : const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );
    } catch (_) {
      _messenger?.clearSnackBars();
      _messenger?.showSnackBar(SnackBar(content: Text(messageTitle)));
    }
  }

  // دالة لعرض تنبيه مخصص
  static void showCustomToast(Widget toastContent) {
    if (_context == null) return;

    toastification.showCustom(
      context: _context!,
      autoCloseDuration: const Duration(seconds: 5),
      alignment: Alignment.topRight,
      builder: (BuildContext context, ToastificationItem holder) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.blue,
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          child: toastContent,
        );
      },
    );
  }
}
