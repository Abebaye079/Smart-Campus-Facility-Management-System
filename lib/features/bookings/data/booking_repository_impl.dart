import '../domain/models/booking_model.dart';
import '../domain/repositories/booking_repository.dart';
import 'booking_local_data_source.dart';
import 'booking_remote_data_source.dart';
import '../../auth/data/auth_local_data_source.dart'; 

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource local;
  final BookingRemoteDataSource remote;
  final AuthLocalDataSource authLocal; 

  BookingRepositoryImpl({
    required this.local, 
    required this.remote,
    required this.authLocal,
  });

  Future<String> _getCurrentUserId() async {
    final user = await authLocal.getUser();
    if (user == null) {
      throw Exception("No authenticated user found. Cannot perform booking actions.");
    }
    return user.id;
  }

  // Cache first → if empty call API → save to cache
  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final userId = await _getCurrentUserId();
      final cached = await local.getAllBookings(userId);

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
      try {
        final userId = await _getCurrentUserId();
        final cached = await local.getAllBookings(userId);
        if (cached.isNotEmpty) return cached;
      } catch (_) {}
      rethrow;
    }
  }

  // Create: call API first → save to SQLite
  @override
  Future<BookingModel> createBooking({
    required String facilityId,
    required String facilityName,
    required String date,
    required String timeSlot,
    required String purpose,
  }) async {
    final booking = await remote.createBooking(
      facilityId: facilityId,
      facilityName: facilityName,
      date: date,
      timeSlot: timeSlot,
      purpose: purpose,
    );
    await local.insertBooking(booking);
    return booking;
  }

  @override
  Future<void> updateBooking(BookingModel booking) async {
    final updatedBooking = await remote.updateBooking(booking);
    await local.updateBooking(updatedBooking);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await remote.cancelBooking(bookingId);
    await local.deleteBooking(bookingId);
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailability(
    String facilityId,
    String date,
  ) async {
    return await remote.getAvailability(facilityId, date);
  }
}