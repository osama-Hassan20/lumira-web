enum SplashNavigation { initial, login, home, binCodeLogin }

class SplashState {
  final SplashNavigation navigation;

  const SplashState({this.navigation = SplashNavigation.initial});

  SplashState copyWith({SplashNavigation? navigation}) {
    return SplashState(navigation: navigation ?? this.navigation);
  }
}
