abstract class AppConfig {
  AppConfig._();

  //? replace appName with your app name
  static const String appName = 'A-to-Z New Admin';

  //? replace baseUrl with your server url

  // localhost
  // static const String baseUrl = 'http://192.168.1.205:1212/';

  // live test server
  // static const String baseUrl = 'https://atoztest.md-iraqsoft.com/';

  // live live
  static const String baseUrl = 'https://atoz.iraqsapp.com/';

  static const String appLogo =
      'assets/images/app_logo.png'; // without background
  static const String splashLogo = 'assets/gif_or_video/splash_video.mp4'; //
  // 'assets/images/512 (7)0.png'; // with background

  static const String primaryColor = '#E9B824';
  static const String secondaryColor = '#545A62';
  static const String thirdColor = '#929292';
  static const String textPrimary = '#2A2A2A';
  static const String textSecondary = '#919191';
  static const String scaffoldBackgroundColor = '#FFFFFF ';

  static const String apiVersion = 'v1/';

  //? replace bundleId with your app bundle id
  static String bundleId = 'com.mdsoft.atoznewadmin';

  /// *************** Update Manager ***************** ///

  //? replace androidVersion with your app android version
  static String androidVersion = '1.0.1';

  //? replace iosVersion with your app ios version
  static String iosVersion = '1.0.1';

  //? replace updateGooglePlayUrl with your app update url
  static String googlePlayUrl =
      "https://play.google.com/store/apps/details?id=$bundleId";

  //? replace updateAppStoreUrl with your app update url
  static String appStoreUrl = "";

  //? isForceUpdate to true if you want to force update
  static bool isForceUpdate = false;
}
