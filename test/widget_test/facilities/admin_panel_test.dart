import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';
import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/presentation/providers/facility_provider.dart';
import 'package:smart_campus_app/features/admin_panel/presentation/screens/admin_dashboard_screen.dart';
import 'package:smart_campus_app/features/admin_panel/presentation/screens/manage_facilities_screen.dart';

// ── Sample Data ───────────────────────────────────────────

final _adminUser = UserModel(
  id: 'admin_001',
  name: 'Sarah Taye',
  email: 'sarah.taye@university.edu',
  role: 'admin',
  token: 'admin_token',
);

final _regularUser = UserModel(
  id: 'user_001',
  name: 'Abel Teshome',
  email: 'abel@uni.edu',
  role: 'user',
  token: 'user_token',
);

final _sampleFacilities = [
  FacilityModel(
    id: 'fac_001',
    name: 'Amphitheater A',
    description: 'Main Campus Hall',
    capacity: 250,
    type: 'Hall',
  ),
  FacilityModel(
    id: 'fac_002',
    name: 'Lab B',
    description: 'Computer Lab',
    capacity: 50,
    type: 'Lab',
  ),
];

// ── Test Router ───────────────────────────────────────────

GoRouter _testRouter(Widget home) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => home),
      GoRoute(
        path: '/admin/manage',
        builder: (context, state) => const ManageFacilitiesScreen(),
      ),
      GoRoute(
        path: '/admin/add',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Add Facility Screen'))),
      ),
    ],
  );
}

// ── Fake Notifiers ────────────────────────────────────────

class _AdminAuthNotifier extends AuthNotifier {
  @override
  Future<UserModel?> build() async => _adminUser;
}

class _UserAuthNotifier extends AuthNotifier {
  @override
  Future<UserModel?> build() async => _regularUser;
}

class _LoadedFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async => _sampleFacilities;
}

class _EmptyFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async => [];
}

class _LoadingFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async {
    await Completer<void>().future;
    return [];
  }
}

class _ErrorFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async {
    throw Exception('Network error');
  }
}

// ── Tests ─────────────────────────────────────────────────

void main() {
  group('Admin Dashboard Screen Tests', () {
    // Test 1 — Admin dashboard shows welcome message
    testWidgets('admin dashboard shows welcome message with admin name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => _AdminAuthNotifier())],
          child: MaterialApp.router(
            routerConfig: _testRouter(const AdminDashboardScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome, Sarah Taye!'), findsOneWidget);
    });

    // Test 2 — Admin dashboard shows View Facilities button
    testWidgets('admin dashboard shows View Facilities card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => _AdminAuthNotifier())],
          child: MaterialApp.router(
            routerConfig: _testRouter(const AdminDashboardScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('View Facilities'), findsOneWidget);
    });

    // Test 3 — Admin dashboard shows Add Facility button
    testWidgets('admin dashboard shows Add Facility button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => _AdminAuthNotifier())],
          child: MaterialApp.router(
            routerConfig: _testRouter(const AdminDashboardScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('+ Add Facility'), findsOneWidget);
    });

    // Test 4 — Admin dashboard shows admin bottom nav
    testWidgets('admin dashboard shows admin bottom navigation bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => _AdminAuthNotifier())],
          child: MaterialApp.router(
            routerConfig: _testRouter(const AdminDashboardScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Admin nav has Dashboard, Manage, Add, Profile
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    // Test 5 — Tapping View Facilities navigates to manage screen
    testWidgets(
      'tapping View Facilities navigates to manage facilities screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AdminAuthNotifier()),
              facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
            ],
            child: MaterialApp.router(
              routerConfig: _testRouter(const AdminDashboardScreen()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('View Facilities'));
        await tester.pumpAndSettle();

        expect(find.text('Manage Facilities'), findsOneWidget);
      },
    );

    // Test 6 — Shows fallback Admin when user name is null
    testWidgets('admin dashboard shows Admin as fallback when name is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => _AdminAuthNotifier())],
          child: MaterialApp.router(
            routerConfig: _testRouter(const AdminDashboardScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome,'), findsOneWidget);
    });
  });

  group('Manage Facilities Screen Tests', () {
    // Test 7 — Shows loading spinner
    testWidgets('shows loading indicator while facilities are loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadingFacilityNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: _testRouter(const ManageFacilitiesScreen()),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test 8 — Shows empty state
    testWidgets('shows no facilities available when list is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _EmptyFacilityNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: _testRouter(const ManageFacilitiesScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No facilities available.'), findsOneWidget);
    });

    // Test 9 — Shows facility list with Edit and Delete buttons
    testWidgets('shows facilities with Edit and Delete buttons for admin', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: _testRouter(const ManageFacilitiesScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Amphitheater A'), findsOneWidget);
      expect(find.text('Lab B'), findsOneWidget);
      // Edit and Delete buttons must be visible
      expect(find.text('Edit'), findsWidgets);
      expect(find.text('Delete'), findsWidgets);
    });

    // Test 10 — Shows Manage Facilities title
    testWidgets('shows Manage Facilities title on screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: _testRouter(const ManageFacilitiesScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Manage Facilities'), findsOneWidget);
    });

    // Test 11 — Tapping Delete shows confirmation dialog
    testWidgets('tapping Delete button shows confirmation dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: _testRouter(const ManageFacilitiesScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete').first);
      await tester.pumpAndSettle();

      expect(find.text('Confirm deletion?'), findsOneWidget);
    });

    // Test 12 — Tapping Edit shows edit dialog
    testWidgets('tapping Edit button shows edit dialog with facility data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: _testRouter(const ManageFacilitiesScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit').first);
      await tester.pumpAndSettle();

      expect(find.text('Save Changes'), findsOneWidget);
    });

    // Test 13 — Shows error message when loading fails
    testWidgets('shows error message when facilities fail to load', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _ErrorFacilityNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: _testRouter(const ManageFacilitiesScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    // Test 14 — Admin bottom nav is visible on manage screen
    testWidgets(
      'admin bottom navigation is visible on manage facilities screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
            ],
            child: MaterialApp.router(
              routerConfig: _testRouter(const ManageFacilitiesScreen()),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.text('Manage'), findsWidgets);
      },
    );
  });
}
