import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../cubit/splash_cubit/splash_cubit.dart';
import '../cubit/splash_cubit/splash_state.dart';
import 'widgets/splash_screen_mix.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashCubit>(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) =>
            previous.navigation != current.navigation,
        listener: (context, state) {
          if (state.navigation == SplashNavigation.home) {
            context.go(Routes.home);
          } else if (state.navigation == SplashNavigation.login ||
              state.navigation == SplashNavigation.binCodeLogin) {
            context.go(Routes.login);
          }
        },
        child: const Scaffold(
          backgroundColor: AppColors.white,
          body: SplashScreenAnimated(),
        ),
      ),
    );
  }
}
