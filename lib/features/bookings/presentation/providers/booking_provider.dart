import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';

// ── Booking Provider ─────────────────────────────────────
final bookingNotifierProvider = NotifierProvider<BookingNotifier,
    AsyncValue<List<BookingModel>>>(
  BookingNotifier.new,
);

class BookingNotifier
    extends Notifier<AsyncValue<List<BookingModel>>> {
  final List<BookingModel> _bookings = [];

  @override
  AsyncValue<List<BookingModel>> build() {
    return const AsyncValue.data([]);
  }

  Future<void> getBookings() async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data(_bookings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      _bookings.add(booking);
      state = AsyncValue.data(List.from(_bookings));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateBooking(String id, BookingModel updatedBooking) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bookings[index] = updatedBooking;
      }
      state = AsyncValue.data(List.from(_bookings));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      _bookings.removeWhere((b) => b.id == id);
      state = AsyncValue.data(List.from(_bookings));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// ── Availability Provider ────────────────────────────────
final availabilityProvider = NotifierProvider<AvailabilityNotifier,
    AsyncValue<List<Map<String, dynamic>>>>(
  AvailabilityNotifier.new,
);

class AvailabilityNotifier
    extends Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    return const AsyncValue.data([]);
  }

  Future<void> getAvailability(String facilityId, String date) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data([
        {'time': '9:00 AM - 10:00 AM', 'available': false},
        {'time': '10:00 AM - 11:00 AM', 'available': true},
        {'time': '11:00 AM - 12:00 PM', 'available': true},
        {'time': '1:00 PM - 2:00 PM', 'available': true},
      ]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}