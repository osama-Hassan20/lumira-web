import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/animations/slide_transition_animation.dart';
import '../../../../../core/extensions/localization_extension.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/enum.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../../core/utils/theme/app_size.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/helpers/app_toast.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import 'animated_header.dart';
import 'auth_button_widget.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFieldEmpty =>
      _usernameController.text.trim().isEmpty ||
      _passwordController.text.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus ||
          previous.error != current.error,
      listener: (context, state) async {
        if (state.loginStatus == RequestStatus.success) {
          if (!mounted || !context.mounted) return;
          context.go(Routes.home);
        }
        if (state.loginStatus == RequestStatus.failure && state.error != null) {
          if (!mounted || !context.mounted) return;
          ShowToast.showError(messageTitle: state.error ?? 'Login failed');
          context.read<AuthCubit>().clearError();
        }
      },
      builder: (context, state) {
        final isLoading = state.loginStatus == RequestStatus.loading;
        return Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Title & subtitle ───
              AnimatedHeader(context: context),
              const SizedBox(height: AppSize.size24),

              // ─── Username Field ───
              SlideTransitionAnimation(
                duration: const Duration(milliseconds: 550),
                begin: const Offset(0, 1),
                end: Offset.zero,
                curve: Curves.easeOutCubic,
                child: CustomTextField(
                  controller: _usernameController,
                  title: context.l10n.tr('username_label'),
                  hintText: context.l10n.tr('username_hint'),
                  textInputType: TextInputType.text,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: AppImage.svg(
                      path: AppAssets.icUser,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.thirdColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم المستخدم';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSize.size16),

              // ─── Password Field ───
              SlideTransitionAnimation(
                duration: const Duration(milliseconds: 650),
                begin: const Offset(0, 1),
                end: Offset.zero,
                curve: Curves.easeOutCubic,
                child: CustomTextField(
                  controller: _passwordController,
                  title: context.l10n.tr('password_label'),
                  hintText: context.l10n.tr('password_hint'),
                  textInputType: TextInputType.visiblePassword,
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onPasswordVisibilityToggle: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: AppImage.svg(
                      path: AppAssets.lockPassword,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.thirdColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(context),
                ),
              ),
              const SizedBox(height: AppSize.size24),

              // ─── Login Button ───
              AuthButtonWidget(
                isLoading: isLoading,
                isEnabled: !_isFieldEmpty && !isLoading,
                onTap: () => _submit(context),
                title: context.l10n.tr('login_btn'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    if (_isFieldEmpty) return;
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    } else {
      setState(() => _autoValidateMode = AutovalidateMode.always);
    }
  }
}
