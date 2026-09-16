// import 'package:flutter/material.dart';
// import '../routing/app_router.dart';
// import '../routing/routes.dart';

// class NotificationRouter {
//   static void handleNotificationClick(Map<String, dynamic> data) {
//     debugPrint("Notification Clicked with Data: $data");

//     final context = parentNavKey.currentContext;
//     if (context == null) return;

//     final String? transactionId = data['transactionId'];
//     final String? orderId = data['orderId'];

//     if (transactionId != null) {
//       // Navigate to Wallet tab
//       router.go(Routes.wallet);
//     } else if (orderId != null) {
//       // Navigate to Order Details
//       router.go(Routes.orderDetails, extra: {'orderId': orderId});
//     }
//   }
// }
