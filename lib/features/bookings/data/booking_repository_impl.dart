import '../domain/models/booking_model.dart';
import '../domain/repositories/booking_repository.dart';
import 'booking_local_data_source.dart';
import 'booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource local;
  final BookingRemoteDataSource remote;

  BookingRepositoryImpl({required this.local, required this.remote});

  // Cache first → if empty call API → save to cache
  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final cached = await local.getAllBookings();

      if (cached.isNotEmpty) {
        return cached;
      }

      final remoteBookings = await remote.getBookings();

      for (final booking in remoteBookings) {
        await local.insertBooking(booking);
      }

      return remoteBookings;
    } catch (e) {
      // If API fails return cached data if available
      final cached = await local.getAllBookings();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  // Create: call API first → save to SQLite
  @override
  Future<BookingModel> createBooking({
    required String facilityId,
    required String date,
    required String timeSlot,
    required String purpose,
  }) async {
    final booking = await remote.createBooking(
      facilityId: facilityId,
      date: date,
      timeSlot: timeSlot,
      purpose: purpose,
    );
    await local.insertBooking(booking);
    return booking;
  }

  // Update: call API first → update SQLite
  @override
  Future<void> updateBooking(BookingModel booking) async {
    final updatedBooking = await remote.updateBooking(booking);
    await local.updateBooking(updatedBooking);
  }

  // Cancel: call API first → delete from SQLite
  @override
  Future<void> cancelBooking(String bookingId) async {
    await remote.cancelBooking(bookingId);
    await local.deleteBooking(bookingId);
  }

  // Availability: always call API — never cached (real time)
  @override
  Future<List<Map<String, dynamic>>> getAvailability(
    String facilityId,
    String date,
  ) async {
    return await remote.getAvailability(facilityId, date);
  }
}
