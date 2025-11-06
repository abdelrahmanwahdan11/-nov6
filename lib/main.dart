import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/app_router.dart';
import 'l10n/app_localizations.dart';
import 'models/poll.dart';
import 'models/poll_option.dart';
import 'models/user.dart';
import 'models/user_mock.dart';
import 'models/user_vote.dart';
import 'providers/app_providers.dart';
import 'repositories/app_preferences_repository.dart';
import 'repositories/mock_auth_repository.dart';
import 'repositories/mock_poll_repository.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PollAdapter());
  Hive.registerAdapter(PollOptionAdapter());
  Hive.registerAdapter(UserMockAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserVoteAdapter());

  await Hive.openBox<Poll>(pollsBoxName);
  await Hive.openBox<UserVote>(votesBoxName);
  await Hive.openBox<UserMock>(usersBoxName);
  await Hive.openBox<User>(usersAuthBoxName);
  await Hive.openBox<dynamic>(authSessionBoxName);

  final MockPollRepository repository = MockPollRepository(
    Hive.box<Poll>(pollsBoxName),
    Hive.box<UserVote>(votesBoxName),
    Hive.box<UserMock>(usersBoxName),
  );
  await repository.seed();

  final MockAuthRepository authRepository = MockAuthRepository(
    Hive.box<User>(usersAuthBoxName),
    Hive.box<dynamic>(authSessionBoxName),
  );
  await authRepository.init();

  final AppPreferencesRepository preferencesRepository =
      await AppPreferencesRepository.create();

  runApp(
    ProviderScope(
      overrides: <Override>[
        appPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        mockAuthRepositoryProvider.overrideWith((ref) {
          ref.onDispose(authRepository.dispose);
          return authRepository;
        }),
      ],
      child: const NeoBrutalistPollApp(),
    ),
  );
}

class NeoBrutalistPollApp extends ConsumerWidget {
  const NeoBrutalistPollApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final ThemeMode themeMode = ref.watch(themeProvider);
    final Locale locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Neo Brutalist Polls',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
