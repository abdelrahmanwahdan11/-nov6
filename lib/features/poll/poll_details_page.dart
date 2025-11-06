import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../models/user_vote.dart';
import '../../providers/app_providers.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../widgets/poll_option_tile.dart';
import '../auth/auth_page.dart';

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
    final currentUser = ref.read(currentUserProvider);
    final bool isGuest = ref.read(isGuestProvider);
    if (currentUser == null || isGuest) {
      _showAuthDialog();
      return;
    }
    final repository = ref.read(mockPollRepositoryProvider);
    await repository.addVote(
      pollId: poll.id,
      optionId: _selectedOptionId!,
      userId: currentUser.id,
    );
    if (!mounted) return;
    await ref.read(userVoteProvider(widget.pollId).notifier).refresh();
    if (!mounted) return;
    context.go('/poll/${poll.id}/results');
  }

  void _showAuthDialog() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.loginRequiredTitle),
        content: Text(l10n.loginRequiredMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AuthPage.routePath);
            },
            child: Text(l10n.login),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isGuest = ref.watch(isGuestProvider);

    final AsyncValue<Poll?> pollState = ref.watch(pollDetailsProvider(widget.pollId));
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);

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
          final String authorName =
              repository.getUserById(poll.authorId)?.name ?? l10n.defaultUserName;
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
                  l10n.createdBy(authorName),
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
                    child: Text(isGuest ? l10n.login : l10n.vote),
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
