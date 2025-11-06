import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../models/user_mock.dart';
import '../../providers/poll_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/poll_result_bar.dart';

class PollResultsPage extends ConsumerWidget {
  const PollResultsPage({super.key, required this.pollId});

  static const String routeName = 'results';

  final String pollId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<Poll?> pollState = ref.watch(pollDetailsProvider(pollId));
    final UserMock? user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pollDetails),
      ),
      body: pollState.when(
        data: (Poll? poll) {
          if (poll == null) {
            return Center(child: Text(l10n.noPolls));
          }
          final int totalVotes = poll.options.fold<int>(
            0,
            (int previousValue, option) => previousValue + option.voteCount,
          );
          final int topVotes = poll.options.fold<int>(
            0,
            (int previousValue, option) => max(previousValue, option.voteCount),
          );
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  poll.question,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.createdBy(user?.name ?? l10n.defaultUserName),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.endsInHours(
                    max(0, poll.endDate.difference(DateTime.now()).inHours),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(
                          'assets/illustrations/cat_sleep.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...poll.options.map((option) {
                        final double percentage = totalVotes == 0
                            ? 0
                            : (option.voteCount / totalVotes) * 100;
                        final bool isWinner = option.voteCount == topVotes;
                        return PollResultBar(
                          optionText: option.text,
                          percentage: percentage,
                          isWinner: isWinner,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppTheme.mustard,
                    ),
                    onPressed: () {},
                    child: Text(l10n.thanksForResponse),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Text(l10n.errorMessage(error.toString())),
        ),
      ),
    );
  }
}
