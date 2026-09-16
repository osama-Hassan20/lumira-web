import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'config/bloc_observer.dart';
import 'core/dependency_injection/dependency_injection.dart';
import 'core/storage/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  await SharedPrefHelper.init();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await setupDependencyInjection();


  // Configure window settings for Desktop platforms using window_manager
  // if (!kIsWeb) {
  //   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //     await windowManager.ensureInitialized();
  //     WindowOptions windowOptions = const WindowOptions(
  //       size: Size(916, 700),
  //       minimumSize: Size(516, 600),
  //       center: true,
  //       backgroundColor: Colors.transparent,
  //       skipTaskbar: false,
  //       titleBarStyle: TitleBarStyle.normal,
  //       title: 'A-to-Z New Admin',
  //     );
  //     await windowManager.waitUntilReadyToShow(windowOptions, () async {
  //       await windowManager.show();
  //       await windowManager.focus();
  //     });
  //   }
  // }

  // Initialize notifications (not supported on web)
  // if (!kIsWeb) {
  //   await NotificationManager.initialize();
  // }

  runApp(const AtozNewAdmin());
}
