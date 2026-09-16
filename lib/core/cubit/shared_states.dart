import 'package:flutter/material.dart';

class SharedState {
  final Locale locale;

  const SharedState({
    this.locale = const Locale('ar', 'EG'),
  });

  SharedState copyWith({
    Locale? locale,
  }) {
    return SharedState(
      locale: locale ?? this.locale,
    );
  }
}
