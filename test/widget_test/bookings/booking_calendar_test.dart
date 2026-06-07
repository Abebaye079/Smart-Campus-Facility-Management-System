import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';
import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:smart_campus_app/features/bookings/presentation/providers/booking_provider.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/presentation/screens/booking_confirmation_screen.dart';

// ── Sample Data ───────────────────────────────────────────

final _testFacility = FacilityModel(
  id: 'fac_001',
  name: 'Room 101',
  description: 'A spacious classroom',
  capacity: 30,
  type: 'Classroom',
);

final _testUser = UserModel(
  id: 'user_001',
  name: 'Abel Teshome',
  email: 'abel@uni.edu',
  role: 'user',
  token: 'test_token',
);

final _sampleSlots = [
  {'time': '9:00 AM - 10:00 AM', 'available': true},
  {'time': '10:00 AM - 11:00 AM', 'available': false},
];

// ── Test Router ───────────────────────────────────────────

GoRouter _testRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BookingConfirmationScreen(
          facility: _testFacility,
        ),
      ),
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Bookings Screen')),
        ),
      ),
    ],
  );
}

// ── Fake Notifiers ────────────────────────────────────────

class _AuthNotifier extends AuthNotifier {
  @override
  Future<UserModel?> build() async => _testUser;
}

class _LoadedAvailabilityNotifier extends AvailabilityNotifier {
  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    return AsyncValue.data(_sampleSlots);
  }
}

class _ErrorAvailabilityNotifier extends AvailabilityNotifier {
  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    return AsyncValue.error(
      Exception('Failed to load slots'),
      StackTrace.current,
    );
  }
}

// ── Tests ─────────────────────────────────────────────────

void main() {
  group('BookingConfirmationScreen Calendar Tests', () {

    // Test 1 — Screen renders with facility name
    testWidgets(
      'shows facility name on booking confirmation screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Room 101'), findsOneWidget);
      },
    );

    // Test 2 — Shows FINALIZING YOUR BOOKING text
    testWidgets(
      'shows FINALIZING YOUR BOOKING subtitle',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('FINALIZING YOUR BOOKING'), findsOneWidget);
      },
    );
    // Test 3 — Calendar widget renders on screen
    testWidgets(
      'calendar widget renders correctly on screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(TableCalendar), findsOneWidget);
      },
    );

    // Test 4 — Select Time Slot heading is visible
    testWidgets(
      'Select Time Slot heading is visible',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Select Time Slot'), findsOneWidget);
      },
    );

    // Test 5 — Purpose text field is visible
    testWidgets(
      'purpose text field is visible on screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      },
    );

    // Test 6 — Purpose field accepts input
    testWidgets(
      'purpose text field accepts user input',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField),
          'Programming Workshop',
        );
        await tester.pump();

        expect(find.text('Programming Workshop'), findsOneWidget);
      },
    );

    // Test 7 — Confirm Booking button is visible
    testWidgets(
      'Confirm Booking button is visible on screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Confirm Booking'), findsOneWidget);
      },
    );

    // Test 8 — Confirm Booking disabled when no slot selected
    testWidgets(
      'Confirm Booking button is disabled when no time slot selected',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _LoadedAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();
        final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Confirm Booking'),
        );
        // Button must be disabled when no slot is selected
        expect(button.onPressed, isNull);
      },
    );

    // Test 9 — Shows error and retry button when slots fail
    testWidgets(
      'shows error message and retry button when slots fail to load',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _AuthNotifier()),
              availabilityProvider.overrideWith(
                () => _ErrorAvailabilityNotifier(),
              ),
            ],
            child: MaterialApp.router(routerConfig: _testRouter()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Failed to load time slots'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });
}
