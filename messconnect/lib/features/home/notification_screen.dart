import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.orangeSecondary,
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text('Notification ${index + 1}'),
              subtitle: const Text('New menu added for Annapurna Mess'),
              trailing: const Text('2h ago', style: TextStyle(fontSize: 10)),
            ),
          );
        },
      ),
    );
  }
}
