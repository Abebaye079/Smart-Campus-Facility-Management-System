import '../domain/models/booking_model.dart';
import '../domain/repositories/booking_repository.dart';

import 'booking_local_data_source.dart';
import 'booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource local;
  final BookingRemoteDataSource remote;

  BookingRepositoryImpl({
    required this.local,
    required this.remote,
  });

  @override
  Future<List<BookingModel>> getBookings() async {
    final cached = await local.getAllBookings();

    if (cached.isNotEmpty) {
      return cached;
    }

    final remoteBookings = await remote.getBookings();

    for (final booking in remoteBookings) {
      await local.insertBooking(booking);
    }

    return remoteBookings;
  }

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

  @override
  Future<void> cancelBooking(String bookingId) async {
    await remote.cancelBooking(bookingId);

    await local.deleteBooking(bookingId);
  }

  @override
  Future<void> updateBooking(BookingModel booking) async {
    await local.updateBooking(booking);
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailability(
    String facilityId,
    String date,
  ) async {
    return [];
  }
}
