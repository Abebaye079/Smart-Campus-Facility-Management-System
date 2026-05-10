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
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/manage_facilities_screen.dart';
import '../../features/admin/presentation/screens/add_facility_screen.dart';
import '../../features/admin/presentation/screens/admin_profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
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
      builder: (context, state) => const FacilitiesDetailScreen(),
    ),
    GoRoute(
      path: RouteNames.bookingStep,
      builder: (context, state) => const BookingConfirmationScreen(),
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
