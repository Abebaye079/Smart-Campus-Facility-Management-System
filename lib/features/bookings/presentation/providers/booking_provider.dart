import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier,
        AsyncValue<List<BookingModel>>>(
  (ref) => BookingNotifier(),
);

class BookingNotifier
    extends StateNotifier<AsyncValue<List<BookingModel>>> {
  BookingNotifier() : super(const AsyncValue.loading());

  final List<BookingModel> _bookings = [];

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

  Future<void> updateBooking(
    String id,
    BookingModel updatedBooking,
  ) async {
    try {
      state = const AsyncValue.loading();

      await Future.delayed(const Duration(seconds: 1));

      final index =
          _bookings.indexWhere((booking) => booking.id == id);

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

      _bookings.removeWhere(
        (booking) => booking.id == id,
      );

      state = AsyncValue.data(List.from(_bookings));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final availabilityProvider =
    StateNotifierProvider<AvailabilityNotifier,
        AsyncValue<List<Map<String, dynamic>>>>(
  (ref) => AvailabilityNotifier(),
);

class AvailabilityNotifier extends StateNotifier<
    AsyncValue<List<Map<String, dynamic>>>> {
  AvailabilityNotifier()
      : super(const AsyncValue.loading());

  Future<void> getAvailability(
    String facilityId,
    String date,
  ) async {
    try {
      state = const AsyncValue.loading();

      await Future.delayed(const Duration(seconds: 1));

      state = AsyncValue.data([
        {
          'time': '9:00 AM - 10:00 AM',
          'available': false,
        },
        {
          'time': '10:00 AM - 11:00 AM',
          'available': true,
        },
        {
          'time': '11:00 AM - 12:00 PM',
          'available': true,
        },
        {
          'time': '1:00 PM - 2:00 PM',
          'available': true,
        },
      ]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
