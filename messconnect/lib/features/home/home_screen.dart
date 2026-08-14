import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_profile.dart';
import '../../core/widgets/app_async_builder.dart';
import '../../features/auth/auth_controller.dart';
import 'mess_dashboard.dart';
import 'student_dashboard.dart';

/// PART 6 Discovery hub / Dashboard Router.
///
/// Switches between [StudentDashboard] and [MessDashboard] based on user role.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return AppAsyncBuilder<UserProfile?>(
      value: profileAsync,
      data: (context, profile) {
        if (profile == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Profile not found.'),
                  TextButton(
                    onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          );
        }

        if (profile.role == UserRole.messOwner) {
          return const MessDashboard();
        }

        return const StudentDashboard();
      },
      error: (context, error, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Connection Error',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Make sure you have enabled Firestore in Firebase Console and your device is online.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.invalidate(userProfileProvider),
                  child: const Text('Retry Connection'),
                ),
                TextButton(
                  onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
