import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Messes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Discovery Page - List of all messes will appear here'),
      ),
    );
  }
}
