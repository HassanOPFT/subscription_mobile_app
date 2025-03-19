import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final newThemeMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    state = state.copyWith(themeMode: newThemeMode);
  }
}

// Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

// Theme configs
final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blueAccent,
  inputDecorationTheme: inputDecorationTheme,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.blueAccent,
  inputDecorationTheme: inputDecorationTheme,
);

final inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
);
