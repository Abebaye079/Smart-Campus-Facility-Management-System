import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/route_names.dart';

// Splash
import '../../features/splash/presentation/screens/splash_screen.dart';

// Auth
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';

// User
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/facilities/presentation/screens/facilities_screen.dart';
import '../../features/facilities/presentation/screens/facilities_detail_screen.dart';
import '../../features/facilities/presentation/screens/booking_confirmation_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/info/presentation/screens/about_screen.dart';
import '../../features/info/presentation/screens/faq_screen.dart';

// Admin
import '../../features/admin_panel/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin_panel/presentation/screens/manage_facilities_screen.dart';
import '../../features/admin_panel/presentation/screens/add_facility_screen.dart';
import '../../features/admin_panel/presentation/screens/admin_profile_screen.dart';

// Auth Provider
import '../../features/auth/presentation/providers/auth_provider.dart';

import '../../features/facilities/domain/models/facility_model.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,

    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      if (authState.isLoading) {
        return currentPath == RouteNames.splash ? null : RouteNames.splash;
      }

      final user = authState.value;
      final isLoggedIn = user != null;
      final isAdmin = user?.role == 'admin';

      final isAuthScreen = currentPath == RouteNames.login ||
          currentPath == RouteNames.signup ||
          currentPath == RouteNames.splash;

      if (!isLoggedIn && !isAuthScreen) {
        return RouteNames.login;
      }

      if (isLoggedIn && isAdmin && isAuthScreen) {
        return RouteNames.adminDashboard;
      }

      if (isLoggedIn && !isAdmin && isAuthScreen) {
        return RouteNames.home;
      }

      if (isLoggedIn && isAdmin && _isUserOnlyScreen(currentPath)) {
        return RouteNames.adminDashboard;
      }

      if (isLoggedIn && !isAdmin && _isAdminOnlyScreen(currentPath)) {
        return RouteNames.home;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.facilities,
        builder: (context, state) => const FacilitiesScreen(),
      ),

      GoRoute(
        path: RouteNames.facilityDetails,
        builder: (context, state) {
          final facility = state.extra as FacilityModel;
          return FacilitiesDetailScreen(facility: facility);
        },
      ),

      GoRoute(
        path: RouteNames.bookingStep,
        builder: (context, state) {
          return const BookingConfirmationScreen();
        },
      ),

      GoRoute(
        path: RouteNames.bookings,
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: RouteNames.faq,
        builder: (context, state) => const FAQScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.manageFacilities,
        builder: (context, state) => const ManageFacilitiesScreen(),
      ),
      GoRoute(
        path: RouteNames.addFacility,
        builder: (context, state) => const AddFacilityScreen(),
      ),
      GoRoute(
        path: RouteNames.adminProfile,
        builder: (context, state) => const AdminProfileScreen(),
      ),
    ],
  );
});

bool _isAdminOnlyScreen(String path) {
  return path.startsWith('/admin');
}

bool _isUserOnlyScreen(String path) {
  const userScreens = [
    '/home',
    '/facilities',
    '/facility-details',
    '/booking-step',
    '/bookings',
    '/profile',
  ];
  return userScreens.contains(path);
}