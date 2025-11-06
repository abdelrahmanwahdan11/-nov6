import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_page.dart';
import '../features/create/create_poll_page.dart';
import '../features/create/poll_settings_page.dart';
import '../features/home/home_page.dart';
import '../features/navigation/app_shell.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/poll/poll_details_page.dart';
import '../features/poll/poll_results_page.dart';
import '../features/preferences/settings_page.dart';
import '../features/profile/user_profile_page.dart';
import '../features/search/search_page.dart';
import '../features/splash/splash_page.dart';
import '../providers/app_providers.dart';
import '../repositories/mock_auth_repository.dart';

final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStatusProvider.stream);
  return GoRouter(
    initialLocation: SplashPage.routePath,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authStream),
    routes: <RouteBase>[
      GoRoute(
        path: SplashPage.routePath,
        name: SplashPage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(child: SplashPage());
        },
      ),
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(child: OnboardingPage());
        },
      ),
      GoRoute(
        path: AuthPage.routePath,
        name: AuthPage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(child: AuthPage());
        },
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState _, Widget child) {
          return AppShell(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            name: HomePage.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage<void>(child: HomePage());
            },
          ),
          GoRoute(
            path: '/search',
            name: SearchPage.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage<void>(child: SearchPage());
            },
          ),
          GoRoute(
            path: '/profile',
            name: UserProfilePage.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage<void>(child: UserProfilePage());
            },
          ),
        ],
      ),
      GoRoute(
        path: '/create',
        name: CreatePollPage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(child: CreatePollPage());
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'settings',
            name: PollSettingsPage.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final PollSettingsArguments args = state.extra is PollSettingsArguments
                  ? state.extra as PollSettingsArguments
                  : const PollSettingsArguments();
              return NoTransitionPage<void>(
                child: PollSettingsPage(arguments: args),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/poll/:id',
        name: PollDetailsPage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String pollId = state.pathParameters['id']!;
          return NoTransitionPage<void>(
            child: PollDetailsPage(pollId: pollId),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'results',
            name: PollResultsPage.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final String pollId = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                child: PollResultsPage(pollId: pollId),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: SettingsPage.routePath,
        name: SettingsPage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(child: SettingsPage());
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState? authState = ref.read(authStatusProvider).valueOrNull;
      final bool isAuthed = authState?.isAuthenticated ?? false;
      final bool isGuest = authState?.isGuest ?? false;
      final bool canAccessApp = isAuthed || isGuest;

      final String location = state.matchedLocation;
      final bool goingHome = location == '/' ||
          location.startsWith('/poll') ||
          location == '/create' ||
          location.startsWith('/profile') ||
          location.startsWith('/search') ||
          location == SettingsPage.routePath;
      if (!canAccessApp && goingHome) {
        return AuthPage.routePath;
      }

      if (location == AuthPage.routePath && canAccessApp) {
        return '/';
      }
      return null;
    },
  );
});
