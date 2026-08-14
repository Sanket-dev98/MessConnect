import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Transient loading screen shown on initial app launch while the
/// [authControllerProvider] resolves (signed-in vs not).
///
/// Keeps a signed-out user from seeing a flash of the home screen before the
/// router redirect sends them to /login.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.restaurant_menu_rounded,
              size: 100,
              color: Color(0xFFE8612C),
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE8612C),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 140,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
