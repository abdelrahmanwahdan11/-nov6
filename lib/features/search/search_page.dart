import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../theme/app_theme.dart';
import '../../widgets/poll_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  static const String routeName = 'search';

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String query = ref.watch(searchQueryProvider);
    final AsyncValue<List<Poll>> results =
        ref.watch(searchResultsProvider(query));
    final MockPollRepository repository =
        ref.watch(mockPollRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.searchTitle,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            onChanged: (String value) =>
                ref.read(searchQueryProvider.notifier).state = value,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              hintText: l10n.searchHint,
              filled: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.black, width: 3),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.black, width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 3),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: query.trim().isEmpty
                ? _SearchPlaceholder(l10n: l10n)
                : results.when(
                    data: (List<Poll> polls) {
                      if (polls.isEmpty) {
                        return _SearchEmpty(l10n: l10n, query: query);
                      }
                      return ListView.separated(
                        itemCount: polls.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        padding: const EdgeInsets.only(bottom: 200),
                        itemBuilder: (BuildContext context, int index) {
                          final Poll poll = polls[index];
                          final String authorName =
                              repository.getUserById(poll.authorId)?.name ??
                                  l10n.defaultUserName;
                          return PollCard(
                            poll: poll,
                            authorName: authorName,
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

class _SearchPlaceholder extends StatelessWidget {
  const _SearchPlaceholder({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            'assets/illustrations/thinker.svg',
            height: 160,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.searchPrompt,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SearchEmpty extends StatelessWidget {
  const _SearchEmpty({required this.l10n, required this.query});

  final AppLocalizations l10n;
  final String query;

  @override
  Widget build(BuildContext context) {
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
            l10n.searchEmpty(query),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
