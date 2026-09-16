import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_consumer.dart';
import '../storage/lang.dart';
import '../storage/shared_prefs.dart';
import '../utils/constants/app_strings.dart';
import 'shared_states.dart';

class SharedCubit extends Cubit<SharedState> {
  final SharedPreferences sharedPreferences;
  final ApiConsumer apiConsumer;

  SharedCubit({
    required this.sharedPreferences,
    required this.apiConsumer,
  }) : super(_initialState());

  static SharedState _initialState() {
    final saved = SharedPrefHelper.getData(key: AppStrings.currentLanguage);
    final locale = saved == AppStrings.english ? englishLocal : arabicLocal;
    return SharedState(locale: locale);
  }

  static SharedCubit get(BuildContext context) => BlocProvider.of(context);

  bool get isLoggedIn =>
      sharedPreferences.getBool(AppStrings.isLoggedIn) ?? false;

  Future<void> setLocale(Locale locale) async {
    await SharedPrefHelper.saveData(
      key: AppStrings.currentLanguage,
      value: locale.languageCode,
    );
    emit(state.copyWith(locale: locale));
  }
}
