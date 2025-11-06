import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../auth/auth_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  static const String routeName = 'onboarding';
  static const String routePath = '/onboarding';

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(appPreferencesRepositoryProvider).setHasSeenOnboarding(true);
    if (!mounted) {
      return;
    }
    context.go(AuthPage.routePath);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final List<_OnboardingSlide> slides = <_OnboardingSlide>[
      _OnboardingSlide(
        animation: 'assets/animations/onboarding_create.json',
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
      ),
      _OnboardingSlide(
        animation: 'assets/animations/onboarding_vote.json',
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
      ),
      _OnboardingSlide(
        animation: 'assets/animations/onboarding_results.json',
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(l10n.skip),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  onPageChanged: (int index) => setState(() {
                    _currentIndex = index;
                  }),
                  itemBuilder: (BuildContext context, int index) {
                    final _OnboardingSlide slide = slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Lottie.asset(slide.animation),
                          ),
                        ),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    );
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: slides.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: theme.colorScheme.primary,
                  dotColor: Colors.black12,
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 8,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _currentIndex == 0
                          ? null
                          : () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                      child: Text(l10n.back),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex == slides.length - 1) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentIndex == slides.length - 1
                            ? l10n.getStarted
                            : l10n.next,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.animation,
    required this.title,
    required this.description,
  });

  final String animation;
  final String title;
  final String description;
}
