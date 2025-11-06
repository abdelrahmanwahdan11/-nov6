enum PasswordStrengthLevel { weak, medium, strong }

PasswordStrengthLevel evaluatePasswordStrength(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) {
    return PasswordStrengthLevel.weak;
  }
  final bool hasLetters = RegExp(r'[A-Za-z]').hasMatch(trimmed);
  final bool hasNumbers = RegExp(r'[0-9]').hasMatch(trimmed);
  final bool hasSymbols =
      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\];\'`~+=]').hasMatch(trimmed);

  if (trimmed.length >= 10 && hasLetters && hasNumbers && hasSymbols) {
    return PasswordStrengthLevel.strong;
  }
  if (trimmed.length >= 8 && hasLetters && hasNumbers) {
    return PasswordStrengthLevel.medium;
  }
  return PasswordStrengthLevel.weak;
}

int activeSegmentsForStrength(PasswordStrengthLevel strength) {
  return const <PasswordStrengthLevel, int>{
        PasswordStrengthLevel.weak: 1,
        PasswordStrengthLevel.medium: 2,
        PasswordStrengthLevel.strong: 3,
      }[strength] ?? 1;
}

extension PasswordStrengthLevelLabel on PasswordStrengthLevel {
  T map<T>({
    required T Function() weak,
    required T Function() medium,
    required T Function() strong,
  }) {
    switch (this) {
      case PasswordStrengthLevel.weak:
        return weak();
      case PasswordStrengthLevel.medium:
        return medium();
      case PasswordStrengthLevel.strong:
        return strong();
    }
  }
}
