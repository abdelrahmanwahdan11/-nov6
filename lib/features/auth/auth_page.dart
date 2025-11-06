import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_password_strength_meter.dart';
import 'password_strength.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  static const String routeName = 'auth';
  static const String routePath = '/auth';

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();

  bool _loginLoading = false;
  bool _signupLoading = false;
  bool _loginPasswordVisible = false;
  bool _signupPasswordVisible = false;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loginLoading = true;
    });
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(mockAuthRepositoryProvider).login(
            email: _loginEmailController.text,
            password: _loginPasswordController.text,
          );
      if (!mounted) {
        return;
      }
      context.go('/');
    } on StateError catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(_mapAuthError(error.message ?? '', l10n))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loginLoading = false;
        });
      }
    }
  }

  Future<void> _handleSignup() async {
    if (!_signupFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _signupLoading = true;
    });
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(mockAuthRepositoryProvider).signUp(
            name: _signupNameController.text,
            email: _signupEmailController.text,
            password: _signupPasswordController.text,
          );
      if (!mounted) {
        return;
      }
      context.go('/');
    } on StateError catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(_mapAuthError(error.message ?? '', l10n))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _signupLoading = false;
        });
      }
    }
  }

  String _mapAuthError(String code, AppLocalizations l10n) {
    switch (code) {
      case 'email-already-used':
        return l10n.authEmailInUse;
      case 'user-not-found':
        return l10n.authUserNotFound;
      case 'invalid-password':
        return l10n.authInvalidPassword;
      default:
        return l10n.genericError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.brandLabel,
                  style: theme.textTheme.displayLarge,
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.surface,
                  ),
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        labelStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                        indicatorColor: Colors.black,
                        indicatorWeight: 3,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black54,
                        tabs: <Widget>[
                          Tab(text: l10n.login),
                          Tab(text: l10n.signup),
                        ],
                      ),
                      const Divider(height: 1, thickness: 2),
                      SizedBox(
                        height: 380,
                        child: TabBarView(
                          children: <Widget>[
                            _buildLoginForm(theme, l10n),
                            _buildSignupForm(theme, l10n),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () async {
                    await ref.read(mockAuthRepositoryProvider).continueAsGuest();
                    if (!mounted) {
                      return;
                    }
                    context.go('/');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l10n.continueAsGuest),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: <Widget>[
            _NeoField(
              controller: _loginEmailController,
              label: l10n.email,
              keyboardType: TextInputType.emailAddress,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return l10n.validationRequired;
                }
                if (!value.contains('@')) {
                  return l10n.validationEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _NeoField(
              controller: _loginPasswordController,
              label: l10n.password,
              obscureText: !_loginPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _loginPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _loginPasswordVisible = !_loginPasswordVisible;
                  });
                },
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return l10n.validationRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loginLoading ? null : _handleLogin,
                child: _loginLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.login),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm(ThemeData theme, AppLocalizations l10n) {
    final String password = _signupPasswordController.text;
    final PasswordStrengthLevel strength =
        evaluatePasswordStrength(password);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _NeoField(
              controller: _signupNameController,
              label: l10n.name,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.validationRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _NeoField(
              controller: _signupEmailController,
              label: l10n.email,
              keyboardType: TextInputType.emailAddress,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return l10n.validationRequired;
                }
                if (!value.contains('@')) {
                  return l10n.validationEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _NeoField(
              controller: _signupPasswordController,
              label: l10n.password,
              obscureText: !_signupPasswordVisible,
              onChanged: (String value) => setState(() {}),
              suffixIcon: IconButton(
                icon: Icon(
                  _signupPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _signupPasswordVisible = !_signupPasswordVisible;
                  });
                },
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return l10n.validationRequired;
                }
                if (value.length < 6) {
                  return l10n.validationPasswordLength;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text(
              l10n.passwordStrengthLabel,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            NeoPasswordStrengthMeter(level: strength),
            const SizedBox(height: 8),
            Text(
              _strengthLabel(strength, l10n),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signupLoading ? null : _handleSignup,
                child: _signupLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.signup),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _strengthLabel(
      PasswordStrengthLevel strength, AppLocalizations l10n) {
    return strength.map<String>(
      weak: () => l10n.weak,
      medium: () => l10n.medium,
      strong: () => l10n.strong,
    );
  }
}

class _NeoField extends StatelessWidget {
  const _NeoField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      onChanged: onChanged,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.titleMedium,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 3),
        ),
      ),
    );
  }
}

