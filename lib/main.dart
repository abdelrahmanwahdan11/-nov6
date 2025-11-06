import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/app_router.dart';
import 'l10n/app_localizations.dart';
import 'models/poll.dart';
import 'models/poll_option.dart';
import 'models/user_mock.dart';
import 'models/user_vote.dart';
import 'repositories/mock_poll_repository.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PollAdapter());
  Hive.registerAdapter(PollOptionAdapter());
  Hive.registerAdapter(UserMockAdapter());
  Hive.registerAdapter(UserVoteAdapter());

  await Hive.openBox<Poll>(pollsBoxName);
  await Hive.openBox<UserVote>(votesBoxName);
  await Hive.openBox<UserMock>(usersBoxName);

  final MockPollRepository repository = MockPollRepository(
    Hive.box<Poll>(pollsBoxName),
    Hive.box<UserVote>(votesBoxName),
    Hive.box<UserMock>(usersBoxName),
  );
  await repository.seed();

  runApp(const ProviderScope(child: NeoBrutalistPollApp()));
}

class NeoBrutalistPollApp extends ConsumerWidget {
  const NeoBrutalistPollApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Neo Brutalist Polls',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
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
