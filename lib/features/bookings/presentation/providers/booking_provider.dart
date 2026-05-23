import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/features/bookings/data/booking_local_data_source.dart';
import 'package:smart_campus_app/features/bookings/data/booking_remote_data_source.dart';
import 'package:smart_campus_app/features/bookings/data/booking_repository_impl.dart';
import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';

// ── Repository instance ──────────────────────────────────
final bookingRepositoryProvider = Provider<BookingRepositoryImpl>((ref) {
  return BookingRepositoryImpl(
    local: BookingLocalDataSource(),
    remote: BookingRemoteDataSource(),
  );
});

// ── Booking Provider ─────────────────────────────────────
final bookingNotifierProvider =
    NotifierProvider<BookingNotifier, AsyncValue<List<BookingModel>>>(
      BookingNotifier.new,
    );

class BookingNotifier extends Notifier<AsyncValue<List<BookingModel>>> {
  @override
  AsyncValue<List<BookingModel>> build() {
    return const AsyncValue.data([]);
  }

  BookingRepositoryImpl get _repository => ref.read(bookingRepositoryProvider);

  // Get all bookings — cache first then API
  Future<void> getBookings() async {
    try {
      state = const AsyncValue.loading();
      final bookings = await _repository.getBookings();
      state = AsyncValue.data(bookings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Create new booking
  Future<void> createBooking({
    required String facilityId,
    required String date,
    required String timeSlot,
    required String purpose,
  }) async {
    try {
      state = const AsyncValue.loading();
      final booking = await _repository.createBooking(
        facilityId: facilityId,
        date: date,
        timeSlot: timeSlot,
        purpose: purpose,
      );
      // Add new booking to current list
      final currentBookings = state.value ?? [];
      state = AsyncValue.data([...currentBookings, booking]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Update existing booking
  Future<void> updateBooking(BookingModel booking) async {
    try {
      state = const AsyncValue.loading();
      await _repository.updateBooking(booking);
      // Refresh list after update
      final bookings = await _repository.getBookings();
      state = AsyncValue.data(bookings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(String id) async {
    try {
      state = const AsyncValue.loading();
      await _repository.cancelBooking(id);
      // Remove cancelled booking from current list
      final currentBookings = state.value ?? [];
      state = AsyncValue.data(
        currentBookings.where((b) => b.id != id).toList(),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// ── Availability Provider ────────────────────────────────
final availabilityProvider =
    NotifierProvider<
      AvailabilityNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >(AvailabilityNotifier.new);

class AvailabilityNotifier
    extends Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    return const AsyncValue.data([]);
  }

  BookingRepositoryImpl get _repository => ref.read(bookingRepositoryProvider);

  // Always calls API — real time availability
  Future<void> getAvailability(String facilityId, String date) async {
    try {
      state = const AsyncValue.loading();
      final slots = await _repository.getAvailability(facilityId, date);
      state = AsyncValue.data(slots);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
