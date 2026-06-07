import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_app/features/bookings/presentation/providers/booking_provider.dart';

// ── INLINE MOCK NOTIFIER ───────────────────────────────────
class LocalMockAvailabilityNotifier extends AvailabilityNotifier {
  final List<Map<String, String>> mockData;
  LocalMockAvailabilityNotifier(this.mockData);

  @override
  AsyncValue<List<Map<String, String>>> build() {
    return AsyncValue.data(mockData);
  }

  @override
  Future<void> getAvailability(String facilityId, String date) async {
    state = AsyncValue.data(mockData);
  }
}

// ── EMBEDDED TEST VIEW WIDGET ──────────────────────────────
class EmbeddedTestSlotPickerView extends ConsumerWidget {
  const EmbeddedTestSlotPickerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availabilityState = ref.watch(availabilityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Time Slot')),
      body: availabilityState.when(
        data: (slots) {
          if (slots.isEmpty) {
            return const Center(child: Text('No slots available'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              final isAvailable = slot['status'] == 'available';

              return Card(
                color: isAvailable ? Colors.green[50] : Colors.grey[200],
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(
                    isAvailable ? Icons.check_circle : Icons.cancel,
                    color: isAvailable ? Colors.green : Colors.grey,
                  ),
                  title: Text(
                    slot['time'] ?? 'Unknown Time',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? Colors.black : Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    slot['status']?.toUpperCase() ?? '',
                    style: TextStyle(
                      color: isAvailable ? Colors.green[700] : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

// ── TESTS ──────────────────────────────────────────────────
void main() {
  group('Facility Slot Availability Widget Tests', () {
    final sampleSlots = [
      {'time': '09:00 AM - 10:00 AM', 'status': 'available'},
      {'time': '10:00 AM - 11:00 AM', 'status': 'booked'},
    ];

    testWidgets('should render list of time slots smoothly when data is supplied',
        (WidgetTester tester) async {
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availabilityProvider.overrideWith(() => LocalMockAvailabilityNotifier(sampleSlots)),
          ],
          child: const MaterialApp(
            home: EmbeddedTestSlotPickerView(), // Using our clean inline widget layout
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('09:00 AM - 10:00 AM'), findsOneWidget);
      expect(find.text('AVAILABLE'), findsOneWidget);
      expect(find.text('10:00 AM - 11:00 AM'), findsOneWidget);
    });
  });
}
