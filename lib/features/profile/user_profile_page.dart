import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../providers/app_providers.dart';
import '../../features/auth/auth_page.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/mock_auth_repository.dart';
import '../../widgets/poll_card.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final AsyncValue<List<Poll>> pollsState = ref.watch(userPollsProvider);
    final AsyncValue<AuthState> authState = ref.watch(authStatusProvider);
    final bool isGuest = ref.watch(isGuestProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isGuest || currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.profileTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.profileGuestTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.profileGuestDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AuthPage.routePath),
                child: Text(l10n.profileGuestLogin),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.person_outline, size: 40),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      currentUser.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      currentUser.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.createdPolls,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: pollsState.when(
                data: (List<Poll> polls) {
                  if (polls.isEmpty) {
                    return Center(child: Text(l10n.noPolls));
                  }
                  return ListView.builder(
                    itemCount: polls.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PollCard(
                        poll: polls[index],
                        authorName: currentUser.name,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) => Center(
                  child: Text(l10n.errorMessage(error.toString())),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
