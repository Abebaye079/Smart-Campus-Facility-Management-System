import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';
import 'package:smart_campus_app/features/bookings/data/booking_remote_data_source.dart';

// ================= DATA SOURCE =================
final bookingDataSourceProvider = Provider((ref) => BookingRemoteDataSource());

// ================= AVAILABILITY =================
final availabilityProvider =
    NotifierProvider<
      AvailabilityNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >(AvailabilityNotifier.new);

class AvailabilityNotifier
    extends Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  List<Map<String, dynamic>> _lastData = [];

  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    return const AsyncValue.data([]);
  }

  Future<void> getAvailability(String facilityId, String date) async {
    state = const AsyncValue.loading();

    try {
      final response = await ref
          .read(bookingDataSourceProvider)
          .getAvailability(facilityId: facilityId, date: date);

      // 🔥 FORCE NEW OBJECT REFERENCE (CRITICAL FIX)
      _lastData = List<Map<String, dynamic>>.from(response);

      state = AsyncValue.data([..._lastData]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// ================= BOOKINGS =================
final bookingNotifierProvider =
    NotifierProvider<BookingNotifier, AsyncValue<List<BookingModel>>>(
      BookingNotifier.new,
    );

class BookingNotifier extends Notifier<AsyncValue<List<BookingModel>>> {
  @override
  AsyncValue<List<BookingModel>> build() {
    getBookings();
    return const AsyncValue.loading();
  }

  Future<void> getBookings() async {
    try {
      final list = await ref.read(bookingDataSourceProvider).getBookings();

      state = AsyncValue.data(List.from(list)); // force refresh
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    state = const AsyncValue.loading();

    try {
      await ref
          .read(bookingDataSourceProvider)
          .createBooking(
            facilityId: booking.facilityId,
            date: booking.date,
            timeSlot: booking.timeSlot,
            purpose: booking.purpose,
          );

      await getBookings();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateBooking(String id, BookingModel booking) async {
    state = const AsyncValue.loading();

    try {
      await ref.read(bookingDataSourceProvider).updateBooking(id, booking);

      await getBookings();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> cancelBooking(String id) async {
    state = const AsyncValue.loading();

    try {
      await ref.read(bookingDataSourceProvider).cancelBooking(id);
      await getBookings();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
