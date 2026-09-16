// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import '../../firebase_options.dart';
// import '../storage/shared_prefs.dart';
// import '../utils/constants/app_strings.dart';
// import '../utils/enum.dart';
// import 'notification_constants.dart';
// import 'notification_refresh_stream.dart';
// import 'notification_router.dart';

// // معالج الخلفية - يعمل في Isolate منفصل
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// }

// class NotificationManager {
//   static final _localNotifications = FlutterLocalNotificationsPlugin();
//   static final _messaging = FirebaseMessaging.instance;
//   static bool _isInitialized = false;

//   /// تهيئة شاملة لكل شيء في سطر واحد
//   static Future<void> initialize() async {
//     if (_isInitialized) return;

//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );

//     // 1. إعدادات الإشعارات المحلية
//     const androidInit = AndroidInitializationSettings(
//       NotificationConstants.appIcon,
//     );
//     const iosInit = DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );

//     await _localNotifications.initialize(
//       settings: const InitializationSettings(
//         android: androidInit,
//         iOS: iosInit,
//       ),
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload != null) {
//           final data = jsonDecode(details.payload!);
//           NotificationRouter.handleNotificationClick(data);
//         }
//       },
//     );

//     // 2. طباعة التوكن للتيست من Firebase Console
//     final token = await _messaging.getToken();
//     log("========== FCM TOKEN ==========");
//     log(token ?? "Token is null");
//     log("===============================");

//     // 4. الاستماع للإشعارات في جميع الحالات
//     FirebaseMessaging.onMessage.listen(_showLocalNotification);

//     FirebaseMessaging.onMessageOpenedApp.listen((msg) {
//       NotificationRouter.handleNotificationClick(msg.data);
//     });

//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       NotificationRouter.handleNotificationClick(initialMessage.data);
//     }

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     _isInitialized = true;
//     log("Notification Manager Initialized Successfully");
//   }

//   /// طلب صلاحيات الإشعارات - يُستدعى بعد تسجيل الدخول
//   static Future<void> requestPermission() async {
//     await _messaging.requestPermission(alert: true, badge: true, sound: true);
//     log("Notification permission requested");
//   }

//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     try {
//       final notification = message.notification;
//       if (notification == null) return;

//       // تحديث بيانات المستخدم تلقائيًا عند وصول إشعار معاملة
//       final data = message.data;
//       log('===== Notification Data =====');
//       log(jsonEncode(data));
//       log('=============================');
//       if ((data.containsKey('transactionId') &&
//               data['transactionId'] != null &&
//               data['transactionId'].toString().isNotEmpty) ||
//           (data.containsKey('orderId') &&
//               data['orderId'] != null &&
//               data['orderId'].toString().isNotEmpty)) {
//         log(
//           'Transaction notification received in foreground — refreshing user info',
//         );
//         NotificationRefreshStream.emit();
//       }

//       // Set notification badge flag
//       // ignore: unawaited_futures
//       await SharedPrefHelper.saveData(
//         key: AppStrings.isNotification,
//         value: true,
//       );

//       // إظهار الإشعار المحلي
//       await _localNotifications.show(
//         id: notification.hashCode,
//         title: notification.title,
//         body: notification.body,
//         notificationDetails: NotificationDetails(
//           android: AndroidNotificationDetails(
//             NotificationConstants.channelId,
//             NotificationConstants.channelName,
//             importance: Importance.max,
//             priority: Priority.high,
//             color: NotificationConstants.primaryColor,
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true, // تفعيل خاصية الـ Badge في الـ iOS
//             presentSound: true,
//           ),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     } catch (e) {
//       _showFallback(message);
//     }
//   }

//   /// إشعار احتياطي بسيط في حال فشل الأساسي
//   static void _showFallback(RemoteMessage message) {
//     _localNotifications.show(
//       id: 0,
//       title: message.notification?.title ?? "Notification",
//       body: message.notification?.body,
//       notificationDetails: const NotificationDetails(
//         android: AndroidNotificationDetails('fallback', 'Backup'),
//       ),
//     );
//   }

//   /// الاشتراك في المواضيع بناءً على الدور المعطى
//   static Future<void> subscribeToRole(String id, String role) async {
//     if (role == UserRoles.user.name) {
//       print("Subscribing to user topic $id");
//       await _messaging.subscribeToTopic(NotificationConstants.userTopic(id));
//       await _messaging.subscribeToTopic(NotificationConstants.allUsersTopic);
//     } else if (role == UserRoles.agent.name) {
//       await _messaging.subscribeToTopic(NotificationConstants.agentTopic(id));
//       await _messaging.subscribeToTopic(NotificationConstants.allAgentsTopic);
//     }
//   }

//   /// إلغاء الاشتراك عند الخروج
//   /// إلغاء الاشتراك عند الخروج
//   static Future<void> unsubscribeFromRole(String id, String role) async {
//     if (role == UserRoles.agent.name) {
//       // إلغاء الاشتراك من موضوع الوكيل الخاص والموضوع العام للوكلاء
//       await _messaging.unsubscribeFromTopic(
//         NotificationConstants.agentTopic(id),
//       );
//       await _messaging.unsubscribeFromTopic(
//         NotificationConstants.allAgentsTopic,
//       );
//     } else {
//       // إلغاء الاشتراك من موضوع المستخدم الخاص والموضوع العام للمستخدمين
//       await _messaging.unsubscribeFromTopic(
//         NotificationConstants.userTopic(id),
//       );
//       await _messaging.unsubscribeFromTopic(
//         NotificationConstants.allUsersTopic,
//       );
//     }
//   }
// }
