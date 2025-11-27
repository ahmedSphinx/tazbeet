import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  double _calculateStrength() {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // Length check
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.15;

    // Contains uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;

    // Contains lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;

    // Contains numbers
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.1;

    // Contains special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.1;

    return strength.clamp(0.0, 1.0);
  }

  String _getStrengthText(double strength) {
    if (strength == 0) return 'Enter password';
    if (strength < 0.3) return 'Weak';
    if (strength < 0.7) return 'Medium';
    return 'Strong';
  }

  Color _getStrengthColor(double strength) {
    if (strength == 0) return Colors.grey;
    if (strength < 0.3) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength();
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: strength, backgroundColor: Theme.of(context).colorScheme.surfaceVariant, valueColor: AlwaysStoppedAnimation<Color>(strengthColor), minHeight: 4),
        ),
        const SizedBox(height: 4),
        Text(
          strengthText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: strengthColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
