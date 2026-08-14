import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'services/notifications/fcm_service.dart';

/// MessConnect app entry point.
///
/// PART 3: initialise Firebase before the widget tree mounts so Firebase Auth
/// (email + phone) is ready. PART 10: initialise FCM for push notifications.
/// PART 5: navigation is owned by the GoRouter
/// defined in [goRouterProvider]; the [DioClient] attaches the Firebase ID
/// token to API requests.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize FCM for push notifications (PART 10)
    // Don't await this so it doesn't block app startup if network/Play Services is slow.
    FcmService().init().catchError((e) => debugPrint('FCM init error: $e'));
  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  runApp(const ProviderScope(child: MessConnectApp()));
}

/// Root application widget.
class MessConnectApp extends ConsumerWidget {
  const MessConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'MessConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
