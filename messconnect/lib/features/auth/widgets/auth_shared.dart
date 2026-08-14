import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_error_text.dart';
import '../../../core/widgets/app_text_field.dart';

/// Shared scaffolding + form widgets for the auth screens. Keeps the login,
/// register and phone screens visually consistent (Material 3, responsive).
class AuthShared {
  const AuthShared._();

  /// Responsive centered card shell used by every auth screen.
  static Widget scaffold({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final padding = ResponsiveLayout.horizontalPadding(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: ResponsiveLayout.safe(
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8612C).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      size: 64,
                      color: Color(0xFFE8612C),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The ultimate mess management experience',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white38),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget field({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      obscure: obscure,
      keyboardType: keyboardType,
    );
  }

  static Widget submitButton({
    required VoidCallback? onPressed,
    required String label,
    bool busy = false,
  }) {
    return AppButton(label: label, onPressed: onPressed, busy: busy);
  }

  /// Inline error text + spacing for failed auth attempts.
  static Widget errorText(Object? error) => AppErrorText(error);

  static Widget switchButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
