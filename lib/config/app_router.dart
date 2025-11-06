import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/create/create_poll_page.dart';
import '../features/create/poll_settings_page.dart';
import '../features/home/home_page.dart';
import '../features/poll/poll_details_page.dart';
import '../features/poll/poll_results_page.dart';
import '../features/profile/user_profile_page.dart';

final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: HomePage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(child: HomePage());
        },
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
        path: '/profile',
        name: UserProfilePage.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(child: UserProfilePage());
        },
      ),
    ],
  );
});
