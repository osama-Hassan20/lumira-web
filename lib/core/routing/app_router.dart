import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../services/login_service.dart';
import '../storage/shared_prefs.dart';
import '../utils/constants/app_strings.dart';
import 'page_transitions.dart';
import 'routes.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

// ───────────────────────────────────────────────────────────────────────────
final GlobalKey<NavigatorState> parentNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
// ───────────────────────────────────────────────────────────────────────────

final GoRouter router = GoRouter(
  navigatorKey: parentNavKey,
  observers: [routeObserver],
  initialLocation: Routes.splash,
  debugLogDiagnostics: true,

  // ─── Auth Redirect ─────────────────────────────────────────────────────────
  redirect: (context, state) {
    final location = state.matchedLocation;

    final isLoggedIn =
        SharedPrefHelper.getData(key: AppStrings.isLoggedIn) == true;
    final isGoingToLogin = location == Routes.login;

    if (location == Routes.splash) return null;
    if (!isLoggedIn && !isGoingToLogin) return Routes.login;
    if (isLoggedIn && isGoingToLogin) return Routes.home;
    return null;
  },

  routes: [
    GoRoute(
      path: Routes.splash,
      name: RouteNames.splash,
      pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen()),
    ),

    // ─── Login ───────────────────────────────────────────────────────────────
    GoRoute(
      path: Routes.login,
      name: RouteNames.login,
      pageBuilder: (context, state) => buildAnimatedPage(
        key: state.pageKey,
        child: const LoginScreen(),
        animationType: defaultTargetPlatform == TargetPlatform.iOS
            ? AnimationType.cupertino
            : AnimationType.fade,
        duration: const Duration(milliseconds: 400),
      ),
    ),
    
    // Placeholder Home route to prevent crash after login
    GoRoute(
      path: Routes.home,
      name: RouteNames.home,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: Scaffold(
          body: Center(child: Text('Home Screen (Work in Progress)')),
        ),
      ),
    ),
  ],
);
