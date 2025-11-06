import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../repositories/mock_auth_repository.dart';
import '../../theme/app_theme.dart';
import '../auth/auth_page.dart';

class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String location = GoRouter.of(context).location;
    final int currentIndex = _indexForLocation(location);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: child),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _NeoFloatingActionButton(
        onPressed: () => _handleCreate(context, ref, l10n),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: _NeoBottomNavigation(
          currentIndex: currentIndex,
          labels: <String>[l10n.navHome, l10n.navSearch, l10n.navProfile],
          onDestinationSelected: (int index) =>
              _onDestinationTap(context, index),
        ),
      ),
    );
  }

  int _indexForLocation(String location) {
    if (location.startsWith('/search')) {
      return 1;
    }
    if (location.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }

  void _onDestinationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  void _handleCreate(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final bool isGuest = ref.read(isGuestProvider);
    final AuthState? state = ref.read(authStatusProvider).valueOrNull;
    if (state?.isAuthenticated ?? false) {
      context.go('/create');
      return;
    }

    if (isGuest || state == null) {
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
  }
}

class _NeoFloatingActionButton extends StatelessWidget {
  const _NeoFloatingActionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.black,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Colors.black, width: 3),
      ),
      child: const Icon(Icons.add, size: 32),
    );
  }
}

class _NeoBottomNavigation extends StatelessWidget {
  const _NeoBottomNavigation({
    required this.currentIndex,
    required this.labels,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final List<String> labels;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final Color background = Theme.of(context).colorScheme.background;
    final Color inactiveColor = Theme.of(context).colorScheme.onBackground;
    const List<IconData> icons = <IconData>[
      Icons.home_filled,
      Icons.search,
      Icons.person_outline,
    ];

    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(labels.length, (int index) {
          final bool selected = currentIndex == index;
          final Color color = selected ? AppTheme.primaryColor : inactiveColor;
          return Expanded(
            child: GestureDetector(
              onTap: () => onDestinationSelected(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icons[index], color: color, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    labels[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
