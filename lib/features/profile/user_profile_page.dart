import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_page.dart';
import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../providers/app_providers.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../theme/app_theme.dart';
import '../../widgets/poll_card.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final bool isGuest = ref.watch(isGuestProvider);
    final AsyncValue<List<Poll>> pollsState = ref.watch(myPollsProvider);
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);

    if (isGuest || currentUser == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 140),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/illustrations/thinker.svg',
                height: 160,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.profileGuestTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.profileGuestDescription,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
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

    Future<void> confirmDelete(Poll poll) async {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(l10n.deletePollTitle),
          content: Text(l10n.deletePollMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.keepPoll),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        return;
      }
      await repository.deletePoll(poll.id, currentUser.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pollDeleted),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.profileTitle,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    color: AppTheme.mustard,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: const Icon(Icons.person_outline, size: 40),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        currentUser.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentUser.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.myPolls,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: pollsState.when(
              data: (List<Poll> polls) {
                if (polls.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/illustrations/cat_sleep.svg',
                          height: 150,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.profileEmptyTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => context.go('/create'),
                          child: Text(l10n.createButton),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: polls.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  padding: const EdgeInsets.only(bottom: 180),
                  itemBuilder: (BuildContext context, int index) {
                    final Poll poll = polls[index];
                    return PollCard(
                      poll: poll,
                      authorName: currentUser.name,
                      onDelete: () => confirmDelete(poll),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: SpinKitThreeBounce(
                  color: AppTheme.primaryColor,
                  size: 26,
                ),
              ),
              error: (Object error, StackTrace stackTrace) => Center(
                child: Text(l10n.errorMessage(error.toString())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
