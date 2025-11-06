import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../repositories/mock_auth_repository.dart';
import '../../theme/app_theme.dart';
import '../auth/auth_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const String routeName = 'settings';
  static const String routePath = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeMode themeMode = ref.watch(themeProvider);
    final Locale locale = ref.watch(localeProvider);
    final AsyncValue<AuthState> authState = ref.watch(authStatusProvider);
    final bool isAuthed = authState.maybeWhen(
      data: (AuthState state) => state.isAuthenticated,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.changeLanguage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                _LanguageChip(
                  label: 'English',
                  selected: locale.languageCode == 'en',
                  onTap: () =>
                      ref.read(localeProvider.notifier).setLocale(const Locale('en')),
                ),
                const SizedBox(width: 12),
                _LanguageChip(
                  label: 'العربية',
                  selected: locale.languageCode == 'ar',
                  onTap: () =>
                      ref.read(localeProvider.notifier).setLocale(const Locale('ar')),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              l10n.darkMode,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      themeMode == ThemeMode.dark ? l10n.darkModeOn : l10n.darkModeOff,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (bool value) {
                      ref
                          .read(themeProvider.notifier)
                          .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                    },
                    activeColor: AppTheme.primaryColor,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (isAuthed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    await ref.read(mockAuthRepositoryProvider).signOut();
                    if (context.mounted) {
                      context.go(AuthPage.routePath);
                    }
                  },
                  child: Text(l10n.logout),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
