import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/offline_providers.dart';
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
    final bool offlineModeEnabled = ref.watch(offlineModeProvider);
    final bool isAuthed = authState.maybeWhen(
      data: (AuthState state) => state.isAuthenticated,
      orElse: () => false,
    );
    final bool isGuest = ref.watch(isGuestProvider);

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
            const SizedBox(height: 32),
            Text(
              l10n.simulateNoInternet,
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
                      offlineModeEnabled
                          ? l10n.offlineModeActive
                          : l10n.offlineModeInactive,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Switch(
                    value: offlineModeEnabled,
                    onChanged: (bool value) async {
                      ref.read(offlineModeProvider.notifier).state = value;
                      if (!value) {
                        await ref.read(mockSyncServiceProvider).processQueue();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.offlineSyncComplete)),
                          );
                        }
                      }
                    },
                    activeColor: AppTheme.primaryColor,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.black, width: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: (!isAuthed || isGuest)
                    ? null
                    : () async {
                        final user = ref.read(currentUserProvider);
                        if (user == null) {
                          return;
                        }
                        final String json = await ref
                            .read(exportDataServiceProvider)
                            .generateUserJson(user.id);
                        if (!context.mounted) return;
                        await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(l10n.exportDataTitle),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: SingleChildScrollView(
                                  child: SelectableText(
                                    json,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(l10n.done),
                                ),
                              ],
                            );
                          },
                        );
                      },
                child: Text(
                  l10n.exportMyData,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
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
