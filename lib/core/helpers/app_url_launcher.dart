import 'package:url_launcher/url_launcher.dart';
import 'app_toast.dart';

class AppUrlLauncher {
  AppUrlLauncher._();

  /// Launches a telephone call to the given [phoneNumber].
  static Future<void> callPhone(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      ShowToast.showError(messageTitle: 'رقم الهاتف غير صالح');
      return;
    }
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ShowToast.showError(messageTitle: 'لا يمكن الاتصال بهذا الرقم في الوقت الحالي');
      }
    } catch (e) {
      ShowToast.showError(messageTitle: 'حدث خطأ أثناء محاولة الاتصال');
    }
  }

  /// Launches a web URL in an external browser application.
  static Future<void> launchWebUrl(String url) async {
    if (url.isEmpty) {
      ShowToast.showError(messageTitle: 'الرابط غير صالح');
      return;
    }
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ShowToast.showError(messageTitle: 'لا يمكن فتح الرابط في الوقت الحالي');
      }
    } catch (e) {
      ShowToast.showError(messageTitle: 'حدث خطأ أثناء محاولة فتح الرابط');
    }
  }
}
