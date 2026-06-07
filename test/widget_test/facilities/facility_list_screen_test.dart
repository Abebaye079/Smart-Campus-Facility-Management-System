import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/presentation/providers/facility_provider.dart';
import 'package:smart_campus_app/features/facilities/presentation/screens/facilities_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter _testRouter() {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const FacilitiesScreen()),
      GoRoute(
        path: '/booking-step',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Booking Screen'))),
      ),
      GoRoute(
        path: '/facility-details',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Facility Details Screen')),
        ),
      ),
    ],
  );
}

// Sample facilities for testing
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

void main() {
  group('FacilitiesScreen Widget Tests', () {
    // Test 1 — Shows loading spinner while fetching
    testWidgets('shows loading indicator while facilities are being fetched', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadingFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test 2 — Shows empty state message
    testWidgets('shows no facilities found message when list is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _EmptyFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No facilities found.'), findsOneWidget);
    });

    // Test 3 — Shows facility cards when data is loaded
    testWidgets('shows facility cards when facilities are loaded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Amphitheater A'), findsOneWidget);
      expect(find.text('Lab B'), findsOneWidget);
    });

    // Test 4 — Shows correct number of Book Now buttons
    testWidgets('shows correct number of facility cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Book Now'), findsNWidgets(2));
    });
    // Test 5 — Shows error message when loading fails
    testWidgets('shows error message when facilities fail to load', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _ErrorFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to load facilities'), findsOneWidget);
    });

    // Test 6 — Search bar is visible
    testWidgets('search bar is visible on facilities screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    // Test 7 — Facilities title is visible
    testWidgets('Facilities title is displayed on screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Facilities'), findsWidgets);
    });

    // Test 8 — Each facility card shows capacity correctly
    testWidgets('each facility card displays capacity correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Capacity: 250'), findsOneWidget);
      expect(find.text('Capacity: 50'), findsOneWidget);
    });

    // Test 9 — Tapping Book Now triggers callback
    testWidgets('tapping Book Now button triggers navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityProvider.overrideWith(() => _LoadedFacilityNotifier()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );

      await tester.pumpAndSettle();

      // Tap first Book Now button
      await tester.tap(find.text('Book Now').first);
      await tester.pumpAndSettle();

      expect(find.text('Booking Screen'), findsOneWidget);
    });
  });
}

// ── Fake Notifiers for Testing ────────────────────────────

class _LoadingFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async {
    await Completer<void>().future;
    return [];
  }
}

class _EmptyFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async {
    return [];
  }
}

class _LoadedFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async {
    return _sampleFacilities;
  }
}

class _ErrorFacilityNotifier extends FacilityNotifier {
  @override
  Future<List<FacilityModel>> build() async {
    throw Exception('Network error');
  }
}
