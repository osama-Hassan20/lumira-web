import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/utils/constants/app_strings.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SharedPreferences sharedPreferences;
  SplashCubit({required this.sharedPreferences}) : super(const SplashState());

  static SplashCubit get(BuildContext context) => BlocProvider.of(context);

  void checkSavedData() {
    final isLoggedIn =
        sharedPreferences.getBool(AppStrings.isLoggedIn) ?? false;

    if (isLoggedIn) {
      emit(state.copyWith(navigation: SplashNavigation.binCodeLogin));
    } else {
      emit(state.copyWith(navigation: SplashNavigation.login));
    }
  }
}
