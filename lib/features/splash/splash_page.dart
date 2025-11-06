import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../repositories/app_preferences_repository.dart';
import '../auth/auth_page.dart';
import '../onboarding/onboarding_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  static const String routeName = 'splash';
  static const String routePath = '/splash';

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    final AppPreferencesRepository prefs =
        ref.read(appPreferencesRepositoryProvider);
    final bool hasSeenOnboarding = prefs.hasSeenOnboarding();
    if (!mounted) {
      return;
    }
    if (!hasSeenOnboarding) {
      context.go(OnboardingPage.routePath);
      return;
    }

    final authState = ref.read(mockAuthRepositoryProvider).currentState;
    if (!mounted) {
      return;
    }
    if (authState.isAuthenticated || authState.isGuest) {
      context.go('/');
    } else {
      context.go(AuthPage.routePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SizedBox(
              height: 72,
              width: 72,
              child: CircularProgressIndicator(strokeWidth: 6),
            ),
          ],
        ),
      ),
    );
  }
}
