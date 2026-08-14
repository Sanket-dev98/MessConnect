import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_theme.dart';
import 'auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sahil Patel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkGrey),
            ),
            const Text('Student ID: MC12345', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            _ProfileTile(icon: Icons.person_outline, title: 'Edit Profile', onTap: () {}),
            _ProfileTile(icon: Icons.history, title: 'Order History', onTap: () {}),
            _ProfileTile(icon: Icons.settings_outlined, title: 'Settings', onTap: () {}),
            const Spacer(),
            ElevatedButton(
              onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('LOGOUT'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.navyPrimary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
