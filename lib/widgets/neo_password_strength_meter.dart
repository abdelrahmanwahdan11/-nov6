import 'package:flutter/material.dart';

import '../features/auth/password_strength.dart';
import '../theme/app_theme.dart';

class NeoPasswordStrengthMeter extends StatelessWidget {
  const NeoPasswordStrengthMeter({
    super.key,
    required this.level,
  });

  final PasswordStrengthLevel level;

  Color get _activeColor {
    return level.map<Color>(
      weak: () => Colors.black,
      medium: () => AppTheme.primaryColor,
      strong: () => AppTheme.highlightGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int activeSegments = activeSegmentsForStrength(level);
    final ThemeData theme = Theme.of(context);
    final Color inactiveColor = theme.colorScheme.surface;
    final Color borderColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.onSurface
        : Colors.black;
    return Row(
      children: List<Widget>.generate(3, (int index) {
        final bool isActive = index < activeSegments;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
            height: 14,
            decoration: BoxDecoration(
              color: isActive ? _activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
          ),
        );
      }),
    );
  }
}
