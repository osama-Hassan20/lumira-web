import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/auth_responsive_scaffold.dart';
import 'widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: const AuthResponsiveScaffold(
        child: LoginScreenBody(),
      ),
    );
  }
}
