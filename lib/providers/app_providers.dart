import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../repositories/app_preferences_repository.dart';
import '../repositories/mock_auth_repository.dart';

final Provider<AppPreferencesRepository> appPreferencesRepositoryProvider =
    Provider<AppPreferencesRepository>((ref) {
  throw UnimplementedError('AppPreferencesRepository must be overridden.');
});

final Provider<MockAuthRepository> mockAuthRepositoryProvider =
    Provider<MockAuthRepository>((ref) {
  throw UnimplementedError('MockAuthRepository must be overridden.');
});

final StreamProvider<AuthState> authStatusProvider =
    StreamProvider<AuthState>((ref) {
  final MockAuthRepository repository = ref.watch(mockAuthRepositoryProvider);
  return repository.getCurrentUserStatus();
});

final Provider<User?> currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStatusProvider).maybeWhen(
        data: (AuthState state) => state.user,
        orElse: () => null,
      );
});

final Provider<bool> isGuestProvider = Provider<bool>((ref) {
  return ref.watch(authStatusProvider).maybeWhen(
        data: (AuthState state) => state.isGuest,
        orElse: () => false,
      );
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ref.watch(appPreferencesRepositoryProvider).getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.watch(appPreferencesRepositoryProvider).setThemeMode(mode);
  }
}

final NotifierProvider<ThemeModeNotifier, ThemeMode> themeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return ref.watch(appPreferencesRepositoryProvider).getLocale();
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await ref.watch(appPreferencesRepositoryProvider).setLocale(locale);
  }
}

final NotifierProvider<LocaleNotifier, Locale> localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
