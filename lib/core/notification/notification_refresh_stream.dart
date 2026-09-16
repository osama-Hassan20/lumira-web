// import 'dart:async';

// /// بث أحداث تحديث بيانات المستخدم عند وصول إشعار معاملة (foreground)
// class NotificationRefreshStream {
//   NotificationRefreshStream._();

//   static final _controller = StreamController<void>.broadcast();

//   /// الاستماع لأحداث التحديث
//   static Stream<void> get stream => _controller.stream;

//   /// إرسال حدث تحديث
//   static void emit() => _controller.add(null);
// }
