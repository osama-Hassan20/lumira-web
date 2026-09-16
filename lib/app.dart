import 'core/cubit/shared_cubit.dart';
import 'core/cubit/shared_states.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toastification/toastification.dart';
import 'config/app_config.dart';
import 'core/dependency_injection/dependency_injection.dart';
import 'core/extensions/size_provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/utils/theme/app_theme.dart';

class AtozNewAdmin extends StatefulWidget {
  const AtozNewAdmin({super.key});

  @override
  State<AtozNewAdmin> createState() => _AtozNewAdminState();
}

class _AtozNewAdminState extends State<AtozNewAdmin> {
  @override
  Widget build(context) {
    return ScreenUtilInit(
      designSize: const Size(385, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, Widget? child) {
        final mediaSize = MediaQuery.of(context).size;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt.get<SharedCubit>()),

          ],
          child: SizeProvider(
            baseSize: const Size(385, 812),
            width: mediaSize.width,
            height: mediaSize.height,
            child: ToastificationWrapper(
              child: BlocBuilder<SharedCubit, SharedState>(
                builder: (context, SharedState) => MaterialApp.router(
                  title: AppConfig.appName,
                  scaffoldMessengerKey: rootScaffoldMessengerKey,
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                  locale: SharedState.locale,
                  themeMode: ThemeMode.light,
                  theme: AppTheme.lightTheme,
                  supportedLocales: AppLocalizations.supportedLocales,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                      PointerDeviceKind.stylus,
                      PointerDeviceKind.unknown,
                    },
                  ),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  builder: (context, child) => GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    behavior: HitTestBehavior.translucent,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
