import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../models/user_vote.dart';
import '../../providers/app_providers.dart';
import '../../providers/poll_providers.dart';
import '../../providers/offline_providers.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../theme/app_theme.dart';
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

  Future<void> _confirmDelete(Poll poll) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      return;
    }
    final AppLocalizations l10n = AppLocalizations.of(context);
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
    await ref
        .read(mockPollRepositoryProvider)
        .deletePoll(poll.id, currentUser.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.pollDeleted),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

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
    final AppLocalizations l10n = AppLocalizations.of(context);
    final currentUser = ref.read(currentUserProvider);
    final bool isGuest = ref.read(isGuestProvider);
    if (currentUser == null || isGuest) {
      _showAuthDialog();
      return;
    }
    final bool offlineMode = ref.read(offlineModeProvider);
    if (offlineMode) {
      await ref.read(actionQueueServiceProvider).enqueueVote(
            pollId: poll.id,
            optionId: _selectedOptionId!,
            userId: currentUser.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.offlineActionQueued)),
        );
        setState(() {
          _selectedOptionId = null;
        });
      }
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
    final currentUser = ref.watch(currentUserProvider);

    final AsyncValue<Poll?> pollState = ref.watch(pollDetailsProvider(widget.pollId));
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.pollDetails),
        actions: <Widget>[
          if (currentUser != null &&
              pollState.valueOrNull?.authorId == currentUser.id)
            IconButton(
              onPressed: () {
                final Poll? poll = pollState.valueOrNull;
                if (poll != null) {
                  _confirmDelete(poll);
                }
              },
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
            ),
        ],
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
