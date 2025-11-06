import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../l10n/app_localizations.dart';
import '../../models/poll.dart';
import '../../providers/app_providers.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/app_preferences_repository.dart';
import '../../repositories/mock_auth_repository.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../theme/app_theme.dart';
import '../../widgets/poll_card.dart';
import '../auth/auth_page.dart';
import '../preferences/settings_page.dart';
import '../profile/user_profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ShowCaseWidgetState> _showCaseKey =
      GlobalKey<ShowCaseWidgetState>();
  final GlobalKey _createKey = GlobalKey();
  final GlobalKey _firstPollKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  ProviderSubscription<AsyncValue<List<Poll>>>? _pollsSubscription;
  bool _tourScheduled = false;
  bool _waitingForLayout = false;

  @override
  void initState() {
    super.initState();
    _pollsSubscription = ref.listen<AsyncValue<List<Poll>>>(
      pollListProvider,
      (AsyncValue<List<Poll>>? previous, AsyncValue<List<Poll>> next) {
        if (_tourScheduled) {
          return;
        }
        next.when(
          data: (List<Poll> polls) {
            _tourScheduled = true;
            _queueTour();
          },
          loading: () {},
          error: (Object _, StackTrace __) {},
        );
      },
      fireImmediately: true,
    );
  }

  Future<void> _queueTour() async {
    if (!mounted) {
      return;
    }
    final AppPreferencesRepository prefs =
        ref.read(appPreferencesRepositoryProvider);
    if (prefs.hasSeenAppTour()) {
      await _closePollSubscription();
      return;
    }

    final ShowCaseWidgetState? state = _showCaseKey.currentState;
    if (state == null) {
      if (_waitingForLayout) {
        return;
      }
      _waitingForLayout = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _waitingForLayout = false;
        _queueTour();
      });
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) {
      return;
    }
    state.startShowCase(<GlobalKey>[_createKey, _firstPollKey, _settingsKey]);
    await prefs.setHasSeenAppTour(true);
    await _closePollSubscription();
  }

  Future<void> _closePollSubscription() async {
    if (_pollsSubscription != null) {
      await _pollsSubscription!.close();
      _pollsSubscription = null;
    }
  }

  @override
  void dispose() {
    _pollsSubscription?.close();
    super.dispose();
  }

  void _handleCreate(AppLocalizations l10n) {
    final bool isGuest = ref.read(isGuestProvider);
    final AuthState? state = ref.read(authStatusProvider).valueOrNull;
    if (state?.isAuthenticated ?? false) {
      context.push('/create');
      return;
    }
    if (isGuest || state == null) {
      _showAuthRequiredDialog(l10n);
    }
  }

  void _showAuthRequiredDialog(AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ShowCaseWidget(
      key: _showCaseKey,
      blurValue: 2,
      builder: Builder(
        builder: (BuildContext context) {
          return ScreenTypeLayout.builder(
            mobile: (_) => _HomeBody(
              l10n: l10n,
              createKey: _createKey,
              firstPollKey: _firstPollKey,
              settingsKey: _settingsKey,
              onCreate: () => _handleCreate(l10n),
            ),
            tablet: (_) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: _HomeBody(
                  l10n: l10n,
                  createKey: _createKey,
                  firstPollKey: _firstPollKey,
                  settingsKey: _settingsKey,
                  onCreate: () => _handleCreate(l10n),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({
    required this.l10n,
    required this.createKey,
    required this.firstPollKey,
    required this.settingsKey,
    required this.onCreate,
  });

  final AppLocalizations l10n;
  final GlobalKey createKey;
  final GlobalKey firstPollKey;
  final GlobalKey settingsKey;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Poll>> pollsState = ref.watch(pollListProvider);
    final bool isGuest = ref.watch(isGuestProvider);
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                l10n.brandLabel,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.goNamed(UserProfilePage.routeName),
            icon: const Icon(Icons.person_outline),
          ),
          Showcase(
            key: settingsKey,
            description: l10n.tourSettings,
            child: IconButton(
              onPressed: () => context.push(SettingsPage.routePath),
              icon: const Icon(Icons.settings_outlined),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isGuest)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2.5),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.guestWarning,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AuthPage.routePath),
                      child: Text(l10n.login),
                    ),
                  ],
                ),
              ),
            Text(
              l10n.collectIdeasTitle,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.collectIdeasSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppTheme.mustard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black, width: 3),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SvgPicture.asset(
                      'assets/illustrations/thinker.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          l10n.heroBadge,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Showcase(
                          key: createKey,
                          description: l10n.tourCreate,
                          child: ElevatedButton(
                            onPressed: onCreate,
                            child: Text(l10n.createButton.toUpperCase()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.popularPolls,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            pollsState.when(
              data: (List<Poll> polls) {
                if (polls.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(l10n.noPolls),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: polls.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Poll poll = polls[index];
                    final String authorName =
                        repository.getUserById(poll.authorId)?.name ??
                            l10n.defaultUserName;
                    final Widget card = PollCard(
                      poll: poll,
                      authorName: authorName,
                    );
                    if (index == 0) {
                      return Showcase(
                        key: firstPollKey,
                        description: l10n.tourPoll,
                        child: card,
                      );
                    }
                    return card;
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(l10n.errorMessage(error.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
