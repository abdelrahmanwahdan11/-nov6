import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../models/user_mock.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../widgets/poll_card.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final UserMock? user = ref.watch(userProvider);
    final AsyncValue<List<Poll>> pollsState = ref.watch(userPollsProvider);

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
                      user?.name ?? l10n.defaultUserName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      user?.id ?? currentUserId,
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
                        authorName: user?.name ?? l10n.defaultUserName,
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
