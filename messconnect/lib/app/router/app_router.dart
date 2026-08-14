import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/phone_otp_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/role_selection_screen.dart';
import '../../features/auth/profile_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/student_dashboard.dart';
import '../../features/home/notification_screen.dart';
import '../../features/discovery/discovery_screen.dart';
import '../../features/mess_detail/screens/mess_detail_screen.dart';
import '../../features/subscriptions/khata_screen.dart';
import '../splash/splash_screen.dart';
import '../../features/auth/auth_controller.dart';

/// Centralized, auth-gated router for MessConnect.
///
/// PART 5 — owns all navigation. The [redirect] consults the
/// [authControllerProvider] [User?] state and sends signed-out users to
/// /login and signed-in users away from the auth routes. While auth is still
/// resolving the app stays on the splash (/).
final goRouterProvider = Provider<GoRouter>((ref) {
  // Comment out auth logic for UI prototype testing
  // final auth = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/role-selection',
    debugLogDiagnostics: false,
    /* 
    redirect: (context, state) {
      // Auth logic disabled for UI prototype review
      return null;
    },
    */
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: '/khata',
        builder: (context, state) => const KhataScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/discovery',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: '/mess-detail',
        builder: (context, state) => const MessDetailScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'mess/:id',
            builder: (context, state) => MessDetailScreen(
              messId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'phone',
            builder: (context, state) => const PhoneOtpScreen(),
          ),
        ],
      ),
    ],
  );
});
