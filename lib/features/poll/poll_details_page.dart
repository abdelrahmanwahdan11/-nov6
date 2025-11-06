import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../models/user_mock.dart';
import '../../models/user_vote.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../widgets/poll_option_tile.dart';

class PollDetailsPage extends ConsumerStatefulWidget {
  const PollDetailsPage({super.key, required this.pollId});

  static const String routeName = 'poll';

  final String pollId;

  @override
  ConsumerState<PollDetailsPage> createState() => _PollDetailsPageState();
}

class _PollDetailsPageState extends ConsumerState<PollDetailsPage> {
  String? _selectedOptionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userVote = ref.read(userVoteProvider(widget.pollId));
      if (userVote != null && mounted) {
        context.go('/poll/${widget.pollId}/results');
      }
    });
    ref.listen<UserVote?>(
      userVoteProvider(widget.pollId),
      (UserVote? previous, UserVote? next) {
        if (next != null && mounted) {
          context.go('/poll/${widget.pollId}/results');
        }
      },
    );
  }

  Future<void> _submitVote(Poll poll) async {
    if (_selectedOptionId == null) {
      return;
    }
    final repository = ref.read(mockPollRepositoryProvider);
    await repository.addVote(
      pollId: poll.id,
      optionId: _selectedOptionId!,
      userId: currentUserId,
    );
    if (!mounted) return;
    await ref.read(userVoteProvider(widget.pollId).notifier).refresh();
    if (!mounted) return;
    context.go('/poll/${poll.id}/results');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final UserMock? user = ref.watch(userProvider);

    final AsyncValue<Poll?> pollState = ref.watch(pollDetailsProvider(widget.pollId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pollDetails),
      ),
      body: pollState.when(
        data: (Poll? poll) {
          if (poll == null) {
            return Center(child: Text(l10n.noPolls));
          }
          final Duration remaining = poll.endDate.difference(DateTime.now());
          final int hours = remaining.inHours < 0 ? 0 : remaining.inHours;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  poll.question,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.createdBy(user?.name ?? l10n.defaultUserName),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(l10n.endsInHours(hours)),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: poll.options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final option = poll.options[index];
                      return PollOptionTile(
                        text: option.text,
                        selected: _selectedOptionId == option.id,
                        onTap: () {
                          setState(() {
                            _selectedOptionId = option.id;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedOptionId == null
                        ? null
                        : () => _submitVote(poll),
                    child: Text(l10n.vote),
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
